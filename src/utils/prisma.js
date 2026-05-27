import { PrismaClient } from '@prisma/client';

// Prevent multiple instances of Prisma Client in development (hot reload)
const prisma = global.prisma || new PrismaClient();

if (process.env.NODE_ENV !== 'production') {
  global.prisma = prisma;
}

// Test connection on startup
prisma.$connect()
  .then(() => {
    console.log('Database connected successfully');
  })
  .catch((err) => {
    console.error('Database connection failed:', err.message);
  });

export default prisma;
