import prisma from '../src/utils/prisma.js';

(async () => {
  try {
    const updated = await prisma.globalSetting.upsert({
      where: { id: 'default' },
      update: { codEnabled: true, codMaxAmount: 5000, codCharges: 50 },
      create: { id: 'default', codEnabled: true, codMaxAmount: 5000, codCharges: 50 }
    });
    console.log(JSON.stringify(updated, null, 2));
  } catch (err) {
    console.error('ERROR', err.message);
    process.exit(1);
  } finally {
    process.exit(0);
  }
})();
