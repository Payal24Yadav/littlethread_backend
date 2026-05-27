import prisma from '../utils/prisma.js';
import { logger } from '../utils/logger.js';
import { replayWebhookLog } from '../services/shiprocketWebhookService.js';

const isEnabled = () =>
  String(process.env.SHIPROCKET_ENABLE_RETRY_WORKER || '').trim().toLowerCase() === 'true';

export const startShiprocketWebhookRetryWorker = ({
  intervalMs = 60_000,
  batchSize = 10,
  maxAttempts = 6,
} = {}) => {
  if (!isEnabled()) {
    logger.info('shiprocket.retry_worker.disabled');
    return null;
  }

  logger.info('shiprocket.retry_worker.started', { intervalMs, batchSize, maxAttempts });

  const timer = setInterval(async () => {
    try {
      const now = new Date();

      const candidates = await prisma.webhookLog.findMany({
        where: {
          provider: 'SHIPROCKET',
          processed: false,
          attempts: { lt: maxAttempts },
          OR: [{ nextRetryAt: null }, { nextRetryAt: { lte: now } }],
        },
        orderBy: { receivedAt: 'asc' },
        take: batchSize,
        select: { id: true },
      });

      for (const row of candidates) {
        try {
          await replayWebhookLog(row.id);
        } catch (err) {
          logger.error('shiprocket.retry_worker.replay_failed', {
            webhook_log_id: row.id,
            message: err?.message,
          });
        }
      }
    } catch (error) {
      logger.error('shiprocket.retry_worker.tick_failed', {
        message: error?.message,
        stack: error?.stack,
      });
    }
  }, Math.max(10_000, Number(intervalMs) || 60_000));

  // Allow process to exit naturally.
  timer.unref?.();

  return timer;
};

