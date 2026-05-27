import prisma from '../utils/prisma.js';

const normalizeCode = (value = '') => value.trim().toUpperCase();

export const getCoupons = async (_req, res) => {
  try {
    const coupons = await prisma.coupon.findMany({
      orderBy: { createdAt: 'desc' }
    });
    res.json(coupons);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

export const createCoupon = async (req, res) => {
  try {
    const code = normalizeCode(req.body.code);
    const percentage = parseFloat(req.body.percentage);
    const type = req.body.type || 'PERCENTAGE';
    const maxUses = req.body.maxUses ? parseInt(req.body.maxUses) : null;
    const allowedEmailsText = req.body.allowedEmails || '';
    
    // Parse allowedEmails from comma-separated string if provided
    const allowedEmails = allowedEmailsText 
      ? allowedEmailsText.split(',').map(e => e.trim().toLowerCase()).filter(e => e)
      : [];

    if (!code) {
      return res.status(400).json({ error: 'Coupon code is required.' });
    }

    if (Number.isNaN(percentage) || percentage <= 0) {
      return res.status(400).json({ error: 'Coupon value must be greater than 0.' });
    }

    if (type === 'PERCENTAGE' && percentage > 100) {
      return res.status(400).json({ error: 'Coupon percentage must be between 1 and 100.' });
    }

    const coupon = await prisma.coupon.create({
      data: {
        code,
        percentage,
        type,
        maxUses,
        allowedEmails,
        isActive: req.body.isActive !== false
      }
    });

    res.status(201).json(coupon);
  } catch (error) {
    if (error.code === 'P2002') {
      return res.status(400).json({ error: 'This coupon code already exists.' });
    }
    res.status(500).json({ error: error.message });
  }
};

export const updateCoupon = async (req, res) => {
  try {
    const data = {};

    if (req.body.code !== undefined) {
      const normalized = normalizeCode(req.body.code);
      if (!normalized) {
        return res.status(400).json({ error: 'Coupon code is required.' });
      }
      data.code = normalized;
    }

    if (req.body.type !== undefined) {
      data.type = req.body.type;
    }

    if (req.body.percentage !== undefined) {
      const percentage = parseFloat(req.body.percentage);
      if (Number.isNaN(percentage) || percentage <= 0) {
        return res.status(400).json({ error: 'Coupon value must be greater than 0.' });
      }
      // Assuming type is either provided in body or already set, if PERCENTAGE, validate > 100 is skipped here for simplicity or done dynamically.
      data.percentage = percentage;
    }

    if (req.body.isActive !== undefined) {
      data.isActive = Boolean(req.body.isActive);
    }
    
    if (req.body.maxUses !== undefined) {
      data.maxUses = req.body.maxUses === '' ? null : parseInt(req.body.maxUses);
    }
    
    if (req.body.allowedEmails !== undefined) {
      const allowedEmailsText = req.body.allowedEmails;
      data.allowedEmails = allowedEmailsText 
        ? allowedEmailsText.split(',').map(e => e.trim().toLowerCase()).filter(e => e)
        : [];
    }

    const coupon = await prisma.coupon.update({
      where: { id: req.params.id },
      data
    });

    res.json(coupon);
  } catch (error) {
    if (error.code === 'P2002') {
      return res.status(400).json({ error: 'This coupon code already exists.' });
    }
    res.status(500).json({ error: error.message });
  }
};

export const deleteCoupon = async (req, res) => {
  try {
    await prisma.coupon.delete({
      where: { id: req.params.id }
    });
    res.json({ message: 'Coupon deleted successfully.' });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

export const validateCoupon = async (req, res) => {
  try {
    const code = normalizeCode(req.body.code);
    const email = req.body.email ? String(req.body.email).trim().toLowerCase() : null;

    if (!code) {
      return res.status(400).json({ error: 'Coupon code is required.' });
    }

    const coupon = await prisma.coupon.findFirst({
      where: {
        code,
        isActive: true
      }
    });

    if (!coupon) {
      return res.status(404).json({ error: 'Invalid or inactive coupon code.' });
    }

    // Check max uses limit
    if (coupon.maxUses !== null && coupon.usedCount >= coupon.maxUses) {
      return res.status(400).json({ error: 'This coupon has reached its maximum usage limit.' });
    }

    // Check email restriction
    if (coupon.allowedEmails && coupon.allowedEmails.length > 0) {
      if (!email) {
        return res.status(400).json({ error: 'Email is required to use this coupon.' });
      }
      if (!coupon.allowedEmails.includes(email)) {
        return res.status(403).json({ error: 'This coupon is not valid for your email address.' });
      }
    }

    res.json({
      id: coupon.id,
      code: coupon.code,
      percentage: coupon.percentage, // Kept for backward compatibility
      type: coupon.type,
      value: coupon.percentage
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

export const getActiveCoupons = async (req, res) => {
  try {
    const coupons = await prisma.coupon.findMany({
      where: {
        isActive: true,
      },
      orderBy: { createdAt: 'desc' }
    });

    const activeCoupons = coupons.filter(coupon => {
      const isUnderMaxUses = coupon.maxUses === null || coupon.usedCount < coupon.maxUses;
      const isPublic = !coupon.allowedEmails || !Array.isArray(coupon.allowedEmails) || coupon.allowedEmails.length === 0;
      return isUnderMaxUses && isPublic;
    });

    res.json(activeCoupons);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};
