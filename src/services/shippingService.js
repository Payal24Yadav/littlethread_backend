import prisma from '../utils/prisma.js';
import { logger } from '../utils/logger.js';
import * as activityService from './activityService.js';

const NON_CANCELLABLE_STATUSES = ['PICKED', 'SHIPPED', 'DELIVERED'];

const shouldAutoSchedulePickup = () => {
  const explicit = String(
    process.env.SHIPROCKET_AUTO_SCHEDULE_PICKUP ||
      process.env.SHIPROCKET_ENABLE_AUTO_SHIPPING ||
      ''
  )
    .trim()
    .toLowerCase();
  if (explicit === 'true') return true;
  if (explicit === 'false') return false;
  return process.env.NODE_ENV === 'production';
};

const recordFailedShipment = async ({ orderId, stage, payload, error }) => {
  try {
    await prisma.failedShipment.create({
      data: {
        provider: 'SHIPROCKET',
        orderId: String(orderId),
        stage: String(stage),
        payload: payload ?? null,
        errorMessage: error?.message || 'Shiprocket operation failed',
        errorDetails: error?.details || null,
        attempts: 1,
        lastAttemptAt: new Date(),
        resolved: false,
      },
    });
  } catch (logError) {
    logger.error('shipping.failed_shipment.log_failed', {
      order_id: orderId,
      stage,
      message: logError?.message,
    });
  }
};

const withRetry = async (fn, { maxAttempts = 1, label = 'shiprocket.operation' } = {}) => {
  const attempts = Math.max(1, Number(maxAttempts || 1));
  let lastError = null;

  for (let attempt = 0; attempt < attempts; attempt += 1) {
    try {
      return await fn();
    } catch (error) {
      lastError = error;
      const statusCode = error?.statusCode || 500;
      const retriable = (statusCode >= 502 && statusCode <= 504) || error?.code === 'ECONNABORTED';

      if (!retriable || attempt >= attempts - 1) {
        throw error;
      }

      const delay = 800 * Math.pow(2, attempt);
      logger.warn(`${label}.retry`, { attempt: attempt + 1, delay_ms: delay, statusCode });
      await new Promise((resolve) => setTimeout(resolve, delay));
    }
  }

  throw lastError || new Error('Retry attempts exhausted');
};

const getProvider = async () => {
  const hasShiprocketCredentials =
    Boolean(process.env.SHIPROCKET_EMAIL && process.env.SHIPROCKET_PASSWORD) ||
    Boolean(process.env.SHIPROCKET_TOKEN);

  if (hasShiprocketCredentials) {
    logger.info('[ShippingService] Using Shiprocket provider');
    return import('./shiprocketService.js');
  }

  if (process.env.NODE_ENV !== 'production') {
    logger.warn('[ShippingService] Shiprocket credentials missing, falling back to mock provider');
    return import('./mockShippingService.js');
  }

  const error = new Error(
    'Shiprocket is not configured. Set SHIPROCKET_EMAIL and SHIPROCKET_PASSWORD.'
  );
  error.statusCode = 500;
  throw error;
};

const getStringValue = (...values) => values.find((value) => typeof value === 'string' && value.trim())?.trim() || '';

const normalizePhone10 = (phone) => String(phone || '').replace(/\D/g, '').slice(-10);

