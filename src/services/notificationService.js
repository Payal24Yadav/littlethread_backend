import { sendSMS } from './smsService.js';
import { logger } from '../utils/logger.js';

const BRAND_NAME = 'Little Threads';

// Map order/payment events & statuses to SMS templates.
// Keep these messages short enough for SMS while preserving useful context.
const ORDER_SMS_TEMPLATES = {
  ORDER_CREATED: `Dear Customer, Your order has been placed successfully. We will notify you once it is processed. Regards, ${BRAND_NAME}`,
  PAYMENT_SUCCESS: `Dear Customer, Your payment has been successfully received. Your order is now confirmed. Regards, ${BRAND_NAME}`,

  PACKED: `Dear Customer, Your order has been packed and is ready for dispatch. Regards, ${BRAND_NAME}`,
  SHIPPED: (link = '') => `Dear Customer, Your order has been shipped. Tracking link: ${link}. Regards, ${BRAND_NAME}`,
  OUT_FOR_DELIVERY: `Dear Customer, Your order is out for delivery and will be delivered shortly. Regards, ${BRAND_NAME}`,
  DELIVERED: `Dear Customer, Your order has been successfully delivered. Thank you for shopping with us. Regards, ${BRAND_NAME}`,
  CANCELLED: `Dear Customer, Your order has been cancelled successfully. For any assistance please contact us. Regards, ${BRAND_NAME}`,
  REFUND_INITIATED: `Dear Customer, Your refund has been initiated and will be processed within 5-6 working days. Regards, ${BRAND_NAME}`,
  REFUNDED: `Dear Customer, Your refund has been successfully processed and credited. Regards, ${BRAND_NAME}`,
};

const getOrderPhone = (order) =>
  order?.shippingAddress?.phone ||
  order?.shippingAddress?.mobile ||
  order?.shippingAddress?.phoneNumber ||
  null;

const sendOrderSmsMessage = async (phone, message) => {
  try {
    return await sendSMS(phone, message);
  } catch (error) {
    logger.error('[NotificationService] Failed sending SMS:', error?.message || error);
    return false;
  }
};

export const notifyOrderCreated = async (order) => {
  const phone = getOrderPhone(order);
  if (!phone) return false;
  return sendOrderSmsMessage(phone, ORDER_SMS_TEMPLATES.ORDER_CREATED);
};

export const notifyPaymentSuccess = async (order) => {
  const phone = getOrderPhone(order);
  if (!phone) return false;
  return sendOrderSmsMessage(phone, ORDER_SMS_TEMPLATES.PAYMENT_SUCCESS);
};

export const notifyOrderStatus = async (order, status, { trackingLink } = {}) => {
  const phone = getOrderPhone(order);
  if (!phone) return false;

  const template = ORDER_SMS_TEMPLATES[status];
  if (!template) {
    logger.warn('[NotificationService] No SMS template for order status:', status);
    return false;
  }

  const message = typeof template === 'function' ? template(trackingLink || '') : template;
  return sendOrderSmsMessage(phone, message);
};
