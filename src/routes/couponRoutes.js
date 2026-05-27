import express from 'express';
import { requireAdmin } from '../middleware/requireAdmin.js';
import {
  createCoupon,
  deleteCoupon,
  getCoupons,
  updateCoupon,
  validateCoupon,
  getActiveCoupons
} from '../controllers/couponController.js';

const router = express.Router();

router.post('/validate', validateCoupon);
router.get('/active', getActiveCoupons);
router.get('/', requireAdmin, getCoupons);
router.post('/', requireAdmin, createCoupon);
router.put('/:id', requireAdmin, updateCoupon);
router.delete('/:id', requireAdmin, deleteCoupon);

export default router;
