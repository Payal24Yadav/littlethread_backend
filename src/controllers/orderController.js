import prisma from '../utils/prisma.js';
import { sendMail, TEMPLATES } from '../utils/mailer.js';
import { notifyOrderStatus } from '../services/notificationService.js';
import { logActivity } from '../services/activityService.js';
import { appendOrderImageVersions } from '../utils/imageUrl.js';
import { logger } from '../utils/logger.js';
import { createReturnShipment } from '../services/shiprocketService.js';
import {
  getStatusesForAdminFilter,
  isAllowedAdminFilter,
  normalizeOrderStatus,
  toLifecycleStatus,
} from '../utils/orderStatus.js';

const unpaidRazorpayIntentFilter = {
  OR: [
    { status: 'PAYMENT_PENDING' },
    {
      AND: [
        { status: 'PENDING' },
        { paymentMethod: { in: ['razorpay', 'Razorpay', 'RAZORPAY'] } },
        { razorpayPaymentId: null },
      ],
    },
  ],
};

const customerVisibleOrderWhere = (customerId) => ({
  customerId: String(customerId),
  // Hide abandoned Razorpay checkout intents only. COD orders are valid as soon as placed.
  NOT: unpaidRazorpayIntentFilter,
});

const customerOrderInclude = {
  items: {
    include: {
      product: {
        select: { name: true, thumbnailUrl: true, images: true },
      },
    },
  },
  activities: { orderBy: { createdAt: 'desc' }, take: 20 },
};

const linkLegacyCustomerOrders = async (customerId, email) => {
  const normalizedEmail = String(email || '').trim().toLowerCase();
  if (!customerId || !normalizedEmail) return [];

  const candidates = await prisma.order.findMany({
    where: {
      customerId: null,
      paymentMethod: { in: ['cod', 'COD'] },
    },
    include: customerOrderInclude,
    orderBy: { createdAt: 'desc' },
    take: 100,
  });

  const matches = candidates.filter((order) => {
    const checkoutEmail = String(order.shippingAddress?.email || '').trim().toLowerCase();
    return checkoutEmail && checkoutEmail === normalizedEmail;
  });

  if (!matches.length) return [];

  await prisma.order.updateMany({
    where: { id: { in: matches.map((order) => order.id) } },
    data: { customerId: String(customerId) },
  });

  logger.info('orders.legacy_cod.linked_to_customer', {
    customer_id: customerId,
    count: matches.length,
  });

  return matches.map((order) => ({ ...order, customerId: String(customerId) }));
};

