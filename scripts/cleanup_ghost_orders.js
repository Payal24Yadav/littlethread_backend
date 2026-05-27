import { PrismaClient } from '@prisma/client';
const prisma = new PrismaClient();

async function main() {
  console.log('Cleaning up PAYMENT_PENDING and PENDING orders...');
  
  const deleted = await prisma.order.deleteMany({
    where: {
      OR: [
        { status: 'PAYMENT_PENDING' },
        { 
          AND: [
            { status: 'PENDING' },
            { paymentMethod: { not: 'cod' } }
          ]
        }
      ]
    }
  });
  
  console.log(`Deleted ${deleted.count} ghost orders.`);
}

main()
  .catch(e => console.error(e))
  .finally(async () => await prisma.$disconnect());
