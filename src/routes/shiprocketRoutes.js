/**
 * Shiprocket Webhook Routes
 * Handles all Shiprocket webhook endpoints
 * 
 * Note: Route is /api/webhook/shipping (NOT /shiprocket/webhook)
 * Reason: Shiprocket sometimes blocks/behaves inconsistently with URLs containing "shiprocket"
 */

import express from 'express';
import { validateShiprocketToken } from '../middleware/validateShiprocketToken.js';
import { requireAdmin } from '../middleware/requireAdmin.js';
import { 
  handleShiprocketWebhook,
  shiprocketWebhookHealth
} from '../controllers/shiprocketController.js';
import prisma from '../utils/prisma.js';
import { replayWebhookLog } from '../services/shiprocketWebhookService.js';

const router = express.Router();

// Shiprocket may send bodies as JSON, form-urlencoded, or plain text depending on the webhook/testing path.
router.use(express.json({ type: ['application/json', 'application/*+json', 'text/plain'] }));
router.use(express.urlencoded({ extended: true }));
router.use(express.text({ type: ['text/plain', 'application/xml', 'application/octet-stream'] }));

/**
 * POST /api/webhook/shipping
 * Main webhook endpoint - requires x-api-key header validation
 * Uses generic route name to avoid Shiprocket URL filtering issues
 */
router.post('/shipping', validateShiprocketToken, handleShiprocketWebhook);

/**
 * GET /api/webhook/shipping
 * Handle ping/verification requests from Shiprocket
 */
router.get('/shipping', (req, res) => res.status(200).send('OK'));

/**
 * GET /api/webhook/shipping/health
 * Health check endpoint - no token required
 */
router.get('/shipping/health', shiprocketWebhookHealth);

/**
 * Admin: list unprocessed Shiprocket webhooks for retry/replay
 * GET /api/webhook/shipping/failed
 */
router.get('/shipping/failed', requireAdmin, async (req, res) => {
  const limit = Math.min(100, Math.max(1, Number(req.query.limit || 50)));
  const logs = await prisma.webhookLog.findMany({
    where: { provider: 'SHIPROCKET', processed: false },
    orderBy: { receivedAt: 'desc' },
    take: limit,
    select: {
      id: true,
      orderId: true,
      awb: true,
      shipmentId: true,
      receivedAt: true,
      attempts: true,
      lastAttemptAt: true,
      nextRetryAt: true,
      processingError: true,
    },
  });

  return res.status(200).json({ success: true, data: logs });
});

/**
 * Admin: replay a webhook log by id
 * POST /api/webhook/shipping/replay/:id
 */
router.post('/shipping/replay/:id', requireAdmin, async (req, res) => {
  try {
    const result = await replayWebhookLog(req.params.id);
    return res.status(result.success ? 200 : 500).json(result);
  } catch (error) {
    return res.status(error?.statusCode || 500).json({
      success: false,
      message: error?.message || 'Failed to replay webhook',
    });
  }
});

export default router;
