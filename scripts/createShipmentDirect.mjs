import * as shippingService from '../src/services/shippingService.js';

(async () => {
  try {
    const res = await shippingService.createShipment({ orderId: '3a9c8343-c5e4-4c88-accb-7d2b0c227d56' });
    console.log('SHIPMENT RESULT:', JSON.stringify(res, null, 2));
  } catch (err) {
    console.error('SHIPMENT ERROR:', err.message || err);
    if (err.details) console.error('DETAILS:', JSON.stringify(err.details));
    process.exit(1);
  } finally {
    process.exit(0);
  }
})();
