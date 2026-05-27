import express from 'express';
import { 
  login, 
  verifyOtp, 
  sendOtp,
  verifyMobileOtp,
  toggle2FA, 
  register,
  emailLogin,
  customerSignup,
  customerSignupDirect,
  verifyCustomerSignupOtp,
  customerLogin, 
  verifyCustomerLoginOtp,
  customerForgotPassword, 
  verifyCustomerForgotPasswordOtp,
  resetCustomerPassword,
  resetCustomerPasswordDirect,
  googleLogin,
  getAllCustomers,
  getCustomerById,
  getCustomerProfile,
  updateCustomerAddresses,
  updateCustomerProfileDirect,
  requestCustomerProfileUpdateOtp,
  verifyCustomerProfileUpdateOtp,
  getAdminProfile,
  updateCustomerByAdmin,
  logout
} from '../controllers/authController.js';
import { requireAdmin } from '../middleware/requireAdmin.js';

const router = express.Router();

router.post('/login', login);
router.post('/logout', logout);
router.post('/send-otp', sendOtp);
router.post('/verify-otp', (req, res) => {
  // Dispatch: if `mobile` exists, treat this as mobile OTP verification.
  if (req.body?.mobile) {
    return verifyMobileOtp(req, res);
  }
  return verifyOtp(req, res);
});
router.post('/toggle-2fa', toggle2FA);
router.get('/profile', requireAdmin, getAdminProfile);

// Email wrappers (new endpoints)
router.post('/email-login', emailLogin);
router.post('/register', register);

// Customer Routes
router.post('/customer/signup', customerSignup);
router.post('/customer/signup/direct', customerSignupDirect);
router.post('/customer/signup/verify-otp', verifyCustomerSignupOtp);
router.post('/customer/login', customerLogin);
router.post('/customer/login/verify-otp', verifyCustomerLoginOtp);
router.post('/customer/forgot-password', customerForgotPassword);
router.post('/customer/forgot-password/verify-otp', verifyCustomerForgotPasswordOtp);
router.post('/customer/reset-password', resetCustomerPassword);
router.post('/customer/reset-password/direct', resetCustomerPasswordDirect);
router.post('/customer/google-login', googleLogin);
router.get('/customer/:customerId/profile', getCustomerProfile);
router.post('/customer/:customerId/profile/request-update', requestCustomerProfileUpdateOtp);
router.post('/customer/:customerId/profile/verify-update', verifyCustomerProfileUpdateOtp);
router.put('/customer/:customerId/profile/direct', updateCustomerProfileDirect);
router.put('/customer/:customerId/addresses', updateCustomerAddresses);
router.get('/customers', requireAdmin, getAllCustomers);
router.get('/customers/:id', requireAdmin, getCustomerById);
router.put('/customers/:id', requireAdmin, updateCustomerByAdmin);

export default router;
