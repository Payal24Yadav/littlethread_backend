import dotenv from 'dotenv';
dotenv.config();

import { getToken } from '../src/services/shiprocketService.js';

const mask = (value) => {
  const str = String(value || '');
  if (str.length <= 8) return '***';
  return `${str.slice(0, 4)}…${str.slice(-4)}`;
};

const run = async () => {
  const pickup = String(process.env.SHIPROCKET_PICKUP_LOCATION || '').trim();
  const base = String(process.env.SHIPROCKET_BASE_URL || 'https://apiv2.shiprocket.in').trim();

  console.log('[Shiprocket Verify] base_url:', base);
  console.log('[Shiprocket Verify] pickup_location:', pickup || '(missing)');
  console.log('[Shiprocket Verify] using_static_token:', Boolean(process.env.SHIPROCKET_TOKEN));
  console.log('[Shiprocket Verify] email_set:', Boolean(process.env.SHIPROCKET_EMAIL));

  const token = await getToken();
  console.log('[Shiprocket Verify] auth: OK');
  console.log('[Shiprocket Verify] token:', mask(token));
};

run().catch((err) => {
  console.error('[Shiprocket Verify] auth: FAILED');
  console.error(err?.message || err);
  if (err?.statusCode) console.error('[Shiprocket Verify] statusCode:', err.statusCode);
  if (err?.details) {
    const safe = typeof err.details === 'object'
      ? {
          message: err.details?.message || null,
          error: err.details?.error || null,
          errors: err.details?.errors || null,
        }
      : String(err.details);
    console.error('[Shiprocket Verify] details:', safe);
  }
  process.exit(1);
});
