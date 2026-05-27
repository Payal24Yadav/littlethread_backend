export const ORDER_STATUS = {
  ORDERED: 'ORDERED',
  SHIPPED: 'SHIPPED',
  IN_TRANSIT: 'IN_TRANSIT',
  OUT_FOR_DELIVERY: 'OUT_FOR_DELIVERY',
  DELIVERED: 'DELIVERED',
  CANCELED: 'CANCELED',
};

const ADMIN_FILTER_TO_STATUSES = {
  all: null,
  ordered: [
    'ORDERED',
    'ordered',
    'PAID',
    'paid',
    'COD_CONFIRMED',
    'cod_confirmed',
    'COD_PENDING',
    'cod_pending',
    'PAYMENT_PENDING',
    'payment_pending',
    'PENDING',
    'pending',
    'PROCESSING',
    'processing',
    'READY_TO_SHIP',
    'ready_to_ship',
    'AWB_ASSIGNED',
    'awb_assigned',
    'PICKUP_SCHEDULED',
    'pickup_scheduled',
    'PICKED',
    'picked',
  ],
  shipped: ['SHIPPED', 'shipped', 'IN_TRANSIT', 'in_transit', 'OUT_FOR_DELIVERY', 'out_for_delivery'],
  delivered: ['DELIVERED', 'delivered'],
  canceled: ['CANCELED', 'canceled', 'CANCELLED', 'cancelled', 'FAILED', 'failed'],
};

export const normalizeOrderStatus = (status) => {
  const normalized = String(status || '').trim().toUpperCase();
  if (normalized === 'CANCELLED') return 'CANCELED';
  return normalized;
};

export const toLifecycleStatus = (status) => {
  const normalized = normalizeOrderStatus(status);
  if (ADMIN_FILTER_TO_STATUSES.delivered.includes(normalized)) return ORDER_STATUS.DELIVERED;
  if (ADMIN_FILTER_TO_STATUSES.shipped.includes(normalized)) return ORDER_STATUS.SHIPPED;
  if (ADMIN_FILTER_TO_STATUSES.canceled.includes(normalized)) return ORDER_STATUS.CANCELED;
  return ORDER_STATUS.ORDERED;
};

export const getStatusesForAdminFilter = (statusFilter = 'all') => {
  return ADMIN_FILTER_TO_STATUSES[String(statusFilter || 'all').trim().toLowerCase()] ?? null;
};

export const isAllowedAdminFilter = (statusFilter = 'all') => {
  return Object.prototype.hasOwnProperty.call(
    ADMIN_FILTER_TO_STATUSES,
    String(statusFilter || 'all').trim().toLowerCase()
  );
};
