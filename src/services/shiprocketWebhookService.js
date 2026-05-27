/**
 * Shiprocket Webhook Service
 * Handles incoming webhooks from Shiprocket and updates order status
 */

import prisma from '../utils/prisma.js';
import { logger } from '../utils/logger.js';
import { logActivity } from './activityService.js';
import { sendMail, TEMPLATES } from '../utils/mailer.js';

const computeNextRetryAt = (attempts) => {
  const baseDelayMs = 60_000; // 1m
  const cappedAttempt = Math.min(Math.max(1, attempts), 6);
  const delay = baseDelayMs * Math.pow(2, cappedAttempt - 1); // 1m,2m,4m,8m,16m,32m
  return new Date(Date.now() + Math.min(delay, 60 * 60 * 1000)); // cap at 60m
};

/**
 * Map Shiprocket status to internal order status
 */
export const mapShiprocketStatus = (shiprocketStatus) => {
  const normalizedStatus = String(shiprocketStatus || '').trim().toUpperCase();
  const statusMap = {
    'SHIPPED': 'SHIPPED',
    'IN TRANSIT': 'IN_TRANSIT',
    'OUT FOR DELIVERY': 'OUT_FOR_DELIVERY',
    'DELIVERED': 'DELIVERED',
    'PICKUP SCHEDULED': 'PICKUP_SCHEDULED',
    'PICKUP FAILED': 'PICKUP_FAILED',
    'RETURN RECEIVED': 'RETURN_RECEIVED',
    'RTO': 'CANCELED',
    'CANCELLED': 'CANCELED',
    'PENDING': 'ORDERED',
    'READY_TO_SHIP': 'ORDERED',
    'UNDELIVERED': 'SHIPPED'
  };

  return statusMap[normalizedStatus] || normalizedStatus.replace(/[^A-Z0-9]+/g, '_') || 'ORDERED';
};

/**
 * Extract important fields from Shiprocket webhook payload
 */
export const extractWebhookPayload = (body) => {
  const rawOrderId = body.order_id || body.customer_reference_id;
  const isReturnShipment = Boolean(body.is_return === 1 || body.is_return === true || /^RETURN-/i.test(String(rawOrderId || '')));
  const baseOrderId = String(rawOrderId || '').replace(/^RETURN-/i, '');

  return {
    awb: body.awb || body.awb_number || body.tracking_number,
    shiprocketStatus: body.current_status || body.shipment_status || body.status,
    orderId: rawOrderId,
    baseOrderId: baseOrderId || rawOrderId,
    isReturnShipment,
    courierName: body.courier_name || body.courier || 'Unknown',
    eventTime: body.event_time || body.timestamp || new Date().toISOString(),
    rawPayload: body
  };
};

/**
 * Find order by order_id or awb
 */
const findOrderByIdOrAwb = async (orderId, awb) => {
  let order = null;

  // Try to find by orderId first
  if (orderId) {
    order = await prisma.order.findUnique({
      where: { id: orderId },
      include: {
        customer: { select: { email: true, name: true } },
        items: true,
        activities: { orderBy: { createdAt: 'desc' }, take: 5 }
      }
    });
  }

  // If not found and awb exists, resolve via Shipment table (awb is unique there).
  if (!order && awb) {
    const shipment = await prisma.shipment.findUnique({
      where: { awb: String(awb) },
      select: { orderId: true },
    }).catch(() => null);

    if (shipment?.orderId) {
      order = await prisma.order.findUnique({
        where: { id: shipment.orderId },
        include: {
          customer: { select: { email: true, name: true } },
          items: true,
          activities: { orderBy: { createdAt: 'desc' }, take: 5 }
        }
      });
    }
  }

  return order;
};

/**
 * Check if status update is a duplicate (idempotency check)
 */
const isDuplicateUpdate = (currentStatus, newStatus, lastActivityTime) => {
  // If same status, likely a duplicate
  if (currentStatus === newStatus) {
    return true;
  }

  // Shiprocket can send status bursts; don't suppress legitimate transitions just because
  // another activity happened recently. The "same status" check above is the safe guard.
  void lastActivityTime;

  return false;
};