const validateShippingInputs = ({ address, dimensions }) => {
  const phone10 = normalizePhone10(address?.phone);
  if (!phone10 || phone10.length !== 10) {
    const error = new Error('Invalid phone number. Phone must be 10 digits.');
    error.statusCode = 400;
    error.details = { field: 'phone', expected: '10 digits', received: address?.phone ?? null };
    throw error;
  }

  const pincode = String(address?.pincode || '').trim();
  if (!/^\d{6}$/.test(pincode)) {
    const error = new Error('Invalid pincode. For India, pincode must be a 6-digit number.');
    error.statusCode = 400;
    error.details = { field: 'pincode', expected: '6 digits', received: address?.pincode ?? null };
    throw error;
  }

  const line1 = getStringValue(address?.line1);
  if (!line1) {
    const error = new Error('Address is required.');
    error.statusCode = 400;
    error.details = { field: 'address', expected: 'non-empty', received: address?.line1 ?? null };
    throw error;
  }

  const city = getStringValue(address?.city);
  const state = getStringValue(address?.state);
  if (!city || !state) {
    const error = new Error('City and state are required.');
    error.statusCode = 400;
    error.details = { field: !city ? 'city' : 'state', expected: 'non-empty' };
    throw error;
  }

  const length = Number(dimensions?.length);
  const breadth = Number(dimensions?.breadth);
  const height = Number(dimensions?.height);
  if (![length, breadth, height].every((v) => Number.isFinite(v) && v > 0)) {
    const error = new Error('Invalid dimensions. length, breadth, and height must be positive numbers.');
    error.statusCode = 400;
    error.details = { field: 'dimensions', received: dimensions ?? null };
    throw error;
  }

  return {
    phone10,
    pincode,
  };
};

const buildAddressFromOrder = (order, requestAddress = {}) => {
  const savedAddress = order?.shippingAddress || {};

  return {
    name: getStringValue(
      requestAddress.name,
      requestAddress.fullName,
      savedAddress.fullName,
      `${savedAddress.firstName || ''} ${savedAddress.lastName || ''}`.trim(),
      order?.customer?.name
    ),
    email: getStringValue(requestAddress.email, savedAddress.email, order?.customer?.email),
    phone: getStringValue(requestAddress.phone, savedAddress.phone),
    line1: getStringValue(requestAddress.line1, requestAddress.address, savedAddress.address, savedAddress.addressLine1),
    line2: getStringValue(requestAddress.line2, requestAddress.apartment, savedAddress.apartment, savedAddress.addressLine2),
    city: getStringValue(requestAddress.city, savedAddress.city),
    state: getStringValue(requestAddress.state, savedAddress.state),
    pincode: getStringValue(
      requestAddress.pincode,
      requestAddress.pinCode,
      savedAddress.pinCode,
      savedAddress.pincode
    ),
    country: getStringValue(requestAddress.country, savedAddress.country) || 'India',
  };
};

const buildItemsFromOrder = (order, requestItems) => {
  if (Array.isArray(requestItems) && requestItems.length) {
    return requestItems;
  }

  return (order?.items || []).map((item) => ({
    productId: item.productId,
    name: item.variantTitle ? `${item.product?.name} (${item.variantTitle})` : item.product?.name,
    sku: item.product?.slug || item.productId,
    quantity: item.quantity,
    price: item.price,
  }));
};

const deriveDimensionsFromOrder = (order) => {
  const items = order?.items || [];

  const numericValues = items.map((item) => ({
    quantity: Number(item.quantity || 0),
    weight: Number(item.product?.weight || 0),
    length: Number(item.product?.length || 0),
    breadth: Number(item.product?.breadth || 0),
    height: Number(item.product?.height || 0),
  }));

  return {
    weight:
      numericValues.reduce(
        (sum, item) => sum + (Number.isFinite(item.weight) ? item.weight * Math.max(item.quantity, 1) : 0),
        0
      ) || 0.5,
    length:
      numericValues.reduce((max, item) => (Number.isFinite(item.length) ? Math.max(max, item.length) : max), 0) || 10,
    breadth:
      numericValues.reduce((max, item) => (Number.isFinite(item.breadth) ? Math.max(max, item.breadth) : max), 0) || 10,
    height:
      numericValues.reduce(
        (sum, item) => sum + (Number.isFinite(item.height) ? item.height * Math.max(item.quantity, 1) : 0),
        0
      ) || 5,
  };
};

