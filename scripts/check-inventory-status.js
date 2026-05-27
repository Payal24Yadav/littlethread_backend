import prisma from '../src/utils/prisma.js';

async function checkInventoryStatus() {
  console.log('\n=== INVENTORY DIAGNOSTIC REPORT ===\n');

  try {
    // 1. Check recent orders with their inventory changes
    console.log('📋 RECENT ORDERS AND INVENTORY:');
    const recentOrders = await prisma.order.findMany({
      take: 5,
      orderBy: { createdAt: 'desc' },
      include: {
        items: {
          include: {
            product: {
              select: { name: true, stock: true, id: true }
            }
          }
        }
      }
    });

    for (const order of recentOrders) {
      console.log(`\nOrder: ${order.id} (${order.status})`);
      console.log(`Created: ${order.createdAt}`);
      console.log(`Payment Method: ${order.paymentMethod}`);
      
      for (const item of order.items) {
        console.log(`  - Product: ${item.product.name}`);
        console.log(`    Current Stock: ${item.product.stock}`);
        console.log(`    Ordered Qty: ${item.quantity}`);
        console.log(`    Variant: ${item.variantTitle || 'None'}`);
      }
    }

    // 2. Check products with negative stock (sign of over-selling)
    console.log('\n\n⚠️ PRODUCTS WITH NEGATIVE OR ZERO STOCK:');
    const lowStockProducts = await prisma.product.findMany({
      where: {
        stock: { lte: 0 }
      },
      include: {
        variants: true
      }
    });

    if (lowStockProducts.length === 0) {
      console.log('✅ No products with negative stock');
    } else {
      for (const product of lowStockProducts) {
        console.log(`\n${product.name}`);
        console.log(`  Product Stock: ${product.stock}`);
        if (product.variants.length > 0) {
          for (const variant of product.variants) {
            console.log(`    Variant "${variant.title}": ${variant.stock}`);
          }
        }
      }
    }

    // 3. Check for variant title mismatches
    console.log('\n\n🔍 CHECKING VARIANT TITLE CONSISTENCY:');
    const allOrderItems = await prisma.orderItem.findMany({
      where: { variantTitle: { not: null } },
      include: {
        product: {
          include: { variants: true }
        }
      },
      take: 10
    });

    const mismatches = [];
    for (const item of allOrderItems) {
      if (item.variantTitle) {
        const variant = item.product.variants.find(v => v.title === item.variantTitle);
        if (!variant) {
          mismatches.push({
            orderId: item.orderId,
            productId: item.productId,
            productName: item.product.name,
            requestedVariantTitle: item.variantTitle,
            availableVariants: item.product.variants.map(v => v.title)
          });
        }
      }
    }

    if (mismatches.length === 0) {
      console.log('✅ All variant titles match correctly');
    } else {
      console.log(`⚠️ Found ${mismatches.length} potential mismatches:`);
      for (const mismatch of mismatches) {
        console.log(`\n  Order: ${mismatch.orderId}`);
        console.log(`  Product: ${mismatch.productName}`);
        console.log(`  Requested: "${mismatch.requestedVariantTitle}"`);
        console.log(`  Available: ${mismatch.availableVariants.map(v => `"${v}"`).join(', ')}`);
      }
    }

    // 4. Summary statistics
    console.log('\n\n📊 SUMMARY STATISTICS:');
    const totalProducts = await prisma.product.count();
    const totalVariants = await prisma.productVariant.count();
    const totalOrders = await prisma.order.count();
    const paidOrders = await prisma.order.count({ where: { status: 'PAID' } });
    const codOrders = await prisma.order.count({ where: { status: { in: ['COD_PENDING', 'COD_CONFIRMED'] } } });

    console.log(`Total Products: ${totalProducts}`);
    console.log(`Total Variants: ${totalVariants}`);
    console.log(`Total Orders: ${totalOrders}`);
    console.log(`Paid Orders: ${paidOrders}`);
    console.log(`COD Orders: ${codOrders}`);

    console.log('\n✅ Diagnostic complete\n');

  } catch (error) {
    console.error('❌ Error during diagnostic:', error.message);
    process.exit(1);
  } finally {
    await prisma.$disconnect();
  }
}

checkInventoryStatus();
