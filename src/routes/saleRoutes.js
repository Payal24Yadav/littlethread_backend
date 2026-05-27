import express from 'express';
const router = express.Router();
import * as saleController from '../controllers/saleController.js';

router.get('/', saleController.getSales);
router.post('/store', saleController.registerStoreSale);
router.put('/:id', saleController.updateSale);
router.delete('/:id', saleController.deleteSale);

export default router;