const getOrderForShipping = async (orderId) => {
  const order = await prisma.order.findUnique({
    where: { id: orderId },
    include: {
      customer: {
        select: {
          id: true,
          name: true,
          email: true,
        },
      },
      items: {
        include: {
          product: {
            select: {
              id: true,
              name: true,
              weight: true,
              length: true,
              breadth: true,
              height: true,
            },
          },
        },
      },
    },
  });

  if (!order) {
    const error = new Error(`Order ${orderId} was not found`);
    error.statusCode = 404;
    throw error;
  }

  return order;
};

const buildOrderPayload = async (input) => {
  const orderId = String(input?.orderId || '').trim();
  if (!orderId) {
    const error = new Error('orderId is required');
    error.statusCode = 400;
    throw error;
  }

  const order = await getOrderForShipping(orderId);
  const derivedDimensions = deriveDimensionsFromOrder(order);

  const dimensions = {
    length: Number(input.length ?? input.dimensions?.length ?? derivedDimensions.length ?? 10),
    breadth: Number(input.breadth ?? input.dimensions?.breadth ?? derivedDimensions.breadth ?? 10),
    height: Number(input.height ?? input.dimensions?.height ?? derivedDimensions.height ?? 5),
  };

  const address = buildAddressFromOrder(order, input.address);
  const items = buildItemsFromOrder(order, input.items);

  const { phone10, pincode } = validateShippingInputs({ address, dimensions });

  logger.info('shiprocket.create.request', {
    order_id: orderId,
    shiprocket_channel_id: process.env.SHIPROCKET_CHANNEL_ID || null,
    customer_id: order?.customerId || null,
    customer_email: order?.customer?.email || address?.email || null,
    pickup_location: process.env.SHIPROCKET_PICKUP_LOCATION || null,
    pincode,
    city: address.city,
    state: address.state,
    phone_last4: phone10 ? phone10.slice(-4) : null,
    weight: Number(input.weight ?? derivedDimensions.weight ?? 0.5),
    dimensions,
    items_count: Array.isArray(items) ? items.length : 0,
    source: 'api.shipping.create',
  });

  return {
    orderId,
    paymentMethod: getStringValue(input.paymentMethod, order.paymentMethod) || 'prepaid',
    totalAmount: Number(input.totalAmount ?? order.totalAmount ?? 0),
    weight: Number(input.weight ?? derivedDimensions.weight ?? 0.5),
    length: dimensions.length,
    breadth: dimensions.breadth,
    height: dimensions.height,
    dimensions,
    address: {
      ...address,
      phone: phone10,
      pincode,
    },
    items,
  };
};

const normalizeShipmentRecord = (shipment) => ({
  id: shipment.id,
  order_id: shipment.orderId,
  shipment_id: shipment.shipmentId,
  awb: shipment.awb,
  courier: shipment.courier,
  status: shipment.status,
  labelUrl: shipment.labelUrl || null,
  created_at: shipment.createdAt,
});

