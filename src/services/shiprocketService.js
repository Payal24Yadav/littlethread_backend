import axios from 'axios';
import { logger } from '../utils/logger.js';

const DEFAULT_BASE_URL = 'https://apiv2.shiprocket.in';
const API_PREFIX = '/v1/external';
const REQUEST_TIMEOUT_MS = Number(process.env.SHIPROCKET_REQUEST_TIMEOUT_MS || 8_000);
const SERVICEABILITY_TIMEOUT_MS = Number(process.env.SHIPROCKET_SERVICEABILITY_TIMEOUT_MS || 3_000);
const TOKEN_EXPIRY_SAFETY_MS = 5 * 60 * 1000;

let tokenCache = {
  token: null,
  expiresAt: 0,
};

const getBaseUrl = () => (process.env.SHIPROCKET_BASE_URL || DEFAULT_BASE_URL).replace(/\/+$/, '');

// Allow SHIPROCKET_BASE_URL to be either:
// - https://apiv2.shiprocket.in  (recommended)
// - https://apiv2.shiprocket.in/v1/external (supported for compatibility)
const getApiBaseUrl = () => {
  const base = getBaseUrl();
  if (base.toLowerCase().endsWith(API_PREFIX)) {
    return base;
  }
  return `${base}${API_PREFIX}`;
};

const buildShiprocketError = (error, fallbackMessage) => {
  if (error?.code === 'ECONNABORTED') {
    const normalizedError = new Error('Shiprocket request timed out. Please try again.');
    normalizedError.statusCode = 504;
    normalizedError.details = {
      code: error.code,
      timeout: error?.config?.timeout || REQUEST_TIMEOUT_MS,
    };
    return normalizedError;
  }

  if (error?.response) {
    const { status, data } = error.response;
    const message =
      data?.message ||
      data?.error ||
      data?.errors?.[0] ||
      fallbackMessage;

    const normalizedError = new Error(message);
    // Shiprocket sometimes returns validation failures as 500/422 with a message string.
    // Normalize obvious input errors to 400 so callers can show actionable feedback.
    const lowerMessage = String(message || '').toLowerCase();
    const looksLikeClientError =
      lowerMessage.includes('pickup') ||
      lowerMessage.includes('pincode') ||
      lowerMessage.includes('pin code') ||
      lowerMessage.includes('postcode') ||
      lowerMessage.includes('weight') ||
      lowerMessage.includes('dimension') ||
      lowerMessage.includes('address') ||
      lowerMessage.includes('phone') ||
      lowerMessage.includes('invalid');

    normalizedError.statusCode = looksLikeClientError ? 400 : status || 502;
    normalizedError.details = data;
    return normalizedError;
  }

  if (error?.request) {
    const normalizedError = new Error(fallbackMessage || 'No response received from Shiprocket');
    normalizedError.statusCode = 502;
    return normalizedError;
  }

  return error;
};

const decodeJwtExpiry = (token) => {
  try {
    const payload = token.split('.')[1];
    if (!payload) return 0;

    const normalized = payload.replace(/-/g, '+').replace(/_/g, '/');
    const padded = normalized + '='.repeat((4 - (normalized.length % 4 || 4)) % 4);
    const decoded = JSON.parse(Buffer.from(padded, 'base64').toString('utf8'));

    return typeof decoded?.exp === 'number' ? decoded.exp * 1000 : 0;
  } catch {
    return 0;
  }
};

const setTokenCache = (token) => {
  const expiresAt = decodeJwtExpiry(token);
  tokenCache = {
    token,
    expiresAt,
  };
  return token;
};

const isTokenValid = () =>
  Boolean(
    tokenCache.token &&
      tokenCache.expiresAt &&
      Date.now() < tokenCache.expiresAt - TOKEN_EXPIRY_SAFETY_MS
  );

