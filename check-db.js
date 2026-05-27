import { PrismaClient } from '@prisma/client';
const prisma = new PrismaClient();

async function main() {
  try {
    const adminCount = await prisma.admin.count();
    console.log(`Admin count: ${adminCount}`);
    
    if (adminCount === 0) {
      console.log('No admins found. Creating default admin...');
      await prisma.admin.create({
        data: {
          email: 'admin@example.com',
          is2FAEnabled: false
        }
      });
      console.log('Default admin created: admin@example.com');
    } else {
      const admins = await prisma.admin.findMany();
      console.log('Existing admins:', admins.map(a => a.email));
    }
  } catch (err) {
    console.error('Database connection error:', err);
  } finally {
    await prisma.$disconnect();
  }
}

main();
