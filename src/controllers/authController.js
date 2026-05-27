import prisma from '../utils/prisma.js';
import crypto from 'crypto';
import jwt from 'jsonwebtoken';
import { OAuth2Client } from 'google-auth-library';
import bcrypt from 'bcryptjs';
import { sendMail, TEMPLATES } from '../utils/mailer.js';
import { sendSMS, normalizeMobile } from '../services/smsService.js';

const googleClient = new OAuth2Client(process.env.GOOGLE_CLIENT_ID);
const JWT_SECRET = process.env.JWT_SECRET || 'default-secret';
const CUSTOMER_OTP_TTL_MINUTES = 10;
const MOBILE_OTP_TTL_MINUTES = 2;
const MAX_MOBILE_OTP_ATTEMPTS = 3;

const sanitizeAddresses = (addresses) => {
  if (!Array.isArray(addresses)) return [];

  return addresses.map((addr) => ({
    id: addr.id,
    label: addr.label || 'Saved Address',
    firstName: addr.name?.split(' ')[0] || '',
    lastName: addr.name?.split(' ').slice(1).join(' ') || '',
    name: addr.name,
    address: addr.addressLine1, // For frontend compatibility if needed
    addressLine1: addr.addressLine1,
    addressLine2: addr.addressLine2,
    city: addr.city,
    state: addr.state,
    pinCode: addr.pincode,
    pincode: addr.pincode,
    phone: addr.phone,
  }));
};

const serializeCustomer = (customer) => ({
  id: customer.id,
  name: customer.name,
  email: customer.email,
  mobile: customer.mobile,
  gender: customer.gender || null,
  addresses: sanitizeAddresses(customer.addresses || [])
});

const generateOtp = () => Math.floor(100000 + Math.random() * 900000).toString();
const generateFourDigitOtp = () => Math.floor(1000 + Math.random() * 9000).toString();

const hashOtp = (otp) => crypto.createHash('sha256').update(otp).digest('hex');

const signActionToken = (payload, expiresIn = `${CUSTOMER_OTP_TTL_MINUTES}m`) =>
  jwt.sign(payload, JWT_SECRET, { expiresIn });

const verifyActionToken = (token, expectedPurpose) => {
  const decoded = jwt.verify(token, JWT_SECRET);

  if (decoded.purpose !== expectedPurpose) {
    throw new Error('Invalid token purpose');
  }

  return decoded;
};

const issueCustomerAuthToken = (customer) =>
  jwt.sign(
    { id: customer.id, email: customer.email, role: 'customer' },
    JWT_SECRET,
    { expiresIn: '7d' }
  );


export const login = async (req, res) => {
  let { email, password } = req.body;
  if (email) email = email.trim();
  if (password) password = password.trim();

  // Allow both admin123 and Admin123 for easier entry
  if (password?.toLowerCase() !== 'admin123') {
    return res.status(401).json({ message: 'Invalid credentials' });
  }

  try {
    let admin = await prisma.admin.findUnique({ where: { email } });

    if (!admin) {
      // Create admin on the fly if it doesn't exist.
      admin = await prisma.admin.create({
        data: { email, is2FAEnabled: false }
      });
    }

    // 2FA is disabled for admin logins.
    if (admin.is2FAEnabled) {
      admin = await prisma.admin.update({
        where: { id: admin.id },
        data: { is2FAEnabled: false, otp: null, otpExpires: null }
      });
    }

    // Generate JWT
    const token = jwt.sign(
      { id: admin.id, email: admin.email, role: 'admin' },
      JWT_SECRET,
      { expiresIn: '1d' }
    );

    // Set HTTP-only cookie
    res.cookie('adminToken', token, {
      httpOnly: true,
      secure: process.env.NODE_ENV === 'production',
      sameSite: 'lax',
      maxAge: 24 * 60 * 60 * 1000 // 1 day
    });

    res.json({ 
      success: true, 
      email: admin.email,
      token // Still return token for potential frontend use, but cookie is primary
    });

  } catch (error) {
    console.error('Login error:', error);
    res.status(500).json({ error: error.message });
  }
};

export const logout = async (req, res) => {
  res.clearCookie('adminToken');
  res.clearCookie('token');
  res.json({ success: true, message: 'Logged out successfully' });
};