export const createAdminOrder = async (req, res) => {
  const { customer, items, paymentMethod, paymentId, status, notes } = req.body;
  try {
    let totalAmount = 0;
    const resolvedItems = [];

    for (const item of items) {
      const product = await prisma.product.findUnique({
        where: { id: item.productId },
        include: { variants: true }
      });
      if (!product) throw new Error(`Product ${item.productId} not found`);
      totalAmount += item.price * item.quantity;
      resolvedItems.push({ ...item, product });
    }

    // Find or note customer linkage by email
    let linkedCustomerId = null;
    if (customer.email && customer.email.trim()) {
      const trimmedEmail = customer.email.trim();
      const existingCustomer = await prisma.customer.findFirst({
        where: { email: { equals: trimmedEmail,    } }
      });
      if (existingCustomer) linkedCustomerId = existingCustomer.id;
    }

    // Generate unique sequential invoice number
    const currentYear = new Date().getFullYear();
    const prefix = `LTF-${currentYear}-`;
    const lastOrder = await prisma.order.findFirst({
      where: { invoiceNumber: { startsWith: prefix } },
      orderBy: { createdAt: 'desc' }
    });

    let nextNumber = 1;
    if (lastOrder && lastOrder.invoiceNumber) {
      const parts = lastOrder.invoiceNumber.split('-');
      const lastNum = parseInt(parts[parts.length - 1]);
      if (!isNaN(lastNum)) nextNumber = lastNum + 1;
    }
    const invoiceNumber = `${prefix}${String(nextNumber).padStart(2, '0')}`;

    const order = await prisma.order.create({
      data: {
        totalAmount,
        status: status || 'ORDERED',
        paymentMethod: paymentMethod || 'MANUAL',
        razorpayPaymentId: paymentId || null,
        invoiceNumber,
        ...(linkedCustomerId ? { customer: { connect: { id: linkedCustomerId } } } : {}),
        shippingAddress: {
          fullName: customer.name,
          firstName: customer.name.split(' ')[0],
          lastName: customer.name.split(' ').slice(1).join(' ') || '',
          email: customer.email,
          phone: customer.phone,
          address: customer.address || '',
          city: customer.city || '',
          state: customer.state || '',
          pinCode: customer.pinCode || ''
        },
        items: {
          create: items.map(item => ({
            quantity: item.quantity,
            price: item.price,
            productId: item.productId,
            variantTitle: item.variantTitle || null
          }))
        },
        activities: {
          create: {
            status: status || 'ORDERED',
            message: `Order created manually by Admin (DCR). Notes: ${notes || ''}`
          }
        }
      },
      include: { items: true }
    });

    // Reduce stock and create Sale record for each item
    for (const item of resolvedItems) {
      const quantity = Math.max(1, item.quantity || 0);
      
      // Reduce stock with better error handling
      if (item.variantTitle) {
        const variant = await prisma.productVariant.findFirst({
          where: {
            productId: item.productId,
            title: {
              equals: item.variantTitle,
                
            }
          }
        });
        
        if (variant) {
          const currentStock = variant.stock || 0;
          if (currentStock < quantity) {
            logger.warn('order.create.inventory_insufficient_variant', {
              order_id: order.id,
              variant_id: variant.id,
              variant_title: variant.title,
              requested: quantity,
              available: currentStock
            });
          }
          
          const updated = await prisma.productVariant.update({
            where: { id: variant.id },
            data: { stock: { decrement: quantity } }
          });
          
          logger.info('order.create.variant_stock_decremented', {
            order_id: order.id,
            variant_id: variant.id,
            quantity_decremented: quantity,
            stock_after: updated.stock
          });
        } else {
          logger.warn('order.create.variant_not_found', {
            order_id: order.id,
            product_id: item.productId,
            variant_title: item.variantTitle
          });
          
          // Fallback to product stock
          const currentStock = item.product?.stock || 0;
          if (currentStock < quantity) {
            logger.warn('order.create.inventory_insufficient_product', {
              order_id: order.id,
              product_id: item.productId,
              requested: quantity,
              available: currentStock
            });
          }
          
          const updated = await prisma.product.update({
            where: { id: item.productId },
            data: { stock: { decrement: quantity } }
          });
          
          logger.info('order.create.product_stock_decremented', {
            order_id: order.id,
            product_id: item.productId,
            quantity_decremented: quantity,
            stock_after: updated.stock
          });
        }
      } else {
        const currentStock = item.product?.stock || 0;
        if (currentStock < quantity) {
          logger.warn('order.create.inventory_insufficient_product', {
            order_id: order.id,
            product_id: item.productId,
            requested: quantity,
            available: currentStock
          });
        }
        
        const updated = await prisma.product.update({
          where: { id: item.productId },
          data: { stock: { decrement: quantity } }
        });
        
        logger.info('order.create.product_stock_decremented', {
          order_id: order.id,
          product_id: item.productId,
          quantity_decremented: quantity,
          stock_after: updated.stock
        });
      }

      // Create a Sale record so this DCR order shows in the Sales dashboard
      await prisma.sale.create({
        data: {
          productId: item.productId,
          quantity: item.quantity,
          price: item.price * item.quantity,
          source: 'DCR',
          orderId: order.id,
          customerName: customer.name || null,
          customerEmail: customer.email || null,
          customerPhone: customer.phone || null,
          paymentMode: paymentMethod || 'MANUAL',
          paymentId: paymentId || null,
          notes: notes || null,
          variantTitle: item.variantTitle || null
        }
      });
    }

    logger.info('order.created', {
      order_id: order.id,
      user_id: req.user?.id || null,
      total_amount: order.totalAmount,
      items_count: order.items.length,
      items: resolvedItems.map(item => ({
        name: item.product.name,
        variant: item.variantTitle || null,
        quantity: item.quantity,
        price: item.price
      }))
    });

    // Send invoice email if email is provided
    if (customer.email && customer.email.trim()) {
      try {
        const fullOrder = await prisma.order.findUnique({
          where: { id: order.id },
          include: { items: { include: { product: true } } }
        });
        const { generateInvoice } = await import('../utils/invoiceGenerator.js');
        const { sendInvoiceEmail } = await import('../utils/mailer.js');
        const invoiceBuffer = await generateInvoice(fullOrder);
        if (invoiceBuffer) {
          const subject = `Invoice for Order #${fullOrder.invoiceNumber || fullOrder.id.slice(-6).toUpperCase()}`;
          const text = TEMPLATES.INVOICE(fullOrder.invoiceNumber || fullOrder.id);
          await sendInvoiceEmail(customer.email.trim(), subject, text, invoiceBuffer);
          await logActivity(order.id, 'INVOICE_SENT', `Manual order invoice sent to ${customer.email.trim()}`);
        }
      } catch (emailErr) {
        logger.error('order.create.email_failed', { order_id: order.id, error: emailErr.message });
      }
    }

    res.status(201).json(order);
  } catch (error) {
    logger.error('order.create.failed', {
      error: error.message,
      user_id: req.user?.id || null
    });
    res.status(500).json({ error: error.message });
  }
};

export const deleteOrder = async (req, res) => {
  const { id } = req.params;
  try {
    // Delete related records first if not handled by CASCADE
    await prisma.orderActivity.deleteMany({ where: { orderId: id } });
    await prisma.orderItem.deleteMany({ where: { orderId: id } });
    await prisma.sale.deleteMany({ where: { orderId: id } });
    await prisma.shipment.deleteMany({ where: { orderId: id } });
    
    await prisma.order.delete({ where: { id } });
    
    logger.info('order.deleted', { order_id: id, user_id: req.user?.id || null });
    res.json({ success: true, message: 'Order deleted successfully' });
  } catch (error) {
    logger.error('order.delete.failed', { order_id: id, error: error.message });
    res.status(500).json({ error: error.message });
  }
};

