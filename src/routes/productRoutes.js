import express from 'express';
import upload from '../middleware/upload.js';
import { requireAdmin } from '../middleware/requireAdmin.js';
import {
  getAllProducts,
  getProductById,
  getProductByHandle,
  createProduct,
  updateProduct,
  patchProduct,
  deleteProduct,
  getBestSellers,
  getNewArrivals,
  importProducts,
} from '../controllers/productController.js';

const router = express.Router();

router.get('/', getAllProducts);
router.get('/best-sellers', getBestSellers);
router.get('/new-arrivals', getNewArrivals);
router.get('/handle/:handle', getProductByHandle);
router.post('/import', requireAdmin, upload.single('file'), importProducts);
router.get('/:id', getProductById);
router.post('/', requireAdmin, createProduct);
router.put('/:id', requireAdmin, updateProduct);
router.patch('/:id', requireAdmin, patchProduct);
router.delete('/:id', requireAdmin, deleteProduct);

export default router;