export const verifyOtp = async (req, res) => {
  const { email, otp } = req.body;

  try {
    const admin = await prisma.admin.findUnique({ where: { email } });

    if (!admin || !admin.otp || admin.otp !== otp || admin.otpExpires < new Date()) {
      return res.status(401).json({ message: 'Invalid or expired OTP' });
    }

    // Clear OTP after successful verification
    await prisma.admin.update({
      where: { id: admin.id },
      data: { otp: null, otpExpires: null }
    });

    // Generate JWT
    const token = jwt.sign(
      { id: admin.id, email: admin.email, role: 'admin' },
      JWT_SECRET,
      { expiresIn: '1d' }
    );

    // Set HTTP-only cookie
    res.cookie('adminToken', token, {
      httpOnly: true,
      secure: process.env.NODE_ENV === 'production',
      sameSite: 'lax',
      maxAge: 24 * 60 * 60 * 1000 // 1 day
    });

    res.json({ 
      success: true, 
      email: admin.email,
      token
    });

  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

export const toggle2FA = async (req, res) => {
  const { email, enabled } = req.body;
  if (!email) return res.status(400).json({ error: 'Email is required' });
  try {
    const admin = await prisma.admin.findUnique({ where: { email } });
    if (!admin) {
      return res.status(404).json({ error: 'Admin user not found' });
    }
    await prisma.admin.update({
      where: { email },
      data: { is2FAEnabled: enabled }
    });
    res.json({ message: `2FA ${enabled ? 'enabled' : 'disabled'}` });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};
export const getAdminProfile = async (req, res) => {
  try {
    const admin = await prisma.admin.findUnique({
      where: { id: req.user.id }
    });

    if (!admin) {
      return res.status(404).json({ message: 'Admin not found' });
    }

    res.json({
      profile: {
        id: admin.id,
        email: admin.email,
        role: 'admin' // Admins in the Admin table are always 'admin'
      }
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// --- Customer Authentication ---

export const customerSignup = async (req, res) => {
  const name = req.body.name?.trim();
  const email = req.body.email?.trim().toLowerCase();
  const password = req.body.password?.trim();
  try {
    if (!name || !email || !password) {
      return res.status(400).json({ message: 'Name, email, and password are required' });
    }

    const existing = await prisma.customer.findUnique({ where: { email } });
    if (existing) return res.status(400).json({ message: 'Email already registered' });

    const hashedPassword = await bcrypt.hash(password, 12);
    const otp = generateOtp();
    const verificationToken = signActionToken({
      purpose: 'customer-signup',
      name,
      email,
      hashedPassword,
      otpHash: hashOtp(otp)
    });

    const emailSent = await sendMail(email, 'Welcome to Little Threads', TEMPLATES.SIGNUP_OTP(otp));
    if (!emailSent) {
      return res.status(500).json({ message: 'Failed to send OTP email' });
    }

    res.status(200).json({
      success: true,
      requiresOtp: true,
      email,
      verificationToken,
      message: 'OTP sent to your email'
    });
  } catch (error) {
    console.error('Signup error:', error);
    res.status(500).json({ message: error.message });
  }
};

export const customerSignupDirect = async (req, res) => {
  const name = req.body.name?.trim();
  const email = req.body.email?.trim().toLowerCase();
  const password = req.body.password?.trim();
  const gender = req.body.gender?.trim();

  try {
    if (!name || !email || !password) {
      return res.status(400).json({ message: 'Name, email, and password are required' });
    }

    const existing = await prisma.customer.findUnique({ where: { email } });
    if (existing) return res.status(400).json({ message: 'Email already registered' });

    const hashedPassword = await bcrypt.hash(password, 12);
    const customer = await prisma.customer.create({
      data: {
        name,
        email,
        password: hashedPassword,
        gender: gender || null,
        provider: 'local'
      },
      include: { addresses: true }
    });

    const token = issueCustomerAuthToken(customer);

    res.cookie('token', token, {
      httpOnly: true,
      secure: process.env.NODE_ENV === 'production',
      sameSite: 'lax',
      maxAge: 7 * 24 * 60 * 60 * 1000
    });

    res.status(201).json({
      success: true,
      customer: serializeCustomer(customer),
      token
    });
  } catch (error) {
    console.error('Direct signup error:', error);
    res.status(500).json({ message: error.message });
  }
};

// Wrapper: POST /api/auth/register
// Keeps the legacy `/api/auth/customer/*` routes intact while providing a simpler entry point.
export const register = async (req, res) => customerSignup(req, res);

export const verifyCustomerSignupOtp = async (req, res) => {
  const { otp, verificationToken } = req.body;

  try {
    if (!otp || !verificationToken) {
      return res.status(400).json({ message: 'OTP and verification token are required' });
    }

    const payload = verifyActionToken(verificationToken, 'customer-signup');
    if (hashOtp(otp.trim()) !== payload.otpHash) {
      return res.status(401).json({ message: 'Invalid or expired OTP' });
    }

    const existing = await prisma.customer.findUnique({ where: { email: payload.email } });
    if (existing) {
      return res.status(400).json({ message: 'Email already registered' });
    }

    const customer = await prisma.customer.create({
      data: {
        name: payload.name,
        email: payload.email,
        password: payload.hashedPassword,
        provider: 'local'
      },
      include: { addresses: true }
    });

    const token = issueCustomerAuthToken(customer);

    res.cookie('token', token, {
      httpOnly: true,
      secure: process.env.NODE_ENV === 'production',
      sameSite: 'lax',
      maxAge: 7 * 24 * 60 * 60 * 1000 // 7 days
    });

    res.status(201).json({
      success: true,
      customer: serializeCustomer(customer),
      token
    });
  } catch (error) {
    const status = error.name === 'TokenExpiredError' || error.name === 'JsonWebTokenError' ? 401 : 500;
    res.status(status).json({ message: status === 401 ? 'Invalid or expired OTP' : error.message });
  }
};

export const customerLogin = async (req, res) => {
  const email = req.body.email?.trim().toLowerCase();
  const password = req.body.password?.trim();
  try {
    if (!email || !password) {
      return res.status(400).json({ message: 'Email and password are required' });
    }

    const customer = await prisma.customer.findUnique({
      where: { email },
      include: { addresses: true }
    });
    if (!customer || !customer.password) {
       return res.status(401).json({ message: 'Invalid email or password' });
    }

    let isPasswordValid = false;
    const looksHashed = customer.password.startsWith('$2');

    if (looksHashed) {
      isPasswordValid = await bcrypt.compare(password, customer.password);
    } else {
      isPasswordValid = customer.password === password;
      if (isPasswordValid) {
        const upgradedPassword = await bcrypt.hash(password, 12);
        await prisma.customer.update({
          where: { id: customer.id },
          data: { password: upgradedPassword }
        });
      }
    }

    if (!isPasswordValid) {
      return res.status(401).json({ message: 'Invalid email or password' });
    }

    const token = issueCustomerAuthToken(customer);

    res.cookie('token', token, {
      httpOnly: true,
      secure: process.env.NODE_ENV === 'production',
      sameSite: 'lax',
      maxAge: 7 * 24 * 60 * 60 * 1000 // 7 days
    });

    res.json({
      success: true,
      customer: serializeCustomer(customer),
      token
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Wrapper: POST /api/auth/email-login
// Keeps the legacy `/api/auth/customer/login` route intact while providing a simpler entry point.
export const emailLogin = async (req, res) => customerLogin(req, res);

export const verifyCustomerLoginOtp = async (req, res) => {
  const { otp, verificationToken } = req.body;

  try {
    if (!otp || !verificationToken) {
      return res.status(400).json({ message: 'OTP and verification token are required' });
    }

    const payload = verifyActionToken(verificationToken, 'customer-login');
    if (hashOtp(otp.trim()) !== payload.otpHash) {
      return res.status(401).json({ message: 'Invalid or expired OTP' });
    }

    const customer = await prisma.customer.findUnique({
      where: { id: payload.customerId },
      include: { addresses: true }
    });

    if (!customer) {
      return res.status(404).json({ message: 'Customer not found' });
    }

    const token = issueCustomerAuthToken(customer);

    res.json({
      success: true,
      customer: serializeCustomer(customer),
      token
    });
  } catch (error) {
    const status = error.name === 'TokenExpiredError' || error.name === 'JsonWebTokenError' ? 401 : 500;
    res.status(status).json({ message: status === 401 ? 'Invalid or expired OTP' : error.message });
  }
};

export const resetCustomerPasswordDirect = async (req, res) => {
  const email = req.body.email?.trim().toLowerCase();
  const password = req.body.password?.trim();
  const confirmPassword = req.body.confirmPassword?.trim();

  try {
    if (!email || !password || !confirmPassword) {
      return res.status(400).json({ message: 'Email, password and confirm password are required' });
    }

    if (password !== confirmPassword) {
      return res.status(400).json({ message: 'Passwords do not match' });
    }

    const customer = await prisma.customer.findUnique({ where: { email } });
    if (!customer) {
      return res.status(404).json({ message: 'Customer not found' });
    }

    const hashedPassword = await bcrypt.hash(password, 12);
    await prisma.customer.update({
      where: { id: customer.id },
      data: { password: hashedPassword }
    });

    res.json({ success: true, message: 'Password reset successfully' });
  } catch (error) {
    console.error('Direct reset password error:', error);
    res.status(500).json({ message: error.message });
  }
};

export const customerForgotPassword = async (req, res) => {
  const email = req.body.email?.trim().toLowerCase();
  try {
    if (!email) {
      return res.status(400).json({ message: 'Email is required' });
    }

    const customer = await prisma.customer.findUnique({ where: { email } });
    if (!customer) return res.status(404).json({ message: 'Customer not found' });

    const otp = generateOtp();
    const verificationToken = signActionToken({
      purpose: 'customer-forgot-password',
      customerId: customer.id,
      email: customer.email,
      otpHash: hashOtp(otp)
    });

    const emailSent = await sendMail(email, 'Password Reset OTP', TEMPLATES.FORGOT_PASSWORD_OTP(otp));
    if (!emailSent) {
      return res.status(500).json({ message: 'Failed to send OTP email' });
    }

    res.json({
      success: true,
      email,
      verificationToken,
      message: 'Password reset OTP sent to email'
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

export const verifyCustomerForgotPasswordOtp = async (req, res) => {
  const { otp, verificationToken } = req.body;

  try {
    if (!otp || !verificationToken) {
      return res.status(400).json({ message: 'OTP and verification token are required' });
    }

    const payload = verifyActionToken(verificationToken, 'customer-forgot-password');
    if (hashOtp(otp.trim()) !== payload.otpHash) {
      return res.status(401).json({ message: 'Invalid or expired OTP' });
    }

    const resetToken = signActionToken({
      purpose: 'customer-forgot-password-verified',
      customerId: payload.customerId,
      email: payload.email
    });

    res.json({
      success: true,
      resetToken,
      message: 'OTP verified successfully'
    });
  } catch (error) {
    const status = error.name === 'TokenExpiredError' || error.name === 'JsonWebTokenError' ? 401 : 500;
    res.status(status).json({ message: status === 401 ? 'Invalid or expired OTP' : error.message });
  }
};

export const resetCustomerPassword = async (req, res) => {
  const { resetToken, password, confirmPassword } = req.body;

  try {
    if (!resetToken || !password || !confirmPassword) {
      return res.status(400).json({ message: 'Reset token, password, and confirm password are required' });
    }

    if (password !== confirmPassword) {
      return res.status(400).json({ message: 'Passwords do not match' });
    }

    const payload = verifyActionToken(resetToken, 'customer-forgot-password-verified');
    const customer = await prisma.customer.findUnique({ where: { id: payload.customerId } });

    if (!customer) {
      return res.status(404).json({ message: 'Customer not found' });
    }

    const hashedPassword = await bcrypt.hash(password.trim(), 12);
    await prisma.customer.update({
      where: { id: customer.id },
      data: {
        password: hashedPassword,
        provider: 'local'
      }
    });

    res.json({
      success: true,
      message: 'Password updated successfully'
    });
  } catch (error) {
    const status = error.name === 'TokenExpiredError' || error.name === 'JsonWebTokenError' ? 401 : 500;
    res.status(status).json({ message: status === 401 ? 'Reset session expired. Please request OTP again.' : error.message });
  }
};

export const googleLogin = async (req, res) => {
  const { credential } = req.body;

  if (!credential) {
    return res.status(400).json({ error: 'Missing Google credential' });
  }
  if (!process.env.GOOGLE_CLIENT_ID) {
    return res.status(500).json({ error: 'Missing GOOGLE_CLIENT_ID env var on server' });
  }

  try {
    const ticket = await googleClient.verifyIdToken({
      idToken: credential,
      audience: process.env.GOOGLE_CLIENT_ID,
    });
    const payload = ticket.getPayload();
    const { email, name } = payload;

    if (!email) {
      return res.status(400).json({ error: 'Google profile has no email' });
    }

    let customer = await prisma.customer.findUnique({ where: { email } });

    if (!customer) {
      customer = await prisma.customer.create({
        data: {
          email,
          name: name || 'Google User',
          provider: 'google'
        },
        include: { addresses: true }
      });
    }
    const token = issueCustomerAuthToken(customer);

    res.cookie('token', token, {
      httpOnly: true,
      secure: process.env.NODE_ENV === 'production',
      sameSite: 'lax',
      maxAge: 7 * 24 * 60 * 60 * 1000 // 7 days
    });

    return res.json({
      success: true,
      customer: serializeCustomer(customer),
      token
    });
  } catch (error) {
    console.error('Google Login Error:', error);
    const message = error?.message || 'Google login failed';
    return res.status(500).json({ error: `Google login failed: ${message}` });
  }
};

export const getCustomerProfile = async (req, res) => {
  try {
    const customer = await prisma.customer.findUnique({
      where: { id: req.params.customerId },
      include: { addresses: true }
    });

    if (!customer) {
      return res.status(404).json({ message: 'Customer not found' });
    }

    return res.json({ success: true, customer: serializeCustomer(customer) });
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
};

export const updateCustomerProfileDirect = async (req, res) => {
  const { customerId } = req.params;
  const { name, gender } = req.body;

  try {
    if (!name) {
      return res.status(400).json({ message: 'Name is required' });
    }

    const customer = await prisma.customer.update({
      where: { id: customerId },
      data: {
        name: name.trim(),
        gender: gender?.trim() || null
      },
      include: { addresses: true }
    });

    return res.json({
      success: true,
      customer: serializeCustomer(customer),
      message: 'Profile updated successfully'
    });
  } catch (error) {
    console.error('Direct profile update error:', error);
    return res.status(500).json({ error: error.message });
  }
};

export const updateCustomerAddresses = async (req, res) => {
  const { customerId } = req.params;
  const { addresses } = req.body;

  try {
    // We use a transaction to ensure atomicity
    const result = await prisma.$transaction(async (tx) => {
      // 1. Delete all existing addresses for this customer
      await tx.address.deleteMany({
        where: { customerId }
      });

      // 2. Create new addresses
      if (Array.isArray(addresses) && addresses.length > 0) {
        const dataToCreate = addresses.map(addr => ({
          customerId,
          name: addr.name || `${addr.firstName || ''} ${addr.lastName || ''}`.trim() || 'Saved Address',
          phone: String(addr.phone || ''),
          addressLine1: addr.address || addr.addressLine1 || '',
          addressLine2: addr.apartment || addr.addressLine2 || '',
          city: addr.city || '',
          state: addr.state || '',
          pincode: String(addr.pinCode || addr.pincode || ''),
        }));

        await tx.address.createMany({
          data: dataToCreate
        });
      }

      // 3. Return updated customer with addresses
      return await tx.customer.findUnique({
        where: { id: customerId },
        include: { addresses: true }
      });
    });

    return res.json({
      success: true,
      customer: serializeCustomer(result),
      message: 'Addresses updated successfully'
    });
  } catch (error) {
    console.error('Update addresses error:', error);
    return res.status(500).json({ error: error.message });
  }
};

export const requestCustomerProfileUpdateOtp = async (req, res) => {
  const { customerId } = req.params;
  const nextName = req.body?.name?.trim() || null;
  const nextGenderRaw = req.body?.gender;
  const nextEmailRaw = req.body?.email?.trim().toLowerCase() || null;
  const nextMobileRaw = req.body?.mobile;

  try {
    const customer = await prisma.customer.findUnique({
      where: { id: customerId },
      include: { addresses: true }
    });

    if (!customer) {
      return res.status(404).json({ message: 'Customer not found' });
    }

    const nextGender = ['male', 'female', 'other'].includes(String(nextGenderRaw || '').toLowerCase())
      ? String(nextGenderRaw).toLowerCase()
      : null;
    const normalizedMobile = nextMobileRaw ? normalizeMobile(nextMobileRaw) : null;

    if (nextMobileRaw && !normalizedMobile) {
      return res.status(400).json({ message: 'Invalid mobile number' });
    }

    const emailChanged = nextEmailRaw && nextEmailRaw !== customer.email;
    const mobileChanged = normalizedMobile && normalizedMobile !== customer.mobile;
    const nameChanged = nextName !== null && nextName !== customer.name;
    const genderChanged = nextGender !== customer.gender;

    if (!emailChanged && !mobileChanged && !nameChanged && !genderChanged) {
      return res.json({
        success: true,
        requiresOtp: false,
        customer: serializeCustomer(customer),
        message: 'No profile changes detected'
      });
    }

    if (emailChanged) {
      const existingEmail = await prisma.customer.findUnique({ where: { email: nextEmailRaw } });
      if (existingEmail && existingEmail.id !== customerId) {
        return res.status(400).json({ message: 'Email is already registered' });
      }
    }

    if (mobileChanged) {
      const existingMobile = await prisma.customer.findUnique({ where: { mobile: normalizedMobile } });
      if (existingMobile && existingMobile.id !== customerId) {
        return res.status(400).json({ message: 'Mobile number is already registered' });
      }
    }

    if (!emailChanged && !mobileChanged) {
      const updated = await prisma.customer.update({
        where: { id: customerId },
        data: {
          name: nextName,
          gender: nextGender
        },
        include: { addresses: true }
      });

      // Cascade name change to Orders
      if (nameChanged) {
        const orders = await prisma.order.findMany({ where: { customerId } });
        for (const order of orders) {
          if (order.shippingAddress && typeof order.shippingAddress === 'object') {
            const updatedAddress = {
              ...order.shippingAddress,
              fullName: nextName,
              firstName: nextName.split(' ')[0],
              lastName: nextName.split(' ').slice(1).join(' ') || ''
            };
            await prisma.order.update({
              where: { id: order.id },
              data: { shippingAddress: updatedAddress }
            });
          }
        }

        // Cascade name change to Sales
        await prisma.sale.updateMany({
          where: { 
            OR: [
              { orderId: { in: orders.map(o => o.id) } },
              { customerEmail: customer.email }
            ]
          },
          data: { customerName: nextName }
        });
      }

      return res.json({
        success: true,
        requiresOtp: false,
        customer: serializeCustomer(updated),
        message: 'Profile updated successfully'
      });
    }

    const payload = {
      purpose: 'customer-profile-update',
      customerId,
      pending: {
        name: nextName,
        gender: nextGender,
        email: emailChanged ? nextEmailRaw : customer.email,
        mobile: mobileChanged ? normalizedMobile : customer.mobile
      },
      emailOtpHash: null,
      mobileOtpHash: null,
      requireEmailOtp: emailChanged,
      requireMobileOtp: mobileChanged
    };

    if (emailChanged) {
      const emailOtp = generateOtp();
      payload.emailOtpHash = hashOtp(emailOtp);
      const sent = await sendMail(nextEmailRaw, 'Verify your updated email', TEMPLATES.SIGNUP_OTP(emailOtp));
      if (!sent) {
        return res.status(500).json({ message: 'Failed to send email OTP' });
      }
    }

    if (mobileChanged) {
      const mobileOtp = generateFourDigitOtp();
      payload.mobileOtpHash = hashOtp(mobileOtp);
      const sent = await sendSMS(normalizedMobile, TEMPLATES.SIGNUP_OTP(mobileOtp));
      if (!sent) {
        return res.status(500).json({ message: 'Failed to send mobile OTP' });
      }
    }

    const verificationToken = signActionToken(payload);

    return res.json({
      success: true,
      requiresOtp: true,
      verificationToken,
      requireEmailOtp: emailChanged,
      requireMobileOtp: mobileChanged,
      message: 'OTP sent for profile update verification'
    });
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
};

export const verifyCustomerProfileUpdateOtp = async (req, res) => {
  const { customerId } = req.params;
  const { verificationToken, emailOtp, mobileOtp } = req.body || {};

  try {
    if (!verificationToken) {
      return res.status(400).json({ message: 'Verification token is required' });
    }

    const payload = verifyActionToken(verificationToken, 'customer-profile-update');
    if (payload.customerId !== customerId) {
      return res.status(401).json({ message: 'Invalid verification request' });
    }

    if (payload.requireEmailOtp) {
      if (!emailOtp || hashOtp(String(emailOtp).trim()) !== payload.emailOtpHash) {
        return res.status(401).json({ message: 'Invalid or expired email OTP' });
      }
    }

    if (payload.requireMobileOtp) {
      if (!mobileOtp || hashOtp(String(mobileOtp).trim()) !== payload.mobileOtpHash) {
        return res.status(401).json({ message: 'Invalid or expired mobile OTP' });
      }
    }

    if (payload.pending?.email) {
      const existingEmail = await prisma.customer.findUnique({ where: { email: payload.pending.email } });
      if (existingEmail && existingEmail.id !== customerId) {
        return res.status(400).json({ message: 'Email is already registered' });
      }
    }

    if (payload.pending?.mobile) {
      const existingMobile = await prisma.customer.findUnique({ where: { mobile: payload.pending.mobile } });
      if (existingMobile && existingMobile.id !== customerId) {
        return res.status(400).json({ message: 'Mobile number is already registered' });
      }
    }

    const oldCustomer = await prisma.customer.findUnique({ where: { id: customerId } });

    const updated = await prisma.customer.update({
      where: { id: customerId },
      data: {
        name: payload.pending?.name || null,
        gender: payload.pending?.gender || null,
        email: payload.pending?.email || null,
        mobile: payload.pending?.mobile || null
      },
      include: { addresses: true }
    });

    const nextEmail = payload.pending?.email;
    const nextName = payload.pending?.name;

    // Cascade changes to Orders
    const orders = await prisma.order.findMany({ where: { customerId } });
    for (const order of orders) {
      if (order.shippingAddress && typeof order.shippingAddress === 'object') {
        const updatedAddress = {
          ...order.shippingAddress,
          ...(nextEmail ? { email: nextEmail } : {}),
          ...(nextName ? { fullName: nextName, firstName: nextName.split(' ')[0], lastName: nextName.split(' ').slice(1).join(' ') || '' } : {})
        };
        await prisma.order.update({
          where: { id: order.id },
          data: { shippingAddress: updatedAddress }
        });
      }
    }

    // Cascade changes to Sales
    await prisma.sale.updateMany({
      where: { 
        OR: [
          { orderId: { in: orders.map(o => o.id) } },
          { customerEmail: oldCustomer?.email }
        ]
      },
      data: {
        ...(nextEmail ? { customerEmail: nextEmail } : {}),
        ...(nextName ? { customerName: nextName } : {})
      }
    });

    return res.json({
      success: true,
      customer: serializeCustomer(updated),
      message: 'Profile updated successfully'
    });
  } catch (error) {
    const status = error.name === 'TokenExpiredError' || error.name === 'JsonWebTokenError' ? 401 : 500;
    return res.status(status).json({ message: status === 401 ? 'Invalid or expired verification session' : error.message });
  }
};
export const getAllCustomers = async (req, res) => {
  try {
    const customers = await prisma.customer.findMany({
      orderBy: { createdAt: 'desc' },
      include: {
        orders: {
          select: {
            id: true,
            totalAmount: true,
            status: true,
            createdAt: true,
            invoiceNumber: true,
            shippingAddress: true,
            items: {
              include: {
                product: { select: { name: true, thumbnailUrl: true } }
              }
            }
          },
          orderBy: { createdAt: 'desc' }
        }
      }
    });
    res.json(customers);
  } catch (error) {
    console.error('Error in getAllCustomers:', error);
    res.status(500).json({ error: error.message });
  }
};

export const getCustomerById = async (req, res) => {
  const { id } = req.params;
  try {
    const customer = await prisma.customer.findUnique({
      where: { id },
      include: {
        orders: {
          include: {
            items: {
              include: {
                product: { select: { name: true, thumbnailUrl: true } }
              }
            }
          },
          orderBy: { createdAt: 'desc' }
        }
      }
    });
    if (!customer) return res.status(404).json({ error: 'Customer not found' });
    res.json(customer);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

export const updateCustomerByAdmin = async (req, res) => {
  const { id } = req.params;
  const { name, email } = req.body;
  try {
    const oldCustomer = await prisma.customer.findUnique({ where: { id } });
    if (!oldCustomer) return res.status(404).json({ error: 'Customer not found' });

    const updatedCustomer = await prisma.customer.update({
      where: { id },
      data: { name, email }
    });

    // Cascade changes to Orders
    const orders = await prisma.order.findMany({ where: { customerId: id } });
    for (const order of orders) {
      if (order.shippingAddress && typeof order.shippingAddress === 'object') {
        const updatedAddress = {
          ...order.shippingAddress,
          ...(email ? { email } : {}),
          ...(name ? { fullName: name, firstName: name.split(' ')[0], lastName: name.split(' ').slice(1).join(' ') || '' } : {})
        };
        await prisma.order.update({
          where: { id: order.id },
          data: { shippingAddress: updatedAddress }
        });
      }
    }

    // Cascade changes to Sales
    await prisma.sale.updateMany({
      where: { 
        OR: [
          { orderId: { in: orders.map(o => o.id) } },
          { customerEmail: oldCustomer.email }
        ]
      },
      data: {
        ...(email ? { customerEmail: email } : {}),
        ...(name ? { customerName: name } : {})
      }
    });

    res.json({ success: true, customer: serializeCustomer(updatedCustomer) });
  } catch (error) {
    console.error('Error updating customer:', error);
    res.status(500).json({ error: error.message });
  }
};

// --- Mobile OTP Authentication (login + implicit signup) ---

export const sendOtp = async (req, res) => {
  const mobileRaw = req.body?.mobile;
  const forceResend = Boolean(req.body?.resend);

  try {
    if (!mobileRaw) {
      return res.status(400).json({ message: 'Mobile is required' });
    }

    const mobile = normalizeMobile(mobileRaw);
    if (!mobile) {
      return res.status(400).json({ message: 'Invalid mobile number' });
    }

    const existingOtp = await prisma.mobileOtp.findUnique({ where: { mobile } });
    if (existingOtp && existingOtp.expiresAt > new Date() && !forceResend) {
      // Do not send SMS again unless user explicitly requested resend.
      return res.json({
        success: true,
        mobile,
        otpAlreadySent: true,
        message: 'OTP already sent. Please use the existing OTP or click resend.'
      });
    }

    // Generate 4-digit OTP
    const otp = generateFourDigitOtp();
    const otpHash = hashOtp(otp);
    const expiresAt = new Date(Date.now() + MOBILE_OTP_TTL_MINUTES * 60 * 1000);

    // Upsert OTP row for this mobile
    await prisma.mobileOtp.upsert({
      where: { mobile },
      update: { otpHash, expiresAt, attempts: 0 },
      create: { mobile, otpHash, expiresAt, attempts: 0 }
    });

    const smsMessage = TEMPLATES.SIGNUP_OTP(otp);
    const smsSent = await sendSMS(mobile, smsMessage);
    if (!smsSent) {
      return res.status(500).json({ message: 'Failed to send OTP SMS' });
    }

    return res.json({ success: true, mobile });
  } catch (error) {
    console.error('sendOtp error:', error);
    return res.status(500).json({ error: error.message });
  }
};

export const verifyMobileOtp = async (req, res) => {
  const { mobile: mobileRaw, otp } = req.body || {};

  try {
    if (!mobileRaw || otp === undefined || otp === null) {
      return res.status(400).json({ message: 'Mobile and OTP are required' });
    }

    const mobile = normalizeMobile(mobileRaw);
    if (!mobile) {
      return res.status(400).json({ message: 'Invalid mobile number' });
    }

    const otpRecord = await prisma.mobileOtp.findUnique({ where: { mobile } });
    if (!otpRecord) {
      return res.status(401).json({ message: 'Invalid or expired OTP' });
    }

    if (otpRecord.expiresAt < new Date()) {
      // Expired OTP should be cleared
      await prisma.mobileOtp
        .delete({ where: { mobile } })
        .catch(() => {});
      return res.status(401).json({ message: 'Invalid or expired OTP' });
    }

    const otpStr = String(otp).trim();
    const otpHash = hashOtp(otpStr);

    if (otpRecord.otpHash !== otpHash) {
      const nextAttempts = (otpRecord.attempts ?? 0) + 1;

      if (nextAttempts >= MAX_MOBILE_OTP_ATTEMPTS) {
        // Lock/clear after max attempts
        await prisma.mobileOtp
          .delete({ where: { mobile } })
          .catch(() => {});

        return res
          .status(401)
          .json({ message: 'Too many OTP attempts. Please request a new OTP.' });
      }

      await prisma.mobileOtp.update({
        where: { mobile },
        data: { attempts: nextAttempts }
      });

      return res.status(401).json({ message: 'Invalid or expired OTP' });
    }

    // OTP verified successfully: clear OTP row
    await prisma.mobileOtp
      .delete({ where: { mobile } })
      .catch(() => {});

    // Implicit signup: create customer if it doesn't exist
    let customer = await prisma.customer.findUnique({
      where: { mobile },
      include: { addresses: true }
    });

    if (!customer) {
      customer = await prisma.customer.create({
        data: {
          mobile,
          provider: 'phone'
        },
        include: { addresses: true }
      });
    }

    const token = issueCustomerAuthToken(customer);

    return res.json({
      success: true,
      customer: serializeCustomer(customer),
      token
    });
  } catch (error) {
    console.error('verifyMobileOtp error:', error);
    return res.status(500).json({ error: error.message });
  }
};