export const createShipment = async (input) => {
  const payload = await buildOrderPayload(input);
  const existing = await prisma.shipment.findUnique({
    where: { orderId: payload.orderId },
  });

  if (existing) {
    return {
      created: false,
      shipment: normalizeShipmentRecord(existing),
    };
  }

  const provider = await getProvider();
  
  const maxAttempts = Math.max(1, Number(process.env.SHIPMENT_CREATE_MAX_ATTEMPTS || 1));
  const result = await withRetry(
    () => provider.createShipment(payload),
    { maxAttempts, label: 'shiprocket.create_shipment' }
  ).catch(async (error) => {
    await recordFailedShipment({ orderId: payload.orderId, stage: 'CREATE_SHIPMENT', payload, error });
    throw error;
  });

  const shipment = await prisma.shipment.create({
    data: {
      orderId: payload.orderId,
      shipmentId: String(result.shipment_id),
      awb: String(result.awb),
      courier: result.courier || 'Shiprocket',
      status: result.status || 'AWB_ASSIGNED',
      labelUrl: result.label_url || null,
    },
  });

  await activityService.logActivity(
    payload.orderId,
    'SHIPMENT_CREATED',
    `Shipment manifested with ${shipment.courier}. AWB: ${shipment.awb}`
  );

  // Sync order table with shipping identifiers/status (so admin/customer views stay updated)
  try {
    const existingOrder = await prisma.order.findUnique({
      where: { id: payload.orderId },
      select: { shippingAddress: true },
    });

    await prisma.order.update({
      where: { id: payload.orderId },
      data: {
        status: shipment.status || 'AWB_ASSIGNED',
        shippingAddress: {
          ...(existingOrder?.shippingAddress || {}),
          awb: shipment.awb,
          courierName: shipment.courier,
          lastStatusUpdate: new Date().toISOString(),
        },
      },
    });
  } catch (syncErr) {
    logger.error('shipping.order_sync.failed', { order_id: payload.orderId, message: syncErr?.message });
  }

  // Auto schedule pickup in production (or when explicitly enabled)
  let pickupResult = null;
  if (shouldAutoSchedulePickup()) {
    try {
      const pickupAttempts = Math.max(1, Number(process.env.SHIPMENT_PICKUP_MAX_ATTEMPTS || 1));
      pickupResult = await withRetry(
        () => provider.schedulePickup(shipment.shipmentId),
        { maxAttempts: pickupAttempts, label: 'shiprocket.schedule_pickup' }
      );

      const updated = await prisma.shipment.update({
        where: { shipmentId: shipment.shipmentId },
        data: {
          pickupId: pickupResult.pickup_id || null,
          status: pickupResult.status || 'PICKUP_SCHEDULED',
        },
      });

      try {
        const existingOrder = await prisma.order.findUnique({
          where: { id: payload.orderId },
          select: { shippingAddress: true },
        });

        await prisma.order.update({
          where: { id: payload.orderId },
          data: {
            status: pickupResult.status || 'PICKUP_SCHEDULED',
            shippingAddress: {
              ...(existingOrder?.shippingAddress || {}),
              awb: shipment.awb,
              courierName: shipment.courier,
              lastStatusUpdate: new Date().toISOString(),
            },
          },
        });
      } catch (syncErr) {
        logger.error('shipping.order_sync.pickup.failed', { order_id: payload.orderId, message: syncErr?.message });
      }

      await activityService.logActivity(
        payload.orderId,
        'PICKUP_SCHEDULED',
        `Pickup scheduled. Pickup ID: ${pickupResult.pickup_id || 'N/A'}`
      );

      return {
        created: true,
        shipment: normalizeShipmentRecord(updated),
        provider_response: {
          shipment_id: result.shipment_id,
          order_id: result.order_id,
          courier: result.courier,
          awb: result.awb,
          status: pickupResult.status || result.status,
          label_url: result.label_url || null,
          pickup_id: pickupResult.pickup_id || null,
        },
      };
    } catch (error) {
      await recordFailedShipment({
        orderId: payload.orderId,
        stage: 'SCHEDULE_PICKUP',
        payload: { shipmentId: shipment.shipmentId, orderId: payload.orderId },
        error,
      });
      logger.error('shiprocket.auto_pickup.failed', { order_id: payload.orderId, message: error?.message });
    }
  }

  return {
    created: true,
    shipment: normalizeShipmentRecord(shipment),
    provider_response: {
      shipment_id: result.shipment_id,
      order_id: result.order_id,
      courier: result.courier,
      awb: result.awb,
      status: result.status,
      label_url: result.label_url || null,
    },
  };
};