const hydrateTokenFromEnv = () => {
  if (tokenCache.token) {
    return;
  }

  const existingToken = process.env.SHIPROCKET_TOKEN;
  if (!existingToken) {
    return;
  }

  const expiresAt = decodeJwtExpiry(existingToken);
  if (expiresAt && Date.now() < expiresAt - TOKEN_EXPIRY_SAFETY_MS) {
    setTokenCache(existingToken);
    logger.info('[ShiprocketService] Reusing existing Shiprocket token from environment');
  }
};

const login = async () => {
  const email = process.env.SHIPROCKET_EMAIL;
  const password = process.env.SHIPROCKET_PASSWORD;

  if (!email || !password) {
    const error = new Error(
      'Missing Shiprocket credentials. Set SHIPROCKET_EMAIL and SHIPROCKET_PASSWORD.'
    );
    error.statusCode = 500;
    throw error;
  }

  try {
    logger.info('[ShiprocketService] Generating a new Shiprocket token');
    const { data } = await axios.post(
      `${getApiBaseUrl()}/auth/login`,
      { email, password },
      {
        headers: { 'Content-Type': 'application/json' },
        timeout: REQUEST_TIMEOUT_MS,
      }
    );

    if (!data?.token) {
      throw new Error('Shiprocket auth response did not include a token');
    }

    const expiresAt = decodeJwtExpiry(data.token);
    logger.info('[ShiprocketService] Shiprocket login success', {
      email: String(email).replace(/(^.).*(@.*$)/, '$1***$2'),
      token_expires_at: expiresAt ? new Date(expiresAt).toISOString() : null,
    });

    return setTokenCache(data.token);
  } catch (error) {
    throw buildShiprocketError(error, 'Unable to authenticate with Shiprocket');
  }
};

export const getToken = async () => {
  hydrateTokenFromEnv();

  if (isTokenValid()) {
    return tokenCache.token;
  }

  // If the user is relying on a static token, fail loudly with a useful message
  // instead of attempting an email/password login that isn't configured.
  if (process.env.SHIPROCKET_TOKEN && !(process.env.SHIPROCKET_EMAIL && process.env.SHIPROCKET_PASSWORD)) {
    const err = new Error(
      'SHIPROCKET_TOKEN is present but is expired/invalid, and SHIPROCKET_EMAIL/SHIPROCKET_PASSWORD are not set. Provide valid login credentials or refresh SHIPROCKET_TOKEN.'
    );
    err.statusCode = 500;
    throw err;
  }

  return login();
};

const request = async (config, { retryOnUnauthorized = true } = {}) => {
  try {
    const token = await getToken();

    return await axios({
      baseURL: getApiBaseUrl(),
      timeout: REQUEST_TIMEOUT_MS,
      ...config,
      headers: {
        Authorization: `Bearer ${token}`,
        'Content-Type': 'application/json',
        ...(config.headers || {}),
      },
    });
  } catch (error) {
    if (retryOnUnauthorized && error?.response?.status === 401) {
      logger.warn('[ShiprocketService] Token rejected by Shiprocket, refreshing token');
      tokenCache = { token: null, expiresAt: 0 };

      return request(config, { retryOnUnauthorized: false });
    }

    throw buildShiprocketError(error, 'Shiprocket request failed');
  }
};

const toPositiveNumber = (value, fallback) => {
  const parsed = Number(value);
  return Number.isFinite(parsed) && parsed > 0 ? parsed : fallback;
};

const normalizePhone = (phone) => String(phone || '').replace(/\D/g, '').slice(-10);

const normalizeAddress = (address = {}) => ({
  name: address.name || address.fullName || [address.firstName, address.lastName].filter(Boolean).join(' '),
  email: address.email || '',
  phone: normalizePhone(address.phone),
  line1: address.line1 || address.address || address.addressLine1 || '',
  line2: address.line2 || address.apartment || address.addressLine2 || '',
  city: address.city || '',
  state: address.state || '',
  pincode: String(address.pincode || address.pinCode || '').trim(),
  country:
    String(address.country || '').toUpperCase() === 'IN'
      ? 'India'
      : address.country || 'India',
});

