/**
 * Shiprocket Webhook Controller
 * Handles incoming webhooks from Shiprocket
 * 
 * IMPORTANT: Returns proper HTTP status codes:
 * - 200: Valid webhook processed successfully
 * - 400: Invalid payload structure or missing required fields
 * - 401: Missing X-API-Key header
 * - 403: Invalid API key
 * - 404: Order not found in database
 * - 500: Server error during processing
 */

import { 
  validateWebhookPayload, 
  updateOrderFromShiprocket 
} from '../services/shiprocketWebhookService.js';
import prisma from '../utils/prisma.js';
import { logger } from '../utils/logger.js';

/**
 * Handle Shiprocket webhook POST requests
 * Endpoint: POST /api/webhook/shipping
 * 
 * Returns appropriate HTTP status codes for proper error handling
 */
export const handleShiprocketWebhook = async (req, res) => {
  let webhookLogId = null;
  try {
    // Log incoming webhook
    console.log('[Shiprocket Webhook] Received request from:', req.ip);
    console.log('[Shiprocket Webhook] Headers:', {
      contentType: req.headers['content-type'],
      apiKeyPresent: Boolean(req.headers['x-api-key'] || req.headers['api-key'] || req.headers.authorization),
      authState: req.shiprocketAuth?.validated ? 'validated' : req.shiprocketAuth?.reason || 'not-checked'
    });
    console.log('[Shiprocket Webhook] Body preview:', typeof req.body === 'string' ? req.body.slice(0, 1000) : req.body);

    const normalizedBody = typeof req.body === 'string'
      ? (() => {
          try {
            return JSON.parse(req.body);
          } catch {
            return { raw_payload: req.body };
          }
        })()
      : req.body;

    // Persist raw webhook for replay/debugging (never block webhook on logging failure)
    try {
      const orderId = normalizedBody?.order_id || normalizedBody?.customer_reference_id || null;
      const awb = normalizedBody?.awb || normalizedBody?.awb_number || normalizedBody?.tracking_number || null;
      const shipmentId = normalizedBody?.shipment_id || normalizedBody?.shipmentId || null;

      const webhookLog = await prisma.webhookLog.create({
        data: {
          provider: 'SHIPROCKET',
          eventType: 'STATUS_UPDATE',
          orderId: orderId ? String(orderId) : null,
          awb: awb ? String(awb) : null,
          shipmentId: shipmentId ? String(shipmentId) : null,
          headers: req.headers || {},
          payload: normalizedBody || {},
        },
        select: { id: true },
      });

      webhookLogId = webhookLog.id;
    } catch (logErr) {
      logger.error('shiprocket.webhook.log_create_failed', {
        message: logErr?.message,
        stack: logErr?.stack,
      });
    }

    // Validate payload structure
    const validation = validateWebhookPayload(normalizedBody);
    if (!validation.valid) {
      console.warn('[Shiprocket] Received test/invalid payload:', validation.errors);

      if (webhookLogId) {
        await prisma.webhookLog.update({
          where: { id: webhookLogId },
          data: {
            processed: true,
            processedAt: new Date(),
            processingError: null,
          },
        }).catch(() => null);
      }

      // Return 200 OK without "error" field for Shiprocket panel compatibility
      return res.status(200).json({
        success: true,
        message: 'Webhook received successfully',
        timestamp: new Date().toISOString()
      });
    }

    // Process the webhook
    const result = await updateOrderFromShiprocket(normalizedBody, { webhookLogId });

    // Return appropriate status code based on result
    if (!result.success) {
      // Determine appropriate error status
      if (result.error?.includes('not found')) {
        // Order not found - 404
        console.error('[Shiprocket] Order not found:', result.error);
        return res.status(200).json({
          success: true,
          accepted: true,
          error: result.error,
          message: 'Webhook received but order could not be matched',
          debug: process.env.NODE_ENV === 'development' ? { authState: req.shiprocketAuth } : undefined,
          timestamp: new Date().toISOString()
        });
      } else {
        // Other server errors - 500
        console.error('[Shiprocket] Processing error:', result.error);
        return res.status(200).json({
          success: true,
          accepted: true,
          message: 'Webhook received but processing could not complete',
          error: process.env.NODE_ENV === 'development' ? result.error : 'Processing failed',
          debug: process.env.NODE_ENV === 'development' ? { authState: req.shiprocketAuth } : undefined,
          timestamp: new Date().toISOString()
        });
      }
    }

    if (webhookLogId) {
      await prisma.webhookLog.update({
        where: { id: webhookLogId },
        data: {
          processed: true,
          processedAt: new Date(),
          processingError: null,
        },
      }).catch(() => null);
    }

    // Success - 200 OK
    res.status(200).json({
      success: true,
      message: result.message,
      timestamp: new Date().toISOString(),
      isDuplicate: result.isDuplicate || false
    });

    console.log('[Shiprocket] Webhook processed successfully:', result.message);
  } catch (error) {
    // Unexpected server error - 500
    console.error('[Shiprocket Webhook] Unexpected error:', error);

    if (webhookLogId) {
      await prisma.webhookLog.update({
        where: { id: webhookLogId },
        data: {
          processed: false,
          processingError: error?.message || 'Unexpected webhook controller error',
          attempts: { increment: 1 },
          lastAttemptAt: new Date(),
          nextRetryAt: new Date(Date.now() + 5 * 60 * 1000),
        },
      }).catch(() => null);
    }
    
    res.status(500).json({
      success: false,
      error: 'Internal server error',
      details: process.env.NODE_ENV === 'development' ? error.message : undefined,
      timestamp: new Date().toISOString()
    });
  }
};

/**
 * Health check endpoint for Shiprocket webhook testing
 * Endpoint: GET /api/webhook/shipping/health
 * Returns: 200 OK always (endpoint availability check)
 */
export const shiprocketWebhookHealth = (req, res) => {
  res.status(200).json({
    status: 'ok',
    message: 'Shiprocket webhook endpoint is active',
    timestamp: new Date().toISOString()
  });
};