export const updateOrderDetails = async (req, res) => {
  const { id } = req.params;
  const { name, email, phone, address, city, state, pinCode, syncShiprocket } = req.body;

  try {
    const order = await prisma.order.findUnique({ where: { id }, include: { items: { include: { product: true } } } });
    if (!order) return res.status(404).json({ error: 'Order not found' });

    // Build updated shipping address by merging into existing
    const existingAddr = order.shippingAddress || {};
    const nameParts = name ? name.split(' ') : null;
    const updatedAddress = {
      ...existingAddr,
      ...(nameParts ? { firstName: nameParts[0], lastName: nameParts.slice(1).join(' ') || '' } : {}),
      ...(email ? { email } : {}),
      ...(phone ? { phone } : {}),
      ...(address ? { address } : {}),
      ...(city ? { city } : {}),
      ...(state ? { state } : {}),
      ...(pinCode ? { pinCode } : {}),
    };

    const updated = await prisma.order.update({
      where: { id },
      data: { shippingAddress: updatedAddress },
      include: { items: { include: { product: true } }, activities: true }
    });

    // Cascade to Customer if linked
    if (order.customerId && (name || email || phone)) {
      await prisma.customer.update({
        where: { id: order.customerId },
        data: {
          ...(name ? { name } : {}),
          ...(email ? { email } : {}),
          ...(phone ? { mobile: phone } : {})
        }
      }).catch(err => console.error('Failed to cascade order-to-customer update:', err.message));
    }

    // Cascade to Sales record linked to this order
    await prisma.sale.updateMany({
      where: { orderId: id },
      data: {
        ...(name ? { customerName: name } : {}),
        ...(email ? { customerEmail: email } : {}),
        ...(phone ? { customerPhone: phone } : {})
      }
    }).catch(err => console.error('Failed to cascade order-to-sale update:', err.message));

    await logActivity(id, 'ORDER_DETAILS_UPDATED', `Admin updated customer/address details.`);

    // Optionally sync address update to Shiprocket by re-creating shipment
    if (syncShiprocket) {
      try {
        // Check if shipment already exists — cancel it first, then recreate
        const existingShipment = await prisma.shipment.findUnique({ where: { orderId: id } });
        if (existingShipment) {
          // We can't update address in Shiprocket, so just note it in activity
          await logActivity(id, 'SHIPROCKET_ADDRESS_NOTE', 'Address updated. Recreate shipment manually in Shiprocket if already dispatched.');
        }
      } catch (shipErr) {
        logger.error('updateOrderDetails.shiprocket_sync.error', { orderId: id, error: shipErr?.message });
      }
    }

    res.json({ success: true, order: updated });
  } catch (error) {
    logger.error('updateOrderDetails.error', { orderId: id, error: error?.message });
    res.status(500).json({ error: error.message });
  }
};

export const getOrders = async (req, res) => {
  const statusFilter = String(req.query.status || 'all').toLowerCase();

  if (!isAllowedAdminFilter(statusFilter)) {
    return res.status(400).json({
      message: 'Invalid status filter. Use one of: all, ordered, shipped, delivered, canceled.',
    });
  }

  const statuses = getStatusesForAdminFilter(statusFilter);

  const page = parseInt(req.query.page) || 1;
  const limit = parseInt(req.query.limit) || 20;
  const skip = (page - 1) * limit;

  try {
    const [orders, total] = await Promise.all([
      prisma.order.findMany({
        where: statuses ? { status: { in: statuses } } : {},
        skip,
        take: limit,
        include: {
          customer: {
            select: { name: true, email: true }
          },
          items: {
            include: {
              product: {
                select: { name: true, thumbnailUrl: true }
              }
            }
          },
          // include latest return request (if any) to show badge in admin list
          returnRequests: {
            orderBy: { createdAt: 'desc' },
            take: 1
          }
        },
        orderBy: { createdAt: 'desc' }
      }),
      prisma.order.count({
        where: statuses ? { status: { in: statuses } } : {},
      })
    ]);

    // Formatting if needed for the admin view
    const formattedOrders = orders.map(order => appendOrderImageVersions({
      id: order.id,
      customer: order.customer,
      createdAt: order.createdAt,
      total: order.totalAmount, // Map totalAmount to total for the frontend
      status: toLifecycleStatus(order.status),
      rawStatus: order.status,
      paymentStatus: order.paymentStatus,
      paymentMethod: order.paymentMethod,
      codCharges: order.codCharges,
      shippingAddress: order.shippingAddress,
      invoiceNumber: order.invoiceNumber,
      items: order.items,
      razorpayOrderId: order.razorpayOrderId,
      razorpayPaymentId: order.razorpayPaymentId,
      // expose single latest returnRequest (or null)
      returnRequest: order.returnRequests && order.returnRequests.length ? order.returnRequests[0] : null
    }));

    logger.info('orders.list.success', {
      status_filter: statusFilter,
      result_count: formattedOrders.length,
      total_count: total,
      user_id: req.user?.id || null,
    });

    res.json({
      data: formattedOrders,
      meta: {
        page,
        limit,
        total,
        totalPages: Math.ceil(total / limit)
      }
    });
  } catch (error) {
    logger.error('orders.list.error', {
      status_filter: statusFilter,
      user_id: req.user?.id || null,
      error: error.message,
      stack: error.stack,
    });
    res.status(500).json({ error: error.message });
  }
};

