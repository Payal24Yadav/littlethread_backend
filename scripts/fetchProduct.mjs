import prisma from '../src/utils/prisma.js';

(async () => {
  try {
    const product = await prisma.product.findFirst({ select: { id: true, name: true } });
    console.log(JSON.stringify(product || null));
  } catch (err) {
    console.error('ERROR', err.message);
    process.exit(1);
  } finally {
    process.exit(0);
  }
})();
