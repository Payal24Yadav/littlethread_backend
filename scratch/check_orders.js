import { PrismaClient } from '@prisma/client';
const prisma = new PrismaClient();

async function main() {
  const latestOrder = await prisma.order.findFirst({
    orderBy: { createdAt: 'desc' },
    include: {
      items: true
    }
  });

  console.log('Latest Order:', JSON.stringify(latestOrder, null, 2));
}

main()
  .catch(e => console.error(e))
  .finally(async () => await prisma.$disconnect());