const normalizeOrderItem = (item, index) => ({
  name: item.name || `Item ${index + 1}`,
  sku: item.sku || item.productId || `item-${index + 1}`,
  units: toPositiveNumber(item.quantity, 1),
  selling_price: Number(item.price || 0).toFixed(2),
});

const createOrderPayload = (orderData) => {
  const address = normalizeAddress(orderData.address);
  const items = Array.isArray(orderData.items) ? orderData.items : [];

  if (!address.name || !address.line1 || !address.city || !address.state || !address.pincode || !address.phone) {
    const error = new Error(
      'Order shipping address is incomplete. name, address, city, state, pincode, and phone are required.'
    );
    error.statusCode = 400;
    throw error;
  }

  if (!items.length) {
    const error = new Error('At least one order item is required to create a shipment');
    error.statusCode = 400;
    throw error;
  }

  if (!/^\d{10}$/.test(String(address.phone || ''))) {
    const error = new Error('Invalid phone number. Phone must be 10 digits.');
    error.statusCode = 400;
    throw error;
  }

  const dimensions = {
    length: toPositiveNumber(orderData.length ?? orderData.dimensions?.length, 10),
    breadth: toPositiveNumber(orderData.breadth ?? orderData.dimensions?.breadth, 10),
    height: toPositiveNumber(orderData.height ?? orderData.dimensions?.height, 10),
  };

  const pickupLocation = String(process.env.SHIPROCKET_PICKUP_LOCATION || '').trim();
  if (!pickupLocation) {
    const error = new Error(
      'SHIPROCKET_PICKUP_LOCATION is not set. Set it to the exact pickup location name from your Shiprocket dashboard (e.g. "Store").'
    );
    error.statusCode = 500;
    throw error;
  }

  const channelIdRaw = String(process.env.SHIPROCKET_CHANNEL_ID || '').trim();
  const channelId = channelIdRaw ? Number(channelIdRaw) : null;
  if (channelIdRaw && !Number.isFinite(channelId)) {
    const error = new Error('SHIPROCKET_CHANNEL_ID must be a number if provided.');
    error.statusCode = 500;
    throw error;
  }

  // Shiprocket expects Indian pincodes to be 6 digits. Validate early to avoid confusing API errors.
  if (address.country === 'India' && !/^\d{6}$/.test(String(address.pincode || ''))) {
    const error = new Error('Invalid pincode. For India, pincode must be a 6-digit number.');
    error.statusCode = 400;
    throw error;
  }

  return {
    order_id: String(orderData.orderId),
    order_date: new Date().toISOString().slice(0, 10),
    pickup_location: pickupLocation,
    ...(channelId ? { channel_id: channelId } : {}),
    billing_customer_name: address.name,
    billing_last_name: '',
    billing_address: address.line1,
    billing_address_2: address.line2,
    billing_city: address.city,
    billing_pincode: address.pincode,
    billing_state: address.state,
    billing_country: address.country,
    billing_email: address.email || process.env.SHIPROCKET_FALLBACK_EMAIL || 'support@example.com',
    billing_phone: address.phone,
    shipping_is_billing: true,
    order_items: items.map(normalizeOrderItem),
    payment_method: String(orderData.paymentMethod || '').toLowerCase() === 'cod' ? 'COD' : 'Prepaid',
    sub_total: Number(orderData.totalAmount || 0).toFixed(2),
    length: dimensions.length,
    breadth: dimensions.breadth,
    height: dimensions.height,
    weight: toPositiveNumber(orderData.weight, 0.5),
  };
};

const pickCourierOption = (options = []) => {
  if (!Array.isArray(options) || !options.length) {
    return null;
  }

  return [...options].sort((left, right) => {
    const rateDiff = Number(left.rate || left.freight_charge || 0) - Number(right.rate || right.freight_charge || 0);
    if (rateDiff !== 0) return rateDiff;

    return Number(left.etd_hours || 0) - Number(right.etd_hours || 0);
  })[0];
};