/**
 * Update order status from Shiprocket webhook
 * Returns { success: boolean, message: string, order?: Order, error?: string }
 */
export const updateOrderFromShiprocket = async (payload, { webhookLogId } = {}) => {
  try {
    // Extract webhook data
    const { awb, shiprocketStatus, orderId, baseOrderId, isReturnShipment, courierName, eventTime } = extractWebhookPayload(payload);
    const lookupOrderId = baseOrderId || orderId;

    logger.info('shiprocket.webhook.processing', {
      awb: awb ? String(awb) : null,
      shiprocket_status: shiprocketStatus ? String(shiprocketStatus) : null,
      order_id: orderId ? String(orderId) : null,
      courier: courierName ? String(courierName) : null,
      event_time: eventTime ? String(eventTime) : null,
      webhook_log_id: webhookLogId || null,
    });

    // Validate required fields
    if (!shiprocketStatus) {
      const errorMsg = 'Missing shiprocket status in webhook payload';
      if (webhookLogId) {
        await prisma.webhookLog.update({
          where: { id: webhookLogId },
          data: {
            processed: false,
            processingError: errorMsg,
            attempts: { increment: 1 },
            lastAttemptAt: new Date(),
            nextRetryAt: computeNextRetryAt(1),
          },
        }).catch(() => null);
      }
      return {
        success: false,
        error: errorMsg
      };
    }

    if (!orderId) {
      const errorMsg = 'Missing order_id in webhook payload. Cannot locate order.';
      if (webhookLogId) {
        await prisma.webhookLog.update({
          where: { id: webhookLogId },
          data: {
            processed: false,
            processingError: errorMsg,
            attempts: { increment: 1 },
            lastAttemptAt: new Date(),
            nextRetryAt: computeNextRetryAt(1),
          },
        }).catch(() => null);
      }
      return {
        success: false,
        error: errorMsg
      };
    }

    // Find the order
    const order = await findOrderByIdOrAwb(lookupOrderId, awb);

    if (!order) {
      const errorMsg = `Order not found with ID: ${orderId}`;
      console.warn(`[Shiprocket] ${errorMsg}`);
      if (webhookLogId) {
        await prisma.webhookLog.update({
          where: { id: webhookLogId },
          data: {
            processed: false,
            processingError: errorMsg,
            attempts: { increment: 1 },
            lastAttemptAt: new Date(),
            nextRetryAt: computeNextRetryAt(1),
          },
        }).catch(() => null);
      }
      return {
        success: false,
        error: errorMsg
      };
    }

    // Map Shiprocket status to internal status
    const internalStatus = mapShiprocketStatus(shiprocketStatus);

    // Persist event for analytics/timeline (best-effort)
    prisma.shipmentTrackingEvent.create({
      data: {
        provider: 'SHIPROCKET',
        source: 'WEBHOOK',
        orderId: order.id,
        awb: awb ? String(awb) : null,
        shipmentId: payload?.shipment_id ? String(payload.shipment_id) : null,
        status: internalStatus,
        eventTime: new Date(eventTime || Date.now()),
        raw: payload || {},
      },
    }).catch(() => null);

    // Keep Shipment table in sync (best-effort). This powers admin visibility + customer tracking endpoints.
    const webhookShipmentId = payload?.shipment_id ? String(payload.shipment_id) : null;
    const webhookAwb = awb ? String(awb) : null;

    if (webhookAwb || webhookShipmentId) {
      const existingShipment = await prisma.shipment.findUnique({
        where: { orderId: order.id },
      }).catch(() => null);

      if (existingShipment) {
        const updateData = {
          ...(webhookAwb ? { awb: webhookAwb } : {}),
          ...(webhookShipmentId ? { shipmentId: webhookShipmentId } : {}),
          ...(courierName ? { courier: String(courierName) } : {}),
          status: internalStatus || existingShipment.status,
        };

        // Avoid unique constraint crashes if Shiprocket sends a conflicting AWB for a different order.
        await prisma.shipment.update({
          where: { orderId: order.id },
          data: updateData,
        }).catch((err) => {
          logger.warn('shiprocket.shipment_sync.update_failed', {
            order_id: order.id,
            message: err?.message,
          });
        });
      } else if (webhookAwb && webhookShipmentId) {
        await prisma.shipment.create({
          data: {
            orderId: order.id,
            awb: webhookAwb,
            shipmentId: webhookShipmentId,
            courier: courierName ? String(courierName) : 'Shiprocket',
            status: internalStatus || 'UNKNOWN',
          },
        }).catch((err) => {
          logger.warn('shiprocket.shipment_sync.create_failed', {
            order_id: order.id,
            message: err?.message,
          });
        });
      }
    }

    // Reverse pickup lifecycle for return/exchange shipments is tracked separately from forward order delivery.
    if (isReturnShipment || String(orderId || '').toUpperCase().startsWith('RETURN-')) {
      const returnRequest = await prisma.returnRequest.findFirst({
        where: { orderId: order.id },
        include: {
          order: {
            include: {
              items: {
                include: { product: true }
              }
            }
          }
        }
      });

      if (!returnRequest) {
        logger.warn('shiprocket.return_request_not_found', { order_id: order.id, shiprocket_status: shiprocketStatus });
        return {
          success: true,
          message: 'Return shipment webhook received but no return request was found',
          order
        };
      }

      const pickupStatusMap = {
        PICKUP_SCHEDULED: 'SCHEDULED',
        PICKUP_FAILED: 'FAILED',
        IN_TRANSIT: 'IN_TRANSIT',
        RETURN_RECEIVED: 'RECEIVED',
        DELIVERED: 'RECEIVED'
      };

      const nextPickupStatus = pickupStatusMap[internalStatus] || returnRequest.pickupStatus || 'REQUESTED';
      const isReceivedAtWarehouse = nextPickupStatus === 'RECEIVED';

      await prisma.returnRequest.update({
        where: { id: returnRequest.id },
        data: {
          pickupStatus: nextPickupStatus,
          ...(isReceivedAtWarehouse ? { inspectionStatus: 'RECEIVED' } : {})
        }
      });

      await prisma.order.update({
        where: { id: order.id },
        data: {
          status: isReceivedAtWarehouse
            ? (returnRequest.type || 'RETURN').toUpperCase() === 'EXCHANGE'
              ? 'EXCHANGE_RECEIVED'
              : 'RETURN_RECEIVED'
            : order.status
        }
      }).catch(() => null);

      await logActivity(
        order.id,
        isReceivedAtWarehouse ? 'RETURN_SHIPMENT_RECEIVED' : internalStatus,
        `Shiprocket reverse shipment update: ${shiprocketStatus} (AWB: ${awb || 'N/A'}, Courier: ${courierName})`
      );

      const customerEmail = returnRequest.order?.customer?.email || returnRequest.order?.shippingAddress?.email || null;

      if (internalStatus === 'PICKUP_SCHEDULED' && customerEmail) {
        const subject = (returnRequest.type || 'RETURN').toUpperCase() === 'EXCHANGE'
          ? 'Exchange Pickup Scheduled - Little Threads'
          : 'Return Pickup Scheduled - Little Threads';
        const bodyText = (returnRequest.type || 'RETURN').toUpperCase() === 'EXCHANGE'
          ? TEMPLATES.EXCHANGE_PICKUP_SCHEDULED()
          : TEMPLATES.RETURN_PICKUP_SCHEDULED();
        await sendMail(customerEmail, subject, bodyText);
      }

      if (internalStatus === 'PICKUP_FAILED') {
        if ((returnRequest.type || 'RETURN').toUpperCase() === 'EXCHANGE' && returnRequest.preferredVariantTitle) {
          const exchangeItem = (returnRequest.order.items || []).find((item) => item.variantTitle);
          if (exchangeItem) {
            const reservedVariant = await prisma.productVariant.findFirst({
              where: {
                productId: exchangeItem.productId,
                title: returnRequest.preferredVariantTitle
              }
            });

            if (reservedVariant && reservedVariant.reservedStock > 0) {
              await prisma.productVariant.update({
                where: { id: reservedVariant.id },
                data: { reservedStock: { decrement: 1 } }
              });
            }
          }
        }

        if (customerEmail) {
          const subject = (returnRequest.type || 'RETURN').toUpperCase() === 'EXCHANGE'
            ? 'Exchange Pickup Failed - Little Threads'
            : 'Return Pickup Failed - Little Threads';
          await sendMail(
            customerEmail,
            subject,
            TEMPLATES.RETURN_PICKUP_FAILED()
          );
        }
      }

      if (isReceivedAtWarehouse) {
        if ((returnRequest.type || 'RETURN').toUpperCase() === 'EXCHANGE') {
          const exchangeItem = (returnRequest.order.items || []).find((item) => item.variantTitle);
          if (exchangeItem && returnRequest.preferredVariantTitle) {
            await prisma.$transaction(async (tx) => {
              const originalVariant = exchangeItem.variantTitle
                ? await tx.productVariant.findFirst({
                    where: {
                      productId: exchangeItem.productId,
                      title: exchangeItem.variantTitle
                    }
                  })
                : null;

              const preferredVariant = await tx.productVariant.findFirst({
                where: {
                  productId: exchangeItem.productId,
                  title: returnRequest.preferredVariantTitle
                }
              });

              if (!preferredVariant) {
                throw new Error(`Preferred variant not found: ${returnRequest.preferredVariantTitle}`);
              }

              const exchangeQty = Math.max(1, exchangeItem.quantity || 1);
              const reservedQty = Math.min(exchangeQty, preferredVariant.reservedStock || 0);

              if (originalVariant) {
                await tx.productVariant.update({
                  where: { id: originalVariant.id },
                  data: { stock: { increment: exchangeQty } }
                });
              }

              await tx.productVariant.update({
                where: { id: preferredVariant.id },
                data: {
                  reservedStock: { decrement: reservedQty },
                  stock: { decrement: exchangeQty }
                }
              });

              await tx.orderItem.update({
                where: { id: exchangeItem.id },
                data: { variantTitle: returnRequest.preferredVariantTitle }
              });

              await tx.returnRequest.update({
                where: { id: returnRequest.id },
                data: {
                  inspectionStatus: 'RECEIVED',
                  pickupStatus: 'RECEIVED'
                }
              });
            });

            await logActivity(
              order.id,
              'EXCHANGE_RECEIVED',
              `Return item received at warehouse and exchange stock finalized for ${returnRequest.preferredVariantTitle}`
            );

            if (customerEmail) {
              await sendMail(
                customerEmail,
                'Exchange Item Received - Little Threads',
                TEMPLATES.EXCHANGE_RECEIVED(returnRequest.preferredVariantTitle || '')
              );
            }
          }
        } else {
          await prisma.returnRequest.update({
            where: { id: returnRequest.id },
            data: { inspectionStatus: 'RECEIVED', pickupStatus: 'RECEIVED' }
          });

          if (customerEmail) {
            await sendMail(
              customerEmail,
              'Return Item Received - Little Threads',
              TEMPLATES.RETURN_RECEIVED()
            );
          }
        }
      }

      return {
        success: true,
        message: `Return shipment status updated to ${internalStatus}`,
        order,
        returnRequest
      };
    }

    // Check for duplicate updates (idempotency)
    const lastActivity = order.activities?.[0];
    if (isDuplicateUpdate(order.status, internalStatus, lastActivity?.createdAt)) {
      console.log(`[Shiprocket] Duplicate update detected for order ${orderId}, skipping.`);
      return {
        success: true,
        message: 'Duplicate update ignored (idempotency)',
        order,
        isDuplicate: true
      };
    }

    // Update order status
    const updatedOrder = await prisma.order.update({
      where: { id: order.id },
      data: {
        status: internalStatus,
        updatedAt: new Date(eventTime),
        shippingAddress: {
          ...(order.shippingAddress || {}),
          awb,
          courierName,
          lastStatusUpdate: eventTime
        }
      },
      include: {
        customer: { select: { email: true, name: true } },
        items: true,
        activities: { orderBy: { createdAt: 'desc' }, take: 5 }
      }
    });

    // Log activity
    await logActivity(
      order.id,
      internalStatus,
      `Shiprocket webhook: ${shiprocketStatus} (AWB: ${awb}, Courier: ${courierName})`
    );

    // Send customer notification
    try {
      const customerEmail = updatedOrder.customer?.email || (updatedOrder.shippingAddress && updatedOrder.shippingAddress.email);
      
      if (customerEmail) {
        let mailBody = '';
        let subject = `Order Update: #${updatedOrder.invoiceNumber || updatedOrder.id.slice(-8).toUpperCase()}`;

        switch (internalStatus) {
          case 'SHIPPED':
            // Construct a tracking link or use awb
            const trackingUrl = awb ? `https://shiprocket.co/tracking/${awb}` : '';
            mailBody = TEMPLATES.ORDER_SHIPPED(trackingUrl);
            break;
          case 'IN_TRANSIT':
            mailBody = `Dear Customer, \nYour order is in transit and moving towards your city.\nRegards,\nLittle Threads`;
            break;
          case 'OUT_FOR_DELIVERY':
            mailBody = TEMPLATES.OUT_FOR_DELIVERY();
            break;
          case 'DELIVERED':
            mailBody = TEMPLATES.DELIVERED();
            break;
        }

        if (mailBody) {
          await sendMail(customerEmail, subject, mailBody);
        }
      }
    } catch (notificationError) {
      console.error('[Shiprocket] Notification failed:', notificationError.message);
    }

    console.log(`[Shiprocket] Order ${orderId} updated successfully to status: ${internalStatus}`);

    return {
      success: true,
      message: `Order status updated to ${internalStatus}`,
      order: updatedOrder
    };
  } catch (error) {
    console.error('[Shiprocket] Error updating order:', error);
    const errorMsg = error.message || 'Unknown error occurred while updating order';

    if (webhookLogId) {
      const existing = await prisma.webhookLog.findUnique({ where: { id: webhookLogId }, select: { attempts: true } }).catch(() => null);
      const attempts = (existing?.attempts || 0) + 1;
      await prisma.webhookLog.update({
        where: { id: webhookLogId },
        data: {
          processed: false,
          processingError: errorMsg,
          attempts,
          lastAttemptAt: new Date(),
          nextRetryAt: computeNextRetryAt(attempts),
        },
      }).catch(() => null);
    }

    return {
      success: false,
      error: errorMsg
    };
  }
};

