import { PrismaClient } from '@prisma/client';
const prisma = new PrismaClient();

async function main() {
  const adminEmail = 'swatigunjan1@gmail.com';
  const adminPassword = 'admin123';

  console.log(`Checking for admin: ${adminEmail}`);

  const admin = await prisma.admin.upsert({
    where: { email: adminEmail },
    update: {
      password: adminPassword,
      is2FAEnabled: true
    },
    create: {
      email: adminEmail,
      password: adminPassword,
      is2FAEnabled: true
    }
  });

  console.log('Admin user created/updated successfully:', admin.email);

  // Ensure default settings exist
  await prisma.globalSetting.upsert({
    where: { id: 'default' },
    update: {},
    create: {
      id: 'default',
      codEnabled: false
    }
  });
  console.log('Default settings ensured.');

  // --- SEED SAMPLE DATA ---
  console.log('Seeding sample products...');

  console.log('Sample products seeded successfully.');
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
