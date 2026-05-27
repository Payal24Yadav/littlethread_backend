import prisma from './src/utils/prisma.js';
import { logger } from './src/utils/logger.js';

// Re-implementing reduceInventory for testing with more logs
const reduceInventory = async (orderId) => {
  try {
    const items = await prisma.orderItem.findMany({
      where: { orderId },
      include: { product: true }
    });

    console.log(`Diagnostic: Found ${items.length} items for order ${orderId}`);

    for (const item of items) {
      console.log(`\nProcessing Item: ProductID=${item.productId}, VariantTitle="${item.variantTitle}"`);
      
      if (item.variantTitle) {
        const normalizedTitle = item.variantTitle.trim();
        console.log(`Searching for variant with title (insensitive): "${normalizedTitle}"`);
        
        const variant = await prisma.productVariant.findFirst({
          where: {
            productId: item.productId,
            title: {
              equals: normalizedTitle,
                
            }
          }
        });

        if (variant) {
          console.log(`MATCH FOUND: VariantID=${variant.id}, CurrentStock=${variant.stock}`);
          const updated = await prisma.productVariant.update({
            where: { id: variant.id },
            data: { stock: { decrement: item.quantity } }
          });
          console.log(`SUCCESS: Stock updated to ${updated.stock}`);
        } else {
          console.log(`NO MATCH FOUND for variant title. Trying partial match...`);
          // Try to find any variant that contains the title parts
          const variants = await prisma.productVariant.findMany({
            where: { productId: item.productId }
          });
          console.log(`Available variants for this product:`, variants.map(v => v.title));
          
          const fallbackMatch = variants.find(v => 
            v.title.toLowerCase().replace(/\s+/g, '') === normalizedTitle.toLowerCase().replace(/\s+/g, '')
          );
          
          if (fallbackMatch) {
            console.log(`FALLBACK MATCH FOUND: VariantID=${fallbackMatch.id}`);
            const updated = await prisma.productVariant.update({
              where: { id: fallbackMatch.id },
              data: { stock: { decrement: item.quantity } }
            });
            console.log(`SUCCESS: Stock updated (fallback) to ${updated.stock}`);
          } else {
            console.log(`STILL NO MATCH. Falling back to product stock.`);
            await prisma.product.update({
              where: { id: item.productId },
              data: { stock: { decrement: item.quantity } }
            });
            console.log(`SUCCESS: Global product stock decremented.`);
          }
        }
      } else {
        console.log(`No variantTitle, decrementing product stock.`);
        await prisma.product.update({
          where: { id: item.productId },
          data: { stock: { decrement: item.quantity } }
        });
      }
    }
  } catch (error) {
    console.error('Error in diagnostic reduceInventory:', error);
  }
};

async function testSpecificOrder() {
  const orderId = 'c8117875-6352-47d2-9bf3-9611128fadb4';
  console.log(`Testing with specific order: ${orderId}`);
  await reduceInventory(orderId);
  await prisma.$disconnect();
}

testSpecificOrder();