export const replayWebhookLog = async (webhookLogId) => {
  const log = await prisma.webhookLog.findUnique({
    where: { id: webhookLogId },
  });

  if (!log) {
    const err = new Error('Webhook log not found');
    err.statusCode = 404;
    throw err;
  }

  const nextAttempts = (log.attempts || 0) + 1;
  await prisma.webhookLog.update({
    where: { id: log.id },
    data: {
      attempts: nextAttempts,
      lastAttemptAt: new Date(),
      processingError: null,
      nextRetryAt: null,
    },
  });

  const result = await updateOrderFromShiprocket(log.payload || {}, { webhookLogId: log.id });

  if (!result.success) {
    await prisma.webhookLog.update({
      where: { id: log.id },
      data: {
        processed: false,
        processingError: result.error || 'Replay failed',
        nextRetryAt: computeNextRetryAt(nextAttempts),
      },
    });

    return result;
  }

  await prisma.webhookLog.update({
    where: { id: log.id },
    data: {
      processed: true,
      processedAt: new Date(),
      processingError: null,
      nextRetryAt: null,
    },
  });

  return result;
};

/**
 * Validate Shiprocket webhook payload structure
 */
export const validateWebhookPayload = (body) => {
  const errors = [];

  if (!body) {
    errors.push('Empty webhook payload');
  }

  if (!body.current_status && !body.shipment_status && !body.status) {
    errors.push('Missing status field (current_status, shipment_status, or status)');
  }

  if (!body.order_id && !body.customer_reference_id) {
    errors.push('Missing order_id or customer_reference_id');
  }

  return {
    valid: errors.length === 0,
    errors
  };
};
