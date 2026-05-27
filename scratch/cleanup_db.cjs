const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

async function main() {
  console.log('Attempting to drop conflicting profiles table and constraints...');
  try {
    // Drop the constraint first if it exists
    await prisma.$executeRawUnsafe(`ALTER TABLE IF EXISTS "public"."profiles" DROP CONSTRAINT IF EXISTS "profiles_id_fkey" CASCADE;`);
    console.log('Dropped constraint profiles_id_fkey if it existed.');
    
    // Drop the table as it's not in our new schema and causes issues
    await prisma.$executeRawUnsafe(`DROP TABLE IF EXISTS "public"."profiles" CASCADE;`);
    console.log('Dropped table public.profiles if it existed.');
    
    console.log('Cleanup complete. You can now run npx prisma db push.');
  } catch (error) {
    console.error('Error during cleanup:', error);
  } finally {
    await prisma.$disconnect();
  }
}

main();