export const trackShipment = async ({ awb, orderId }) => {
  let resolvedAwb = getStringValue(awb);
  let shipmentForEvent = null;

  if (!resolvedAwb && orderId) {
    const shipment = await prisma.shipment.findUnique({
      where: { orderId: String(orderId) },
    });

    if (!shipment?.awb) {
      const error = new Error(`No shipment found for order ${orderId}`);
      error.statusCode = 404;
      throw error;
    }

    shipmentForEvent = shipment;
    resolvedAwb = shipment.awb;
  }

  if (!resolvedAwb) {
    const error = new Error('awb or orderId is required');
    error.statusCode = 400;
    throw error;
  }

  const provider = await getProvider();
  const tracking = await provider.trackShipment(resolvedAwb);

  await prisma.shipment.updateMany({
    where: { awb: resolvedAwb },
    data: {
      status: tracking.current_status || tracking.status || 'UNKNOWN',
      lastTrackedAt: new Date(),
    },
  });

  // Propagate status change to the order
  const shipment = await prisma.shipment.findFirst({
    where: { awb: resolvedAwb },
  });

  shipmentForEvent = shipmentForEvent || shipment;

  prisma.shipmentTrackingEvent.create({
    data: {
      provider: 'SHIPROCKET',
      source: 'POLL',
      orderId: shipmentForEvent?.orderId || (orderId ? String(orderId) : null),
      awb: resolvedAwb,
      shipmentId: shipmentForEvent?.shipmentId || null,
      status: String(tracking.current_status || tracking.status || 'UNKNOWN'),
      eventTime: new Date(),
      raw: tracking?.raw || tracking || {},
    },
  }).catch(() => null);

  if (shipment && tracking.current_status) {
    const statusMap = {
      'PICKED': 'SHIPPED',
      'SHIPPED': 'SHIPPED',
      'DELIVERED': 'DELIVERED',
      'CANCELLED': 'SHIPPING_CANCELLED',
      'RETURNED': 'RETURNED'
    };

    const newOrderStatus = statusMap[tracking.current_status.toUpperCase()];
    if (newOrderStatus) {
      await prisma.order.update({
        where: { id: shipment.orderId },
        data: { status: newOrderStatus }
      });
      
      await activityService.logActivity(
        shipment.orderId,
        `STATUS_${tracking.current_status.toUpperCase()}`,
        `Order status updated to ${newOrderStatus} based on courier tracking.`
      );
    }
  }

  return tracking;
};

export const cancelShipment = async (shipmentId) => {
  if (!shipmentId) {
    const error = new Error('shipmentId is required');
    error.statusCode = 400;
    throw error;
  }

  const existingShipment = await prisma.shipment.findUnique({
    where: { shipmentId: String(shipmentId) },
  });

  if (
    existingShipment?.status &&
    NON_CANCELLABLE_STATUSES.some((status) =>
      existingShipment.status.toUpperCase().includes(status)
    )
  ) {
    const error = new Error(`Shipment cannot be cancelled once it is ${existingShipment.status}`);
    error.statusCode = 400;
    throw error;
  }

  const provider = await getProvider();
  const result = await provider.cancelShipment(shipmentId);

  await prisma.shipment.updateMany({
    where: { shipmentId: String(shipmentId) },
    data: { status: 'CANCELLED' },
  });

  await activityService.logActivity(
    existingShipment.orderId,
    'SHIPMENT_CANCELLED',
    `Shipment ${shipmentId} has been cancelled.`
  );

  return result;
};

export const generateLabel = async ({ shipmentId, orderId }) => {
  let shipment = null;

  if (shipmentId) {
    shipment = await prisma.shipment.findUnique({
      where: { shipmentId: String(shipmentId) },
    });
  } else if (orderId) {
    shipment = await prisma.shipment.findUnique({
      where: { orderId: String(orderId) },
    });
  }

  if (!shipment) {
    const error = new Error('Shipment not found');
    error.statusCode = 404;
    throw error;
  }

  if (shipment.labelUrl) {
    return {
      shipment: normalizeShipmentRecord(shipment),
      label_url: shipment.labelUrl,
    };
  }

  const provider = await getProvider();
  const result = await provider.generateLabel(shipment.shipmentId);

  const updatedShipment = await prisma.shipment.update({
    where: { shipmentId: shipment.shipmentId },
    data: { labelUrl: result.label_url || shipment.labelUrl },
  });

  await activityService.logActivity(
    shipment.orderId,
    'LABEL_GENERATED',
    'Shipping label generated successfully.'
  );

  return {
    shipment: normalizeShipmentRecord(updatedShipment),
    label_url: result.label_url,
  };
};

