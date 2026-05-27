import prisma from '../utils/prisma.js';

const makeKey = (item) => {
  const productId = String(item.productId || '').trim();
  const quantity = Number(item.quantity || 0);
  const price = Number(item.price || 0);
  return `${productId}|${quantity}|${price}`;
};

const inferSource = (order) => {
  if (String(order.paymentMethod || '').toLowerCase() === 'razorpay') {
    return 'Website';
  }

  return 'DCR';
};

async function backfillSales() {
  console.log('Starting missing-sales backfill...');

  try {
    const orders = await prisma.order.findMany({
      include: {
        items: true,
        sales: true,
        customer: { select: { name: true, email: true, mobile: true } },
      },
      orderBy: { createdAt: 'asc' },
    });

    console.log(`Found ${orders.length} orders to inspect.`);

    let createdCount = 0;
    let skippedCount = 0;

    for (const order of orders) {
      const existingSaleKeys = new Set(order.sales.map(makeKey));
      const address = order.shippingAddress || {};
      const customerName = order.customer?.name || address.fullName || [address.firstName, address.lastName].filter(Boolean).join(' ').trim() || null;
      const customerEmail = order.customer?.email || address.email || null;
      const customerPhone = order.customer?.mobile || address.phone || null;
      const paymentMode = order.paymentMethod || (order.razorpayPaymentId ? 'Razorpay' : 'MANUAL');
      const source = inferSource(order);

      for (const item of order.items) {
        const key = makeKey(item);
        if (existingSaleKeys.has(key)) {
          skippedCount += 1;
          continue;
        }

        await prisma.sale.create({
          data: {
            productId: item.productId,
            quantity: item.quantity,
            price: item.price * item.quantity,
            source,
            orderId: order.id,
            customerName,
            customerEmail,
            customerPhone,
            paymentMode,
            paymentId: order.razorpayPaymentId || null,
            variantTitle: item.variantTitle || null,
          },
        });

        createdCount += 1;
        existingSaleKeys.add(key);
        console.log(`Created missing sale for order ${order.id} item ${item.id}`);
      }
    }

    console.log(`Backfill completed. Created ${createdCount} sales, skipped ${skippedCount} matched items.`);
  } catch (error) {
    console.error('Error during backfill:', error);
  } finally {
    await prisma.$disconnect();
  }
}

backfillSales();
