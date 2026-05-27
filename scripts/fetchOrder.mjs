import prisma from '../src/utils/prisma.js';

(async () => {
  try {
    const id = process.argv[2];
    if (!id) {
      console.error('Usage: node fetchOrder.mjs <orderId>');
      process.exit(1);
    }
    const order = await prisma.order.findUnique({ where: { id }, include: { items: true } });
    console.log(JSON.stringify(order || null, null, 2));
  } catch (err) {
    console.error('ERROR', err.message);
    process.exit(1);
  } finally {
    process.exit(0);
  }
})();
