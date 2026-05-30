import dotenv from 'dotenv';
dotenv.config();

import express from 'express';
import cors from 'cors';
import cookieParser from 'cookie-parser';
import compression from 'compression';
import helmet from 'helmet';
import { rateLimit } from 'express-rate-limit';
import path from 'path';
import fs from 'fs';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// Ensure persistent uploads directory structure
const uploadDirs = [
  'uploads',
  'uploads/products',
  'uploads/collections',
  'uploads/categories',
  'uploads/users',
  'uploads/invoices'
];

uploadDirs.forEach(dir => {
  const fullPath = path.join(__dirname, '..', dir);
  if (!fs.existsSync(fullPath)) {
    fs.mkdirSync(fullPath, { recursive: true });
    console.log(`Created directory: ${dir}`);
  }
});

import productRoutes from './routes/productRoutes.js';
import collectionRoutes from './routes/collectionRoutes.js';
import categoryRoutes from './routes/categoryRoutes.js';
import uploadRoutes from './routes/uploadRoutes.js';
import reviewUploadRoutes from './routes/reviewUploadRoutes.js';
import reviewRoutes from './routes/reviewRoutes.js';
import authRoutes from './routes/authRoutes.js';
import saleRoutes from './routes/saleRoutes.js';
import bannerRoutes from './routes/bannerRoutes.js';
import contactRoutes from './routes/contactRoutes.js';
import paymentRoutes from './routes/paymentRoutes.js';
import orderRoutes from './routes/orderRoutes.js';
import settingsRoutes from './routes/settingsRoutes.js';
import shippingRoutes from './routes/shippingRoutes.js';
import addressRoutes from './routes/addressRoutes.js';
import couponRoutes from './routes/couponRoutes.js';
import shiprocketRoutes from './routes/shiprocketRoutes.js';
import publicShippingRoutes from './routes/publicShippingRoutes.js';
import { startShiprocketWebhookRetryWorker } from './workers/shiprocketWebhookRetryWorker.js';
import { requireAdmin } from './middleware/requireAdmin.js';
import { getCustomerOrders, getOrderById } from './controllers/orderController.js';
import { getSettings } from './controllers/settingsController.js';
import { logger } from './utils/logger.js';

// Environment variable validation
const requiredEnvVars = ['DATABASE_URL', 'JWT_SECRET', 'RAZORPAY_KEY_ID', 'RAZORPAY_KEY_SECRET'];
for (const envVar of requiredEnvVars) {
  if (!process.env[envVar]) {
    console.error(`ERROR: Missing required environment variable: ${envVar}`);
    process.exit(1);
  }
}

const app = express();
const PORT = process.env.PORT || 3000;

const trustProxy = process.env.TRUST_PROXY ?? (process.env.NODE_ENV === 'production' ? '1' : 'loopback');
app.set('trust proxy', trustProxy);

app.use(compression());
app.use(cookieParser());
app.use(express.json({ limit: '10mb' }));

// Robust CORS configuration for production with credentials
app.use(helmet({
  crossOriginResourcePolicy: { policy: "cross-origin" } // Allow images to be loaded cross-origin
}));

const rateLimitHandler = (req, res) => {
  const retryAfterSeconds = Math.ceil((req.rateLimit?.resetTime?.getTime?.() - Date.now()) / 1000) || 60;

  logger.warn('rate_limit.exceeded', {
    ip: req.ip,
    method: req.method,
    path: req.originalUrl,
    limit: req.rateLimit?.limit,
    remaining: req.rateLimit?.remaining,
    retryAfterSeconds,
    userAgent: req.get('user-agent') || null,
  });

  res.setHeader('Retry-After', String(Math.max(retryAfterSeconds, 1)));
  return res.status(429).json({
    success: false,
    message: 'Too many requests. Please wait a moment and try again.',
    retryAfterSeconds: Math.max(retryAfterSeconds, 1),
  });
};

const isSafePublicRead = (req) => {
  if (req.method === 'OPTIONS') return true;
  if (req.method !== 'GET') return false;
  const requestPath = req.originalUrl.split('?')[0];

  return [
    /^\/api\/categories\/?$/,
    /^\/api\/categories\/[^/]+\/?$/,
    /^\/api\/products\/?$/,
    /^\/api\/products\/best-sellers\/?$/,
    /^\/api\/products\/handle\/[^/]+\/?$/,
    /^\/api\/collections\/?$/,
    /^\/api\/collections\/[^/]+\/?$/,
    /^\/api\/banners\/?$/,
    /^\/api\/settings\/?$/,
    /^\/api\/reviews\/?/,
    /^\/api\/public\/shipping\/?/,
  ].some((pattern) => pattern.test(requestPath));
};

