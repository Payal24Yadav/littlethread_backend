import prisma from './src/utils/prisma.js';

async function checkVariants() {
  try {
    const variants = await prisma.productVariant.findMany({
      take: 10,
      include: {
        product: {
          select: { name: true }
        }
      }
    });
    console.log('Sample Variants:');
    variants.forEach(v => {
      console.log(`Product: ${v.product.name} | Title: "${v.title}" | ID: ${v.id}`);
    });

    const orderItems = await prisma.orderItem.findMany({
      take: 5,
      orderBy: { id: 'desc' }
    });
    console.log('\nRecent Order Items:');
    orderItems.forEach(item => {
      console.log(`Order ID: ${item.orderId} | Product ID: ${item.productId} | VariantTitle: "${item.variantTitle}"`);
    });
  } catch (err) {
    console.error(err);
  } finally {
    await prisma.$disconnect();
  }
}

checkVariants();
