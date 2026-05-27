import { PrismaClient } from '@prisma/client';
const prisma = new PrismaClient();

async function checkCoupons() {
  const coupons = await prisma.coupon.findMany();
  console.log('Current Coupons:', coupons);
  
  if (coupons.length === 0) {
    console.log('No coupons found. Creating test coupons...');
    const c1 = await prisma.coupon.create({
      data: {
        code: 'WELCOME10',
        percentage: 10,
        type: 'PERCENTAGE',
        isActive: true,
        maxUses: 100,
        allowedEmails: []
      }
    });
    const c2 = await prisma.coupon.create({
      data: {
        code: 'LITTLETHREADS20',
        percentage: 20,
        type: 'PERCENTAGE',
        isActive: true,
        maxUses: 50,
        allowedEmails: []
      }
    });
    console.log('Seeded Coupons:', [c1, c2]);
  }
}

checkCoupons()
  .catch(console.error)
  .finally(() => prisma.$disconnect());