export const schedulePickup = async ({ shipmentId, orderId }) => {
  let shipment = null;

  if (shipmentId) {
    shipment = await prisma.shipment.findUnique({
      where: { shipmentId: String(shipmentId) },
    });
  } else if (orderId) {
    shipment = await prisma.shipment.findUnique({
      where: { orderId: String(orderId) },
    });
  }

  if (!shipment) {
    const error = new Error('Shipment not found');
    error.statusCode = 404;
    throw error;
  }

  const provider = await getProvider();
  const result = await provider.schedulePickup(shipment.shipmentId);

  const updatedShipment = await prisma.shipment.update({
    where: { shipmentId: shipment.shipmentId },
    data: { status: result.status || 'PICKUP_SCHEDULED' },
  });

  await activityService.logActivity(
    shipment.orderId,
    'PICKUP_SCHEDULED',
    `Pickup scheduled. Status: ${result.status || 'PICKUP_SCHEDULED'}`
  );

  return {
    shipment: normalizeShipmentRecord(updatedShipment),
    pickup_id: result.pickup_id || null,
    status: result.status || 'PICKUP_SCHEDULED',
  };
};

export const getShipmentByOrder = async (orderId) => {
  const shipment = await prisma.shipment.findUnique({
    where: { orderId: String(orderId) },
  });

  if (!shipment) {
    return null;
  }

  if (shipment.labelUrl) {
    return normalizeShipmentRecord(shipment);
  }

  try {
    const provider = await getProvider();
    const label = await provider.generateLabel(shipment.shipmentId);
    const updatedShipment = await prisma.shipment.update({
      where: { shipmentId: shipment.shipmentId },
      data: { labelUrl: label.label_url || shipment.labelUrl },
    });

    return normalizeShipmentRecord(updatedShipment);
  } catch (error) {
    logger.warn(
      `[ShippingService] Unable to hydrate label for shipment ${shipment.shipmentId}: ${error.message}`
    );
    return normalizeShipmentRecord(shipment);
  }
};

export const getAllShipments = async ({ status, page = 1, limit = 20 } = {}) => {
  const where = status ? { status } : {};
  const skip = (page - 1) * limit;

  const [shipments, total] = await Promise.all([
    prisma.shipment.findMany({
      where,
      skip,
      take: limit,
      orderBy: { createdAt: 'desc' },
    }),
    prisma.shipment.count({ where }),
  ]);

  return {
    shipments: shipments.map(normalizeShipmentRecord),
    total,
    page,
    limit,
  };
};

export const listChannels = async () => {
  const provider = await getProvider();

  if (typeof provider.listChannels !== 'function') {
    const error = new Error('Shipping provider does not support channels listing');
    error.statusCode = 501;
    throw error;
  }

  const result = await provider.listChannels();
  const configured = String(process.env.SHIPROCKET_CHANNEL_ID || '').trim();

  let selected = null;
  if (configured) {
    selected = (result.channels || []).find((c) => String(c.id) === configured) || null;
  }

  if (!selected) {
    selected =
      (result.channels || []).find((c) => String(c.name || '').toLowerCase().includes('custom')) ||
      (result.channels || [])[0] ||
      null;
  }

  logger.info('shiprocket.channels.selected_default', {
    configured_channel_id: configured || null,
    selected_channel_id: selected ? String(selected.id) : null,
    selected_channel_name: selected?.name || null,
    selected_channel_type: selected?.type || null,
  });

  return {
    channels: result.channels || [],
    recommendedChannelId: selected ? String(selected.id) : null,
    recommendedChannelName: selected?.name || null,
    recommendedChannelType: selected?.type || null,
  };
};