export const getOrderById = async (req, res) => {
  const { id } = req.params;
  const { user } = req; // From requireAuth middleware

  try {
    const order = await prisma.order.findUnique({
      where: { id },
      include: {
        customer: true,
        items: {
          include: {
            product: true
          }
        },
        activities: {
          orderBy: { createdAt: 'desc' }
        }
      }
    });

    if (!order) {
      return res.status(404).json({ message: 'Order not found' });
    }

    // Customer can only access their own order. Admin can access any order.
    // Guests (no req.auth) can access the order if they have the UUID.
    if (req.auth?.type === 'customer' && order.customerId && order.customerId !== user?.id) {
      return res.status(403).json({ message: 'Forbidden: You do not have access to this order' });
    }

    const shipment = await prisma.shipment.findUnique({
      where: { orderId: order.id },
    }).catch(() => null);

    res.json({
      ...appendOrderImageVersions(order),
      shipment: shipment || null,
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

export const getOrderInvoice = async (req, res) => {
  const { id } = req.params;
  try {
    const { generateInvoice } = await import('../utils/invoiceGenerator.js');
    const invoiceBuffer = await generateInvoice(id);
    
    res.setHeader('Content-Type', 'application/pdf');
    res.setHeader('Content-Disposition', `attachment; filename=little-threads-invoice-${id}.pdf`);
    res.send(invoiceBuffer);
  } catch (error) {
    console.error('Invoice generation error:', error);
    res.status(500).json({ error: error.message });
  }
};

export const getCustomerOrders = async (req, res) => {
  const { customerId } = req.params;
  const { user } = req; // From requireAuth middleware

  try {
    // Verify the authenticated user can only see their own orders
    if (customerId !== user.id) {
      return res.status(403).json({ message: 'Forbidden: You can only view your own orders' });
    }

    const orders = await prisma.order.findMany({
      where: customerVisibleOrderWhere(customerId),
      include: customerOrderInclude,
      orderBy: { createdAt: 'desc' }
    });
    const linkedLegacyOrders = await linkLegacyCustomerOrders(customerId, user?.email);
    const byId = new Map([...linkedLegacyOrders, ...orders].map((order) => [order.id, order]));
    const visibleOrders = Array.from(byId.values())
      .sort((a, b) => new Date(b.createdAt) - new Date(a.createdAt));

    res.json(visibleOrders.map((order) => appendOrderImageVersions(order)));
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

const normalizePhone10 = (phone) => String(phone || '').replace(/\D/g, '').slice(-10);

const attachShipmentSummary = async (orders) => {
  const orderIds = (orders || []).map((o) => o.id).filter(Boolean);
  if (!orderIds.length) return [];

  const shipments = await prisma.shipment.findMany({
    where: { orderId: { in: orderIds } },
    select: {
      orderId: true,
      awb: true,
      courier: true,
      status: true,
      shipmentId: true,
      labelUrl: true,
      pickupId: true,
      lastTrackedAt: true,
      createdAt: true,
      updatedAt: true,
    },
  });

  const byOrderId = new Map(shipments.map((s) => [s.orderId, s]));

  return orders.map((order) => ({
    ...order,
    shipment: byOrderId.get(order.id) || null,
  }));
};

export const getMyOrders = async (req, res) => {
  try {
    const customerId = req.user?.id;
    if (!customerId) {
      return res.status(401).json({ success: false, message: 'Unauthorized' });
    }

    const orders = await prisma.order.findMany({
      where: customerVisibleOrderWhere(customerId),
      include: customerOrderInclude,
      orderBy: { createdAt: 'desc' },
      take: 100,
    });

    const linkedLegacyOrders = await linkLegacyCustomerOrders(customerId, req.user?.email);
    const byId = new Map([...linkedLegacyOrders, ...orders].map((order) => [order.id, order]));
    const visibleOrders = Array.from(byId.values())
      .sort((a, b) => new Date(b.createdAt) - new Date(a.createdAt))
      .slice(0, 100);

    const withShipments = await attachShipmentSummary(visibleOrders.map((o) => appendOrderImageVersions(o)));

    return res.status(200).json({
      success: true,
      data: withShipments,
    });
  } catch (error) {
    logger.error('orders.my_orders.error', { message: error?.message, stack: error?.stack });
    return res.status(500).json({ success: false, message: 'Failed to fetch orders' });
  }
};

export const trackOrder = async (req, res) => {
  try {
    const orderId = String(req.body?.orderId || '').trim();
    const email = String(req.body?.email || '').trim().toLowerCase();
    const phone = normalizePhone10(req.body?.phone);

    if (!orderId) {
      return res.status(400).json({ success: false, message: 'orderId is required' });
    }

    if (!email && !phone) {
      return res.status(400).json({ success: false, message: 'email or phone is required' });
    }

    const order = await prisma.order.findUnique({
      where: { id: orderId },
      include: {
        customer: { select: { id: true, email: true, name: true } },
        items: {
          include: {
            product: { select: { name: true, thumbnailUrl: true, images: true } },
          },
        },
      },
    });

    if (!order) {
      return res.status(404).json({ success: false, message: 'Order not found' });
    }

    const shippingEmail = String(order.shippingAddress?.email || '').trim().toLowerCase();
    const customerEmail = String(order.customer?.email || '').trim().toLowerCase();
    const shippingPhone = normalizePhone10(order.shippingAddress?.phone);

    if (email) {
      const matches = email === shippingEmail || email === customerEmail;
      if (!matches) {
        return res.status(403).json({ success: false, message: 'Email does not match this order' });
      }
    }

    if (phone) {
      if (!shippingPhone || shippingPhone !== phone) {
        return res.status(403).json({ success: false, message: 'Phone does not match this order' });
      }
    }

    const shipment = await prisma.shipment.findUnique({
      where: { orderId },
    }).catch(() => null);

    if (!shipment?.awb) {
      return res.status(200).json({
        success: true,
        message: 'Shipment not created yet',
        order: appendOrderImageVersions(order),
        shipment: shipment || null,
        awb: null,
        tracking: null,
        timeline: [],
      });
    }

    const [tracking, timeline] = await Promise.all([
      (await import('../services/shippingService.js')).then((m) => m.trackShipment({ awb: shipment.awb })).catch(() => null),
      prisma.shipmentTrackingEvent.findMany({
        where: { awb: shipment.awb },
        orderBy: { eventTime: 'asc' },
        take: 200,
        select: {
          id: true,
          status: true,
          source: true,
          eventTime: true,
          raw: true,
        },
      }),
    ]);

    return res.status(200).json({
      success: true,
      message: 'Tracking fetched successfully',
      order: appendOrderImageVersions(order),
      shipment,
      awb: shipment.awb,
      tracking,
      timeline,
    });
  } catch (error) {
    logger.error('orders.track.error', { message: error?.message, stack: error?.stack });
    return res.status(500).json({ success: false, message: 'Failed to track order' });
  }
};

export const updateOrderStatus = async (req, res) => {
  const { id } = req.params;
  const { status: incomingStatus } = req.body;
  const status = normalizeOrderStatus(incomingStatus);

  const allowedStatuses = ['ORDERED', 'SHIPPED', 'DELIVERED', 'CANCELED'];
  if (!allowedStatuses.includes(status)) {
    return res.status(400).json({
      message: 'Invalid status. Use one of: ordered, shipped, delivered, canceled.',
    });
  }

  try {
    const existingOrder = await prisma.order.findUnique({
      where: { id },
      include: { items: { include: { product: true } } }
    });

    if (!existingOrder) {
      return res.status(404).json({ message: 'Order not found' });
    }

    const statusChanged = existingOrder.status !== status;

    const order = await prisma.order.update({
      where: { id },
      data: { 
        status,
        // Set delivery date when order is marked as delivered
        ...(status === 'DELIVERED' && !existingOrder.deliveryDate ? { deliveryDate: new Date() } : {})
      }
    });

    logger.info('order.status.updated', {
      order_id: id,
      old_status: existingOrder.status,
      new_status: status,
      items: existingOrder.items.map(item => ({
        name: item.product.name,
        variant: item.variantTitle || null,
        quantity: item.quantity,
        price: item.price
      }))
    });

    await logActivity(
      id,
      status,
      status === 'DELIVERED'
        ? 'Order marked as delivered by admin.'
        : `Order status updated to ${status} by admin.`
    );

    // Send notifications only when status actually changes to avoid duplicate SMS/email costs.
    const destEmail = order.shippingAddress?.email || null;
    if (statusChanged && destEmail) {
      switch (status) {
        case 'PACKED':
          await sendMail(destEmail, 'Order Packed', TEMPLATES.ORDER_PACKED());
          break;
        case 'SHIPPED':
          // We can fetch tracking link if it's available in order table.
          await sendMail(destEmail, 'Order Shipped', TEMPLATES.ORDER_SHIPPED(order.trackingLink || ''));
          break;
        case 'OUT_FOR_DELIVERY':
          await sendMail(destEmail, 'Out for Delivery', TEMPLATES.OUT_FOR_DELIVERY());
          break;
        case 'DELIVERED':
          await sendMail(destEmail, 'Order Delivered', TEMPLATES.DELIVERED());
          break;
        case 'CANCELED':
          await sendMail(destEmail, 'Order Cancelled', TEMPLATES.ORDER_CANCELLED());
          break;
        case 'REFUND_INITIATED':
          await sendMail(destEmail, 'Refund Initiated', TEMPLATES.REFUND_INITIATED());
          break;
        case 'REFUNDED':
          await sendMail(destEmail, 'Refund Completed', TEMPLATES.REFUND_COMPLETED());
          break;
      }
    }

    // SMS notification: should never block admin status updates
    try {
      if (!statusChanged) {
        return res.json(appendOrderImageVersions(order));
      }

      if (status === 'SHIPPED') {
        const shipment = await prisma.shipment.findUnique({
          where: { orderId: order.id },
        });
        await notifyOrderStatus(order, status, {
          trackingLink: shipment?.labelUrl || '',
        });
      } else {
        await notifyOrderStatus(order, status);
      }
    } catch (error) {
      console.error('notifyOrderStatus failed:', error?.message || error);
    }

    res.json(appendOrderImageVersions(order));
  } catch (error) {
    logger.error('orders.update_status.error', {
      order_id: id,
      status,
      user_id: req.user?.id || null,
      error: error.message,
      stack: error.stack,
    });
    res.status(500).json({ error: error.message });
  }
};

export const cancelOrder = async (req, res) => {
  const { id } = req.params;
  const { reason } = req.body;

  try {
    const order = await prisma.order.findUnique({
      where: { id },
      include: {
        items: {
          include: {
            product: true
          }
        }
      }
    });

    if (!order) {
      return res.status(404).json({ message: 'Order not found' });
    }

    // Check if order can be cancelled
    const cancellableStatuses = ['PENDING', 'PAID', 'COD_CONFIRMED', 'COD_PENDING', 'PAYMENT_PENDING', 'ORDERED'];
    if (!cancellableStatuses.includes(order.status)) {
      return res.status(400).json({ 
        message: `Order cannot be cancelled in ${order.status} status. Only orders in PENDING, PAID, or COD_CONFIRMED status can be cancelled.` 
      });
    }

    // Restore inventory
    for (const item of order.items) {
      if (item.variantTitle) {
        const variant = await prisma.productVariant.findFirst({
          where: {
            productId: item.productId,
            title: item.variantTitle
          }
        });

        if (variant) {
          await prisma.productVariant.update({
            where: { id: variant.id },
            data: { stock: { increment: item.quantity } }
          });
        } else {
          await prisma.product.update({
            where: { id: item.productId },
            data: { stock: { increment: item.quantity } }
          });
        }
      } else {
        await prisma.product.update({
          where: { id: item.productId },
          data: { stock: { increment: item.quantity } }
        });
      }
    }

    // Update order status
    const updatedOrder = await prisma.order.update({
      where: { id },
      data: {
        status: 'CANCELED',
        cancellationReason: reason || 'Cancelled by admin'
      }
    });

    // Log activity
    await logActivity(
      id,
      'ORDER_CANCELED',
      `Order cancelled by admin. Reason: ${reason || 'Not specified'}`
    );

    // Send cancellation email
    const destEmail = order.shippingAddress?.email || null;
    if (destEmail) {
      await sendMail(
        destEmail,
        'Order Cancelled - Little Threads',
        TEMPLATES.ORDER_CANCELLED()
      );
    }

    // Remove only sales that belong to this order
    await prisma.sale.deleteMany({
      where: { orderId: id }
    });

    logger.info('order.cancelled', {
      order_id: id,
      user_id: req.user?.id || null,
      items: order.items.map(item => ({
        name: item.product.name,
        variant: item.variantTitle || null,
        quantity: item.quantity,
        price: item.price
      }))
    });

    res.json({
      message: 'Order cancelled successfully',
      order: updatedOrder
    });
  } catch (error) {
    logger.error('orders.cancel.error', {
      order_id: id,
      user_id: req.user?.id || null,
      error: error.message,
      stack: error.stack,
    });
    res.status(500).json({ error: error.message });
  }
};

export const createReturnRequest = async (req, res) => {
  const { orderId } = req.params;
  const { reason, description } = req.body;

  try {
    const order = await prisma.order.findUnique({
      where: { id: orderId },
      include: {
        items: true
      }
    });

    if (!order) {
      return res.status(404).json({ message: 'Order not found' });
    }

    // Check if order is delivered
    if (order.status !== 'DELIVERED') {
      return res.status(400).json({ 
        message: 'Return can only be initiated for delivered orders' 
      });
    }

    // Check if delivery date is within 7 days
    if (!order.deliveryDate) {
      return res.status(400).json({ 
        message: 'Delivery date not recorded for this order' 
      });
    }

    const deliveryDate = new Date(order.deliveryDate);
    const currentDate = new Date();
    const daysPassedSinceDelivery = Math.floor((currentDate - deliveryDate) / (1000 * 60 * 60 * 24));

    if (daysPassedSinceDelivery > 7) {
      return res.status(400).json({ 
        message: `Return period expired. Returns must be initiated within 7 days of delivery. ${daysPassedSinceDelivery} days have passed.` 
      });
    }

    // Check if return already exists
    const existingReturn = await prisma.returnRequest.findFirst({
      where: {
        orderId,
        status: { in: ['PENDING', 'APPROVED'] }
      }
    });

    if (existingReturn) {
      return res.status(400).json({ 
        message: 'A return request already exists for this order' 
      });
    }

    // Create return/exchange request
    const returnRequest = await prisma.returnRequest.create({
      data: {
        orderId,
        reason,
        description,
        type: req.body.type || 'RETURN',
        preferredVariantTitle: req.body.preferredVariantTitle || null,
        returnDate: new Date(),
        status: 'PENDING'
      }
    });

    const actionLabel = (req.body.type || 'RETURN').toUpperCase() === 'EXCHANGE' ? 'Exchange' : 'Return';

    // Log activity
    await logActivity(
      orderId,
      `${actionLabel.toUpperCase()}_REQUESTED`,
      `${actionLabel} request created. Reason: ${reason}`
    );

    // Send email notification to admin and customer
    if (order.shippingAddress && typeof order.shippingAddress === 'object') {
      const destEmail = order.shippingAddress.email || null;
      if (destEmail) {
        await sendMail(
          destEmail,
          `${actionLabel} Request Received - Little Threads`,
          `Your ${actionLabel.toLowerCase()} request for order ${order.invoiceNumber || order.id} has been received. Our team will review it shortly.`
        );
      }
    }

    res.status(201).json({
      message: 'Return request created successfully',
      returnRequest
    });
  } catch (error) {
    console.error('Error creating return request:', error);
    res.status(500).json({ error: error.message });
  }
};

export const getReturnRequest = async (req, res) => {
  const { orderId } = req.params;

  try {
    const returnRequest = await prisma.returnRequest.findFirst({
      where: { orderId }
    });

    if (!returnRequest) {
      return res.status(404).json({ message: 'No return request found for this order' });
    }

    res.json(returnRequest);
  } catch (error) {
    console.error('Error fetching return request:', error);
    res.status(500).json({ error: error.message });
  }
};

export const getReturnRequests = async (req, res) => {
  try {
    const { status, orderId } = req.query;
    const where = {};

    if (status) {
      where.status = status;
    }
    if (orderId) {
      where.orderId = orderId;
    }

    const returnRequests = await prisma.returnRequest.findMany({
      where,
      include: {
        order: {
          select: {
            id: true,
            invoiceNumber: true,
            customer: {
              select: {
                name: true,
                email: true
              }
            },
            items: true,
            totalAmount: true
          }
        }
      },
      orderBy: { createdAt: 'desc' }
    });

    res.json(returnRequests);
  } catch (error) {
    console.error('Error fetching return requests:', error);
    res.status(500).json({ error: error.message });
  }
};

export const approveReturnRequest = async (req, res) => {
  const { returnId } = req.params;
  const { refundAmount, adminResponse } = req.body || {};

  try {
    const returnRequest = await prisma.returnRequest.findUnique({
      where: { id: returnId },
      include: {
        order: {
          select: {
            id: true,
            totalAmount: true,
            paymentMethod: true,
            shippingAddress: true,
            status: true,
            items: true
          }
        }
      }
    });

    if (!returnRequest) {
      return res.status(404).json({ message: 'Return request not found' });
    }

    if (returnRequest.status !== 'PENDING') {
      return res.status(400).json({ 
        message: `Return request cannot be approved. Current status: ${returnRequest.status}` 
      });
    }

    // For RETURN: approve with refund amount; for EXCHANGE: approve without refund
    let updatedReturn;
    if ((returnRequest.type || 'RETURN').toUpperCase() === 'EXCHANGE') {
      // Approve exchange: reserve replacement stock, do not deduct from on-hand stock yet.
      updatedReturn = await prisma.returnRequest.update({
        where: { id: returnId },
        data: {
          status: 'APPROVED',
          pickupStatus: 'SCHEDULED',
          inspectionStatus: 'PENDING',
          adminResponse: adminResponse || 'Exchange approved'
        }
      });

      // Update order status to indicate exchange flow
      await prisma.order.update({
        where: { id: returnRequest.orderId },
        data: { status: 'EXCHANGE_INITIATED' }
      });

      // Reserve replacement stock only. Final inventory movement happens when the reverse pickup is received.
      try {
        await prisma.$transaction(async (tx) => {
          const exchangeItem = (returnRequest.order.items || []).find((item) => item.variantTitle);
          if (!exchangeItem || !returnRequest.preferredVariantTitle) {
            throw new Error('Exchange item or preferred variant missing');
          }

          const exchangeQuantity = Math.max(1, exchangeItem.quantity || 1);

          const reservedVariant = await tx.productVariant.findFirst({
            where: {
              productId: exchangeItem.productId,
              title: returnRequest.preferredVariantTitle
            }
          });

          if (!reservedVariant) {
            throw new Error(`Preferred variant not found: ${returnRequest.preferredVariantTitle}`);
          }

          const availableStock = Math.max(0, (reservedVariant.stock || 0) - (reservedVariant.reservedStock || 0));
          if (availableStock < 1) {
            throw new Error(`Preferred variant is out of stock: ${returnRequest.preferredVariantTitle}`);
          }

          await tx.productVariant.update({
            where: { id: reservedVariant.id },
            data: { reservedStock: { increment: exchangeQuantity } }
          });
        });

        await logActivity(
          returnRequest.orderId,
          'INVENTORY_RESERVED_EXCHANGE',
          `Replacement stock reserved for exchange: ${returnRequest.preferredVariantTitle || 'N/A'}`
        );
      } catch (invErr) {
        console.error('approveReturnRequest.inventoryUpdate failed:', invErr?.message || invErr);
      }

      // Log activity for exchange
      await logActivity(
        returnRequest.orderId,
        'EXCHANGE_APPROVED',
        `Exchange request approved. Preferred variant: ${returnRequest.preferredVariantTitle || 'N/A'}`
      );

      // Send email notification for exchange
      if (returnRequest.order.shippingAddress && typeof returnRequest.order.shippingAddress === 'object') {
        const destEmail = returnRequest.order.shippingAddress.email || null;
        if (destEmail) {
          try {
            await sendMail(
              destEmail,
              'Exchange Approved - Little Threads',
              TEMPLATES.EXCHANGE_APPROVED(returnRequest.preferredVariantTitle || 'selected variant')
            );
          } catch (mailErr) {
            console.error('approveReturnRequest.sendMail failed:', mailErr?.message || mailErr);
          }
        }
      }
    } else {
      const approvalAmount = refundAmount || returnRequest.order.totalAmount;

      // Update return request with refund
      updatedReturn = await prisma.returnRequest.update({
        where: { id: returnId },
        data: {
          status: 'APPROVED',
          refundAmount: approvalAmount,
          pickupStatus: 'SCHEDULED',
          inspectionStatus: 'PENDING',
          adminResponse: adminResponse || 'Return approved'
        }
      });

      // Update order status
      await prisma.order.update({
        where: { id: returnRequest.orderId },
        data: { status: 'RETURN_INITIATED' }
      });

      // Log activity for return
      await logActivity(
        returnRequest.orderId,
        'RETURN_APPROVED',
        `Return request approved. Refund amount: ₹${approvalAmount}`
      );

      // Send email notification for return
      if (returnRequest.order.shippingAddress && typeof returnRequest.order.shippingAddress === 'object') {
        const destEmail = returnRequest.order.shippingAddress.email || null;
        if (destEmail) {
          try {
            await sendMail(
              destEmail,
              'Return Approved - Little Threads',
              TEMPLATES.RETURN_APPROVED(approvalAmount)
            );
          } catch (mailErr) {
            console.error('approveReturnRequest.sendMail failed:', mailErr?.message || mailErr);
          }
        }
      }
    }

    // Create return shipment in Shiprocket
    try {
      if (returnRequest.order.shippingAddress && typeof returnRequest.order.shippingAddress === 'object') {
        const addr = returnRequest.order.shippingAddress;
        const returnShipmentData = {
          order_id: `RETURN-${returnRequest.orderId}`,
          shipping_customer_name: addr.firstName || 'Customer',
          shipping_address: addr.address || '',
          shipping_city: addr.city || '',
          shipping_pincode: addr.pinCode || '',
          shipping_state: addr.state || '',
          shipping_country: addr.country || 'India',
          shipping_email: addr.email || '',
          shipping_phone: addr.phone || '',
          order_items: returnRequest.order.items?.map(item => ({
            name: item.product?.name || 'Product',
            sku: item.productId,
            units: item.quantity,
            selling_price: item.price
          })) || [],
          sub_total: returnRequest.order.totalAmount || 0,
          weight: 0.5,
          length: 5,
          breadth: 5,
          height: 5,
        };
        
        const returnShipment = await createReturnShipment(returnShipmentData);

        await prisma.returnRequest.update({
          where: { id: returnId },
          data: {
            returnShipmentId: returnShipment.shipment_id,
            pickupStatus: 'SCHEDULED'
          }
        });
        
        // Log the return shipment creation
        await logActivity(
          returnRequest.orderId,
          'RETURN_SHIPMENT_CREATED',
          `Return shipment created in Shiprocket. Shipment ID: ${returnShipment.shipment_id}`
        );
        
        console.log(`[approveReturnRequest] Return shipment created: ${returnShipment.shipment_id}`);
      }
    } catch (shipErr) {
      console.error('approveReturnRequest.createReturnShipment failed:', shipErr?.message || shipErr);
      // Don't fail the approval if shipment creation fails
    }

    res.json({
      message: 'Return/Exchange request approved successfully',
      returnRequest: updatedReturn
    });
  } catch (error) {
    console.error('Error approving return request:', error);
    res.status(500).json({ error: error.message });
  }
};

export const rejectReturnRequest = async (req, res) => {
  const { returnId } = req.params;
  const { adminResponse } = req.body || {};

  try {
    const returnRequest = await prisma.returnRequest.findUnique({
      where: { id: returnId },
      include: {
        order: {
          select: {
            id: true,
            shippingAddress: true
          }
        }
      }
    });

    if (!returnRequest) {
      return res.status(404).json({ message: 'Return request not found' });
    }

    if (returnRequest.status !== 'PENDING') {
      return res.status(400).json({ 
        message: `Return request cannot be rejected. Current status: ${returnRequest.status}` 
      });
    }

    // Update return request
    const updatedReturn = await prisma.returnRequest.update({
      where: { id: returnId },
      data: {
        status: 'REJECTED',
        adminResponse: adminResponse || 'Return request rejected'
      }
    });

    // Log activity
    await logActivity(
      returnRequest.orderId,
      'RETURN_REJECTED',
      `Return request rejected. Reason: ${adminResponse || 'Not specified'}`
    );

    // Send email notification
    if (returnRequest.order.shippingAddress && typeof returnRequest.order.shippingAddress === 'object') {
      const destEmail = returnRequest.order.shippingAddress.email || null;
      if (destEmail) {
        try {
          await sendMail(
            destEmail,
            'Return Request Decision - Little Threads',
            `We're sorry, but your return request has been declined. ${adminResponse || ''}`
          );
        } catch (mailErr) {
          console.error('rejectReturnRequest.sendMail failed:', mailErr?.message || mailErr);
        }
      }
    }

    res.json({
      message: 'Return request rejected successfully',
      returnRequest: updatedReturn
    });
  } catch (error) {
    console.error('Error rejecting return request:', error);
    res.status(500).json({ error: error.message });
  }
};

export const cancelReturnRequestByCustomer = async (req, res) => {
  const { orderId } = req.params;

  try {
    const returnRequest = await prisma.returnRequest.findFirst({ where: { orderId } });
    if (!returnRequest) {
      return res.status(404).json({ message: 'Return request not found' });
    }

    if (returnRequest.status !== 'PENDING') {
      return res.status(400).json({ message: `Return request cannot be cancelled. Current status: ${returnRequest.status}` });
    }

    // Verify the requesting customer owns the order when applicable
    const order = await prisma.order.findUnique({ where: { id: orderId } });
    if (order?.customerId && req.user && req.user.id !== order.customerId) {
      return res.status(403).json({ message: 'Forbidden: You do not own this order' });
    }

    const updated = await prisma.returnRequest.update({
      where: { id: returnRequest.id },
      data: { status: 'CANCELLED' }
    });

    await logActivity(orderId, 'RETURN_CANCELLED_BY_CUSTOMER', 'Customer cancelled the return/exchange request.');

    res.json({ message: 'Return request cancelled', returnRequest: updated });
  } catch (error) {
    console.error('Error cancelling return request:', error);
    res.status(500).json({ error: error.message });
  }
};

export const completeRefund = async (req, res) => {
  const { returnId } = req.params;
  const inspectionStatus = String(req.body?.inspectionStatus || '').toUpperCase();

  try {
    const returnRequest = await prisma.returnRequest.findUnique({
      where: { id: returnId },
      include: {
        order: {
          select: {
            id: true,
            shippingAddress: true,
            totalAmount: true
          }
        }
      }
    });

    if (!returnRequest) {
      return res.status(404).json({ message: 'Return request not found' });
    }

    // Only allow marking refund as complete for RETURN type (not EXCHANGE)
    if (returnRequest.type !== 'RETURN') {
      return res.status(400).json({ 
        message: 'Refund can only be marked complete for RETURN requests, not EXCHANGE' 
      });
    }

    if (returnRequest.status !== 'APPROVED') {
      return res.status(400).json({ 
        message: `Return must be APPROVED before marking refund as complete. Current status: ${returnRequest.status}` 
      });
    }

    if (inspectionStatus && inspectionStatus !== 'APPROVED') {
      return res.status(400).json({
        message: 'Inspection must be APPROVED before refund completion'
      });
    }

    if (returnRequest.inspectionStatus !== 'APPROVED' && inspectionStatus !== 'APPROVED') {
      return res.status(400).json({
        message: 'Approve the return inspection before completing the refund'
      });
    }

    // Mark refund as completed
    const updated = await prisma.returnRequest.update({
      where: { id: returnId },
      data: {
        inspectionStatus: 'APPROVED',
        refundStatus: 'COMPLETED',
        refundCompletedAt: new Date()
      }
    });

    // Log activity
    await logActivity(
      returnRequest.orderId,
      'REFUND_COMPLETED',
      `Refund completed for ₹${returnRequest.refundAmount || returnRequest.order.totalAmount}`
    );

    // Send refund completion email
    if (returnRequest.order.shippingAddress && typeof returnRequest.order.shippingAddress === 'object') {
      const destEmail = returnRequest.order.shippingAddress.email || null;
      if (destEmail) {
        try {
          await sendMail(
            destEmail,
            'Refund Completed - Little Threads',
            TEMPLATES.REFUND_COMPLETED_EMAIL(returnRequest.refundAmount || returnRequest.order.totalAmount)
          );
        } catch (mailErr) {
          console.error('completeRefund.sendMail failed:', mailErr?.message || mailErr);
        }
      }
    }

    res.json({
      message: 'Refund marked as completed successfully',
      returnRequest: updated
    });
  } catch (error) {
    console.error('Error marking refund as complete:', error);
    res.status(500).json({ error: error.message });
  }
};