const getLabelUrlFromResponse = (response, shipmentId) =>
  response?.label_url ||
  response?.response?.label_url ||
  response?.data?.label_url ||
  response?.pdf_url ||
  response?.response?.data?.label_url ||
  `${getApiBaseUrl()}/courier/generate/label?shipment_id[]=${encodeURIComponent(shipmentId)}`;

const getCourierForShipment = async ({ shipmentId, orderData }) => {
  const pickupPostcode = String(process.env.SHIPROCKET_PICKUP_POSTCODE || '').trim();
  const deliveryPostcode = String(orderData?.address?.pincode || orderData?.address?.pinCode || '').trim();

  if (!pickupPostcode || !deliveryPostcode) {
    return null;
  }

  const serviceabilityParams = {
    pickup_postcode: pickupPostcode,
    delivery_postcode: deliveryPostcode,
    cod: String(orderData.paymentMethod || '').toLowerCase() === 'cod' ? 1 : 0,
    weight: toPositiveNumber(orderData.weight, 0.5),
    length: toPositiveNumber(orderData.length ?? orderData.dimensions?.length, 10),
    breadth: toPositiveNumber(orderData.breadth ?? orderData.dimensions?.breadth, 10),
    height: toPositiveNumber(orderData.height ?? orderData.dimensions?.height, 10),
    declared_value: Math.round(toPositiveNumber(orderData.totalAmount, 1)),
  };

  try {
    const { data } = await request({
      method: 'get',
      url: '/courier/serviceability/',
      params: serviceabilityParams,
      timeout: SERVICEABILITY_TIMEOUT_MS,
    });

    const selectedCourier = pickCourierOption(data?.data?.available_courier_companies);
    if (!selectedCourier?.courier_company_id) {
      return null;
    }

    return {
      shipment_id: shipmentId,
      courier_id: selectedCourier.courier_company_id,
      courier_name: selectedCourier.courier_name,
    };
  } catch (error) {
    logger.warn('[ShiprocketService] Unable to preselect courier via serviceability', error.message);
    return null;
  }
};

export const createShipment = async (orderData) => {
  const payload = createOrderPayload(orderData);

  logger.info('[ShiprocketService] Shipment payload prepared', {
    order_id: String(payload.order_id),
    pickup_location: String(payload.pickup_location || ''),
    billing_city: payload.billing_city || null,
    billing_state: payload.billing_state || null,
    billing_pincode: String(payload.billing_pincode || ''),
    phone_last4: payload.billing_phone ? String(payload.billing_phone).slice(-4) : null,
    weight: payload.weight,
    dimensions: { length: payload.length, breadth: payload.breadth, height: payload.height },
    items_count: Array.isArray(payload.order_items) ? payload.order_items.length : 0,
  });

  logger.info(`[ShiprocketService] Creating Shiprocket order for ${payload.order_id}`);
  const { data: createOrderResponse } = await request({
    method: 'post',
    url: '/orders/create/adhoc',
    data: payload,
  });

  const shipmentId = createOrderResponse?.shipment_id;
  const shiprocketOrderId = createOrderResponse?.order_id;

  if (!shipmentId) {
    const error = new Error(
      createOrderResponse?.message ||
        createOrderResponse?.error ||
        'Shiprocket did not return a shipment_id for the created order'
    );
    error.statusCode = 502;
    error.details = createOrderResponse;
    throw error;
  }

  logger.info('[ShiprocketService] Shipment creation success', {
    order_id: String(payload.order_id),
    shipment_id: String(shipmentId),
    shiprocket_order_id: shiprocketOrderId ? String(shiprocketOrderId) : null,
    pickup_location: String(payload.pickup_location || ''),
  });

  const courierRequest = (await getCourierForShipment({ shipmentId, orderData })) || {
    shipment_id: shipmentId,
  };

  if (courierRequest?.courier_id) {
    logger.info('[ShiprocketService] Courier preselected', {
      shipment_id: String(shipmentId),
      courier_id: String(courierRequest.courier_id),
      courier_name: courierRequest.courier_name || null,
    });
  } else {
    logger.info('[ShiprocketService] Courier not preselected (Shiprocket will auto-assign)', {
      shipment_id: String(shipmentId),
    });
  }

  logger.info(
    `[ShiprocketService] Assigning AWB for shipment ${shipmentId}${courierRequest.courier_id ? ` using courier ${courierRequest.courier_id}` : ''}`
  );

  const { data: awbResponse } = await request({
    method: 'post',
    url: '/courier/assign/awb',
    data: courierRequest,
  });

  const awbData = awbResponse?.response?.data || awbResponse?.data || {};
  const awb = awbData.awb_code || awbData.awb || null;

  if (!awb) {
    const error = new Error(
      awbResponse?.message ||
        awbData?.awb_assign_error ||
        awbResponse?.response?.message ||
        'Shiprocket did not return an AWB after courier assignment'
    );
    error.statusCode = 502;
    error.details = awbResponse;
    throw error;
  }

  logger.info('[ShiprocketService] AWB generation success', {
    shipment_id: String(shipmentId),
    awb: String(awb),
    courier: awbData.courier_name || courierRequest.courier_name || null,
  });

  return {
    awb,
    shipment_id: String(shipmentId),
    order_id: shiprocketOrderId ? String(shiprocketOrderId) : null,
    courier: awbData.courier_name || courierRequest.courier_name || 'Shiprocket',
    status: 'AWB_ASSIGNED',
    label_url: null,
  };
};

