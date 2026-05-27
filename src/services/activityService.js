import prisma from '../utils/prisma.js';
import { logger } from '../utils/logger.js';

/**
 * Log an activity for an order
 * @param {string} orderId - The ID of the order
 * @param {string} status - Short status tag (e.g. 'ORDER_PLACED')
 * @param {string} message - Descriptive message
 */
export const logActivity = async (orderId, status, message) => {
  try {
    if (!orderId) return;
    
    await prisma.orderActivity.create({
      data: {
        orderId: String(orderId),
        status,
        message,
      },
    });
    
    logger.info(`[ActivityLog] ${orderId}: ${status} - ${message}`);
  } catch (error) {
    logger.error(`[ActivityLog] Failed to log activity for ${orderId}: ${error.message}`);
    // Non-critical: don't throw error
  }
};

/**
 * Get all activities for an order
 * @param {string} orderId 
 */
export const getActivities = async (orderId) => {
  try {
    return await prisma.orderActivity.findMany({
      where: { orderId: String(orderId) },
      orderBy: { createdAt: 'desc' },
    });
  } catch (error) {
    logger.error(`[ActivityLog] Failed to fetch activities for ${orderId}: ${error.message}`);
    return [];
  }
};
