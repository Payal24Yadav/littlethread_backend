import express from 'express';
import { 
  getOrders, 
  updateOrderStatus, 
  getOrderById, 
  getCustomerOrders, 
  getMyOrders,
  trackOrder,
  cancelOrder,
  createReturnRequest,
  getReturnRequest,
  getReturnRequests,
  approveReturnRequest,
  rejectReturnRequest,
  createAdminOrder,
  updateOrderDetails,
  deleteOrder,
  getOrderInvoice
} from '../controllers/orderController.js';
import { requireAdmin } from '../middleware/requireAdmin.js';
import { requireAuth } from '../middleware/requireAuth.js';
import { requireCustomerOrAdmin } from '../middleware/requireCustomerOrAdmin.js';

const router = express.Router();

router.get('/', requireAdmin, getOrders);
router.get('/my-orders', requireAuth, getMyOrders);
router.post('/track', trackOrder);
router.get('/customer/:customerId', requireAuth, getCustomerOrders);
router.get('/:id', requireCustomerOrAdmin, getOrderById);
router.get('/:id/invoice', getOrderInvoice);
router.put('/:id', requireAdmin, updateOrderStatus);
router.post('/:id/cancel', requireAdmin, cancelOrder);
router.patch('/:id/details', requireAdmin, updateOrderDetails);
router.delete('/:id', requireAdmin, deleteOrder);
router.post('/admin/create', requireAdmin, createAdminOrder);

// Return request routes
router.post('/:orderId/return', requireAuth, createReturnRequest);
router.get('/:orderId/return', getReturnRequest);
router.post('/:orderId/return/cancel', requireAuth, async (req, res, next) => {
  try {
    const { cancelReturnRequestByCustomer } = await import('../controllers/orderController.js');
    return cancelReturnRequestByCustomer(req, res, next);
  } catch (err) {
    next(err);
  }
});
router.get('/admin/returns/all', requireAdmin, getReturnRequests);
router.put('/admin/returns/:returnId/approve', requireAdmin, approveReturnRequest);
router.put('/admin/returns/:returnId/reject', requireAdmin, rejectReturnRequest);
router.put('/admin/returns/:returnId/refund-complete', requireAdmin, async (req, res, next) => {
  try {
    const { completeRefund } = await import('../controllers/orderController.js');
    return completeRefund(req, res, next);
  } catch (err) {
    next(err);
  }
});

export default router;