export const trackShipment = async (awb) => {
  logger.info(`[ShiprocketService] Tracking shipment for AWB ${awb}`);

  const { data } = await request({
    method: 'get',
    url: `/courier/track/awb/${encodeURIComponent(awb)}`,
    params: { awb },
  });

  const trackingData = data?.tracking_data || {};
  const latestEvent = trackingData?.shipment_track?.[0] || {};

  const normalized = {
    awb,
    status: latestEvent.current_status || trackingData?.track_status || 'UNKNOWN',
    current_status: latestEvent.current_status || trackingData?.track_status || 'UNKNOWN',
    courier: latestEvent.courier_name || trackingData?.shipment_track?.[0]?.courier_name || null,
    delivered_date: latestEvent.delivered_date || null,
    estimated_delivery_date: latestEvent.estimated_delivery_date || null,
    shipment_status: trackingData?.shipment_status || null,
    shipment_track: trackingData?.shipment_track || [],
    shipment_track_activities: trackingData?.shipment_track_activities || [],
    raw: trackingData,
  };

  logger.info('[ShiprocketService] Tracking response', {
    awb: String(awb),
    current_status: normalized.current_status,
    courier: normalized.courier,
  });

  return normalized;
};

export const createReturnShipment = async (orderData) => {
  // Create a return/reverse shipment
  const payload = {
    order_id: orderData.order_id || `RETURN-${Date.now()}`,
    order_date: new Date().toISOString().split('T')[0],
    is_return: 1,
    pickup_location: 'Primary',
    channel_id: process.env.SHIPROCKET_CHANNEL_ID || '119921',
    company_name: 'Little Threads',
    billing_customer_name: 'Little Threads',
    billing_last_name: 'Returns',
    billing_address: 'Warehouse Address',
    billing_city: 'INDORE',
    billing_pincode: '452010',
    billing_state: 'MP',
    billing_country: 'India',
    billing_email: 'support@littlethreadsfashion.com',
    billing_phone: '7071824784',
    // Shipping details (origin of return = customer address)
    shipping_customer_name: orderData.shipping_customer_name || 'Customer',
    shipping_last_name: 'Return',
    shipping_address: orderData.shipping_address || 'Address',
    shipping_city: orderData.shipping_city || 'City',
    shipping_pincode: orderData.shipping_pincode || '452010',
    shipping_state: orderData.shipping_state || 'State',
    shipping_country: orderData.shipping_country || 'India',
    shipping_email: orderData.shipping_email || 'customer@example.com',
    shipping_phone: orderData.shipping_phone || '1234567890',
    order_items: orderData.order_items || [],
    payment_method: 'PREPAID',
    sub_total: orderData.sub_total || 0,
    length: orderData.length || 5,
    breadth: orderData.breadth || 5,
    height: orderData.height || 5,
    weight: orderData.weight || 0.5,
  };

  logger.info(`[ShiprocketService] Creating return shipment for ${payload.order_id}`);
  const { data: createOrderResponse } = await request({
    method: 'post',
    url: '/orders/create/adhoc',
    data: payload,
  });

  const shipmentId = createOrderResponse?.shipment_id;

  if (!shipmentId) {
    const error = new Error(
      createOrderResponse?.message ||
        createOrderResponse?.error ||
        'Shiprocket did not return a shipment_id for return shipment'
    );
    error.statusCode = 502;
    error.details = createOrderResponse;
    throw error;
  }

  logger.info(`[ShiprocketService] Return shipment created: ${shipmentId}`);

  return {
    shipment_id: String(shipmentId),
    order_id: createOrderResponse?.order_id || null,
    status: 'RETURN_CREATED',
  };
};

