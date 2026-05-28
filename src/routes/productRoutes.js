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
const importUpload = (req, res, next) => {
  upload.single('file')(req, res, (error) => {
    if (!error) return next();

    const message = error.code === 'LIMIT_FILE_SIZE'
      ? 'CSV file is too large. Maximum upload size is 10 MB.'
      : error.message || 'CSV upload failed';

    return res.status(400).json({
      success: false,
      message,
      error: error.message,
    });
  });
};

router.get('/', getAllProducts);
router.get('/best-sellers', getBestSellers);
router.get('/new-arrivals', getNewArrivals);
router.get('/handle/:handle', getProductByHandle);
router.post('/import', requireAdmin, importUpload, importProducts);
router.get('/:id', getProductById);
router.post('/', requireAdmin, createProduct);
router.put('/:id', requireAdmin, updateProduct);
router.patch('/:id', requireAdmin, patchProduct);
router.delete('/:id', requireAdmin, deleteProduct);

export default router;
