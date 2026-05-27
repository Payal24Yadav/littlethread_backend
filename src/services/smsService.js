import axios from 'axios';
import { logger } from '../utils/logger.js';

const FAST2SMS_BULK_V2_URL = 'https://www.fast2sms.com/dev/bulkV2';
const REQUEST_TIMEOUT_MS = 20_000;

// Normalizes an Indian mobile number:
// - strips non-digits
// - supports optional country code `91`
// - validates it as a 10-digit number starting with 6-9
export const normalizeMobile = (mobile) => {
  const digits = String(mobile || '').replace(/\D/g, '');

  if (!digits) return null;

  // Handle +91XXXXXXXXXX (12 digits starting with 91)
  const withoutCountryCode = digits.length === 12 && digits.startsWith('91') ? digits.slice(2) : digits;

  // If someone provides extra digits, keep the last 10.
  const maybeTenDigits = withoutCountryCode.length > 10 ? withoutCountryCode.slice(-10) : withoutCountryCode;

  if (!/^[6-9]\d{9}$/.test(maybeTenDigits)) return null;

  return maybeTenDigits;
};

export const sendSMS = async (mobile, message) => {
  const apiKey = process.env.FAST2SMS_API_KEY;
  console.log('API KEY:', process.env.FAST2SMS_API_KEY);
  const normalizedMobile = normalizeMobile(mobile);
  const normalizedMessage = String(message || '').trim();

  if (!apiKey) {
    logger.error('[SMSService] Missing FAST2SMS_API_KEY env var');
    return false;
  }

  if (!normalizedMobile) {
    logger.warn('[SMSService] Invalid mobile number provided:', mobile);
    return false;
  }

  if (!normalizedMessage) {
    logger.warn('[SMSService] Empty SMS message provided');
    return false;
  }

  try {
    const { data } = await axios.get(FAST2SMS_BULK_V2_URL, {
      params: {
        authorization: apiKey,
        route: 'q',
        message: normalizedMessage,
        numbers: normalizedMobile,
        language: 'english',
      },
      timeout: REQUEST_TIMEOUT_MS,
    });

    // Fast2SMS response formats vary; we treat an HTTP success as success.
    // If the API returns an explicit "return" flag, log it for debugging.
    if (data?.return === false || data?.return === 'false') {
      logger.warn('[SMSService] Fast2SMS returned failure:', data);
      return false;
    }

    logger.info('[SMSService] SMS sent successfully to', normalizedMobile);
    return true;
  } catch (error) {
    const details = error?.response?.data || error?.message || error;
    logger.error('[SMSService] Fast2SMS send failed:', details);
    return false;
  }
};