const commonLimiterOptions = {
  standardHeaders: 'draft-8',
  legacyHeaders: false,
  handler: rateLimitHandler,
  skip: (req) => req.method === 'OPTIONS',
};

const apiLimiter = rateLimit({
  ...commonLimiterOptions,
  windowMs: 15 * 60 * 1000,
  max: process.env.NODE_ENV === 'development' ? 2000 : 600,
  skip: (req) => commonLimiterOptions.skip(req) || isSafePublicRead(req),
});

const publicReadLimiter = rateLimit({
  ...commonLimiterOptions,
  windowMs: 5 * 60 * 1000,
  max: process.env.NODE_ENV === 'development' ? 3000 : 1200,
  skip: (req) => commonLimiterOptions.skip(req) || !isSafePublicRead(req),
});

const authLimiter = rateLimit({
  ...commonLimiterOptions,
  windowMs: 15 * 60 * 1000,
  max: process.env.NODE_ENV === 'development' ? 300 : 80,
});

app.use(cors({
  origin: [
    'https://www.littlethreadsfashion.com',
    'https://admin.littlethreadsfashion.com'
  ],
  methods: ['GET', 'POST', 'PUT', 'PATCH', 'DELETE', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization', 'X-Requested-With', 'X-API-Key'],
  credentials: true,
  maxAge: 86400 // Cache preflight for 24 hours
}));

// Apply rate limiting after CORS so error responses still include CORS headers.
// Public catalog reads get a separate, generous bucket so normal browsing does not block auth/order APIs.
app.use('/api/', publicReadLimiter);
app.use('/api/', apiLimiter);

// Serve uploads with cache headers
app.use('/uploads', express.static(path.join(__dirname, '../uploads'), {
  maxAge: '7d',
  etag: true,
  lastModified: true,
  setHeaders: (res, path) => {
    res.setHeader('Cache-Control', 'public, max-age=604800, immutable');
  }
}));

app.use('/api/products', productRoutes);
app.use('/api/collections', collectionRoutes);
app.use('/api/categories', categoryRoutes);
app.use('/api/upload', uploadRoutes);
app.use('/api/reviews', reviewUploadRoutes);
app.use('/api/reviews', reviewRoutes);
app.use('/api/auth', authLimiter, authRoutes);
app.use('/api/sales', saleRoutes);
app.use('/api/banners', bannerRoutes);
app.use('/api/contact', contactRoutes);
app.use('/api/payments', paymentRoutes);
app.use('/api/address', addressRoutes);
app.use('/api/orders', orderRoutes);
app.use('/api/settings', settingsRoutes);
app.use('/api/shipping', shippingRoutes);
app.use('/api/coupons', couponRoutes);
app.use('/api/webhook', shiprocketRoutes);
app.use('/api/public/shipping', publicShippingRoutes);



app.get('/health', (req, res) => {
  res.status(200).json({ status: 'healthy', timestamp: new Date() });
});

app.get('/', (req, res) => {
  res.send('Ecommerce API is running...');
});

const server = app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});

// Optional background worker to replay failed webhooks from DB.
startShiprocketWebhookRetryWorker({
  intervalMs: Number(process.env.SHIPROCKET_RETRY_WORKER_INTERVAL_MS || 60_000),
  batchSize: Number(process.env.SHIPROCKET_RETRY_WORKER_BATCH_SIZE || 10),
  maxAttempts: Number(process.env.SHIPROCKET_RETRY_WORKER_MAX_ATTEMPTS || 6),
});

// Graceful shutdown handling for zero-downtime deployments
process.on('SIGTERM', () => {
  console.log('SIGTERM signal received: closing HTTP server');
  server.close(() => {
    console.log('HTTP server closed');
    process.exit(0);
  });
});

process.on('SIGINT', () => {
  console.log('SIGINT signal received: closing HTTP server');
  server.close(() => {
    console.log('HTTP server closed');
    process.exit(0);
  });
});