export const cancelShipment = async (shipmentId) => {
  logger.info(`[ShiprocketService] Cancelling shipment ${shipmentId}`);

  let shiprocketOrderId = null;

  try {
    const { data } = await request({
      method: 'get',
      url: `/courier/track/shipment/${encodeURIComponent(shipmentId)}`,
    });

    const track = data?.tracking_data?.shipment_track?.[0] || {};
    shiprocketOrderId = track?.order_id ? Number(track.order_id) : null;
  } catch (error) {
    logger.warn(
      `[ShiprocketService] Unable to resolve Shiprocket order_id for shipment ${shipmentId}: ${error.message}`
    );
  }

  if (!Number.isFinite(shiprocketOrderId) || !shiprocketOrderId) {
    const err = new Error('Unable to cancel shipment: Shiprocket order_id could not be resolved');
    err.statusCode = 502;
    throw err;
  }

  await request({
    method: 'post',
    url: '/orders/cancel',
    data: { ids: [shiprocketOrderId] },
  });

  return {
    shipment_id: String(shipmentId),
    order_id: shiprocketOrderId ? String(shiprocketOrderId) : null,
    status: 'CANCELLED',
  };
};

export const generateLabel = async (shipmentId) => {
  logger.info(`[ShiprocketService] Generating label for shipment ${shipmentId}`);

  const { data } = await request({
    method: 'post',
    url: '/courier/generate/label',
    data: { shipment_id: [Number(shipmentId)] },
  });

  return {
    shipment_id: String(shipmentId),
    label_url: getLabelUrlFromResponse(data, shipmentId),
    raw: data,
  };
};

export const schedulePickup = async (shipmentId) => {
  logger.info(`[ShiprocketService] Scheduling pickup for shipment ${shipmentId}`);

  const { data } = await request({
    method: 'post',
    url: '/courier/generate/pickup',
    data: { shipment_id: [Number(shipmentId)] },
  });

  return {
    shipment_id: String(shipmentId),
    pickup_id:
      data?.pickup_id ||
      data?.response?.pickup_id ||
      data?.data?.pickup_id ||
      null,
    status: 'PICKUP_SCHEDULED',
    raw: data,
  };
};

export const listChannels = async () => {
  logger.info('[ShiprocketService] Fetching channels');

  const { data } = await request({
    method: 'get',
    url: '/channels',
  });

  const rows =
    (Array.isArray(data) && data) ||
    (Array.isArray(data?.data) && data.data) ||
    (Array.isArray(data?.data?.data) && data.data.data) ||
    [];

  const channels = rows
    .map((row) => ({
      id: row?.id ?? row?.channel_id ?? row?.channelId ?? null,
      name: row?.name ?? row?.channel_name ?? row?.channelName ?? null,
      type: row?.channel_type ?? row?.type ?? row?.channelType ?? null,
      raw: row,
    }))
    .filter((ch) => ch.id !== null);

  logger.info('[ShiprocketService] Channels fetched', { count: channels.length });

  return {
    channels,
    raw: data,
  };
};
