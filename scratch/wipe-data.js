import { PrismaClient } from '@prisma/client';
const prisma = new PrismaClient();

async function main() {
  console.log("Starting transactional data wipe...");
  try {
    // Order-related cleanup
    const orderActivityCount = await prisma.orderActivity.deleteMany();
    const orderItemCount = await prisma.orderItem.deleteMany();
    const orderCount = await prisma.order.deleteMany();
    console.log(`- Deleted ${orderCount.count} orders, ${orderItemCount.count} items, and ${orderActivityCount.count} activities.`);

    // Sales and Reviews
    const saleCount = await prisma.sale.deleteMany();
    const reviewCount = await prisma.review.deleteMany();
    console.log(`- Deleted ${saleCount.count} sales and ${reviewCount.count} reviews.`);

    // Products and Variants
    const variantCount = await prisma.productVariant.deleteMany();
    const productCount = await prisma.product.deleteMany();
    console.log(`- Deleted ${productCount.count} products and ${variantCount.count} variants.`);

    // Customers and Messages
    const addressCount = await prisma.address.deleteMany();
    const otpCount = await prisma.mobileOtp.deleteMany();
    const customerCount = await prisma.customer.deleteMany();
    const messageCount = await prisma.contactMessage.deleteMany();
    console.log(`- Deleted ${customerCount.count} customers, ${addressCount.count} addresses, and ${messageCount.count} messages.`);

    console.log("\nSUCCESS: All requested test data has been cleared.");
  } catch (err) {
    console.error("\nFATAL ERROR during data wipe:", err);
    process.exit(1);
  } finally {
    await prisma.$disconnect();
  }
}

main();
