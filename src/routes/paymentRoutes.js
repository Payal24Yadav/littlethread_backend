import express from 'express';
import { createRazorpayOrder, verifyPayment, cancelPayment, getPaymentConfig, confirmCODPayment } from '../controllers/paymentController.js';
import { optionalAuth, requireAdmin } from '../middleware/requireAdmin.js';

const router = express.Router();

router.get('/config', getPaymentConfig);
router.post('/create', optionalAuth, createRazorpayOrder);
router.post('/verify', optionalAuth, verifyPayment);
router.post('/cancel', optionalAuth, cancelPayment);
router.post('/confirm-cod', requireAdmin, confirmCODPayment);

export default router;
