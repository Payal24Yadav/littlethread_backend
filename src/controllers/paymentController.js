import Razorpay from 'razorpay';
import crypto from 'crypto';
import prisma from '../utils/prisma.js';
import { logActivity } from '../services/activityService.js';
import { sendMail, TEMPLATES, sendInvoiceEmail } from '../utils/mailer.js';
import { generateInvoice } from '../utils/invoiceGenerator.js';
import { notifyOrderCreated, notifyPaymentSuccess } from '../services/notificationService.js';
import { logger } from '../utils/logger.js';
import * as shippingService from '../services/shippingService.js';

const reduceInventory = async (orderId) => {
  try {
    const items = await prisma.orderItem.findMany({
      where: { orderId },
      include: { product: true }
    });

    logger.info('inventory.reduce.start', {
      order_id: orderId,
      items_count: items.length
    });

    for (const item of items) {
      const quantity = Math.max(1, item.quantity || 0);
      
      if (item.variantTitle) {
        const itemTitle = (item.variantTitle || '').trim();
        const itemTitleSlug = itemTitle.toLowerCase().replace(/[^a-z0-9]/g, '');
        
        logger.info('inventory.reduce.attempt_match', {
          product_id: item.productId,
          target_title: itemTitle,
          target_slug: itemTitleSlug
        });

        // 1. Try exact (case-insensitive) match first
        let variant = await prisma.productVariant.findFirst({
          where: {
            productId: item.productId,
            title: {
              equals: itemTitle,
                
            }
          }
        });

        // 2. If no match, try finding by matching normalized slugs (ignores spaces/commas/colons)
        if (!variant) {
          const variants = await prisma.productVariant.findMany({
            where: { productId: item.productId }
          });
          
          variant = variants.find(v => {
            const vSlug = v.title.toLowerCase().replace(/[^a-z0-9]/g, '');
            return vSlug === itemTitleSlug;
          });

          if (variant) {
            logger.info('inventory.reduce.match_found_via_slug', {
              variant_id: variant.id,
              variant_title: variant.title
            });
          }
        }

        if (variant) {
          const currentStock = variant.stock || 0;
          const updatedVariant = await prisma.productVariant.update({
            where: { id: variant.id },
            data: { stock: { decrement: quantity } }
          });

          logger.info('inventory.reduce.variant_decremented', {
            order_id: orderId,
            variant_id: variant.id,
            variant_title: variant.title,
            quantity_decremented: quantity,
            stock_after: updatedVariant.stock
          });
        } else {
          // 3. Final Fallback: Product Global Stock
          logger.warn('inventory.reduce.variant_not_found_falling_back', {
            order_id: orderId,
            product_id: item.productId,
            variant_title: itemTitle
          });

          const updatedProduct = await prisma.product.update({
            where: { id: item.productId },
            data: { stock: { decrement: quantity } }
          });

          logger.info('inventory.reduce.product_stock_decremented', {
            product_id: item.productId,
            quantity_decremented: quantity,
            stock_after: updatedProduct.stock
          });
        }
      } else {
        // No variantTitle provided
        await prisma.product.update({
          where: { id: item.productId },
          data: { stock: { decrement: quantity } }
        });
      }
    }

    logger.info('inventory.reduce.complete', {
      order_id: orderId,
      items_processed: items.length
    });
  } catch (error) {
    logger.error('inventory.reduce.error', {
      order_id: orderId,
      error: error.message,
      stack: error.stack,
    });
    throw error; // Re-throw to prevent silent failures
  }
};

const generateNextInvoiceNumber = async () => {
  try {
    const currentYear = new Date().getFullYear();
    const prefix = `LTF-${currentYear}-`;
    
    const lastOrder = await prisma.order.findFirst({
      where: { invoiceNumber: { startsWith: prefix } },
      orderBy: { createdAt: 'desc' }
    });

    let nextNumber = 1;
    if (lastOrder && lastOrder.invoiceNumber) {
      const parts = lastOrder.invoiceNumber.split('-');
      const lastNum = parseInt(parts[parts.length - 1]);
      if (!isNaN(lastNum)) {
        nextNumber = lastNum + 1;
      }
    }

    return `${prefix}${String(nextNumber).padStart(2, '0')}`;
  } catch (error) {
    const currentYear = new Date().getFullYear();
    logger.error('invoice.generate.error', {
      error: error.message,
      stack: error.stack,
    });
    return `LTF-${currentYear}-${Date.now().toString().slice(-2)}`;
  }
};

const createOrderWithInvoiceRetry = async (data, maxRetries = 4, include = null) => {
  for (let attempt = 1; attempt <= maxRetries; attempt += 1) {
    const currentYear = new Date().getFullYear();
    const invoiceNumber =
      attempt < maxRetries
        ? await generateNextInvoiceNumber()
        : `LTF-${currentYear}-${Date.now().toString().slice(-4)}-${Math.floor(Math.random() * 100)}`;

    try {
      return await prisma.order.create({
        data: {
          ...data,
          invoiceNumber,
        },
        include,
      });
    } catch (error) {
      const isInvoiceConflict = error?.code === 'P2002' &&
        String(error?.meta?.target || '').includes('invoiceNumber');
      if (!isInvoiceConflict || attempt === maxRetries) {
        throw error;
      }

      logger.warn('invoice.generate.conflict_retry', {
        attempt,
        reason: 'invoiceNumber unique conflict',
      });
    }
  }

  throw new Error('Unable to generate unique invoice number');
};

const resolveCheckoutCustomerId = async (req, customerEmail) => {
  if (req.user?.role === 'customer' && req.user?.id) {
    return String(req.user.id);
  }

  const email = String(customerEmail || '').trim().toLowerCase();
  if (!email) return null;

  const customer = await prisma.customer.findUnique({
    where: { email },
    select: { id: true },
  });

  return customer?.id || null;
};

let razorpay = null;

console.log("KEY:", process.env.RAZORPAY_KEY_ID);
console.log("SECRET:", process.env.RAZORPAY_KEY_SECRET);

try {
  const keyId = (process.env.RAZORPAY_KEY_ID || '').trim();
  const keySecret = (process.env.RAZORPAY_KEY_SECRET || '').trim();

  if (keyId && keySecret) {
    razorpay = new Razorpay({
      key_id: process.env.RAZORPAY_KEY_ID,
      key_secret: process.env.RAZORPAY_KEY_SECRET,
    });

    logger.info('Razorpay initialized successfully');
    console.log('✅ Razorpay initialized successfully with keyId:', keyId);
  } else {
    logger.warn(
      'Razorpay credentials missing. Payment gateway disabled.'
    );
    console.log('⚠️ Razorpay credentials missing. Payment gateway disabled.');
  }
} catch (error) {
  logger.error('Razorpay initialization failed', {
    error: error.message,
    stack: error.stack,
  });
  console.error('❌ Razorpay initialization failed:', error);
}

export const getPaymentConfig = async (req, res) => {
  try {
    const settings = await prisma.globalSetting.findUnique({ where: { id: 'default' } });
    res.json({
      razorpayKeyId: process.env.RAZORPAY_KEY_ID || null,
      codEnabled: settings ? Boolean(settings.codEnabled) : false,
      codMaxAmount: settings ? Number(settings.codMaxAmount || 0) : 0,
      codCharges: settings ? Number(settings.codCharges || 0) : 0,
    });
  } catch (error) {
    logger.error('payments.config.read_error', { error: error.message });
    res.json({ razorpayKeyId: process.env.RAZORPAY_KEY_ID || null });
  }
};

const normalizeAddressForSave = (shippingAddress = {}, customerName = '', customerEmail = '') => ({
  id: shippingAddress.id || `addr_${Date.now()}`,
  label: shippingAddress.label || 'Saved Address',
  firstName: shippingAddress.firstName || '',
  lastName: shippingAddress.lastName || '',
  email: shippingAddress.email || customerEmail || '',
  address: shippingAddress.address || '',
  apartment: shippingAddress.apartment || '',
  city: shippingAddress.city || '',
  state: shippingAddress.state || '',
  pinCode: shippingAddress.pinCode || '',
  phone: shippingAddress.phone || '',
  fullName:
    shippingAddress.fullName ||
    [shippingAddress.firstName, shippingAddress.lastName].filter(Boolean).join(' ') ||
    customerName ||
    null
});

const normalizeVariantTitle = (value = '') => String(value || '').trim().toLowerCase().replace(/[^a-z0-9]/g, '');

const validateCheckoutItems = async (items, requestedAmount, couponCode = null, email = null) => {
  const errors = [];
  const canonicalItems = [];

  for (const item of items) {
    const quantity = Number(item.quantity);
    if (!item.productId || !Number.isInteger(quantity) || quantity <= 0) {
      errors.push(`Invalid cart item for product ${item.productId || 'unknown'}`);
      continue;
    }

    const product = await prisma.product.findUnique({
      where: { id: item.productId },
      include: { variants: true },
    });

    if (!product || product.active === false) {
      errors.push(`Product ${item.productName || item.productId} is no longer available`);
      continue;
    }

    const requestedVariant = item.variantTitle ? normalizeVariantTitle(item.variantTitle) : '';
    const variant = requestedVariant
      ? product.variants.find((candidate) => normalizeVariantTitle(candidate.title) === requestedVariant)
      : null;
    const availableStock = variant ? Number(variant.stock || 0) : Number(product.stock || 0);

    if (availableStock < quantity) {
      errors.push(`${product.name}${variant ? ` (${variant.title})` : ''} has only ${availableStock} item(s) in stock`);
      continue;
    }

    const price = Number(variant?.price ?? product.price ?? 0);
    if (!Number.isFinite(price) || price <= 0) {
      errors.push(`${product.name} has invalid pricing`);
      continue;
    }

    canonicalItems.push({
      productId: product.id,
      productName: product.name,
      quantity,
      price,
      variantTitle: variant?.title || item.variantTitle || null,
    });
  }

  let canonicalAmount = canonicalItems.reduce((sum, item) => sum + item.price * item.quantity, 0);

  if (couponCode && errors.length === 0) {
    const coupon = await prisma.coupon.findFirst({
      where: {
        code: couponCode.trim().toUpperCase(),
        isActive: true
      }
    });

    if (coupon) {
      const isUnderMaxUses = coupon.maxUses === null || coupon.usedCount < coupon.maxUses;
      const isAllowedEmail = !coupon.allowedEmails || !Array.isArray(coupon.allowedEmails) || coupon.allowedEmails.length === 0 || (email && coupon.allowedEmails.includes(email.trim().toLowerCase()));

      if (isUnderMaxUses && isAllowedEmail) {
        let appliedDiscount = 0;
        if (coupon.type === 'PERCENTAGE') {
          appliedDiscount = Math.round(canonicalAmount * (coupon.percentage / 100));
        } else {
          appliedDiscount = coupon.percentage;
        }
        canonicalAmount = Math.max(0, canonicalAmount - appliedDiscount);
      } else {
        errors.push('Coupon is invalid or expired for this order.');
      }
    } else {
      errors.push('Invalid coupon code.');
    }
  }

  if (errors.length === 0 && Math.abs(Number(requestedAmount) - canonicalAmount) > 1) {
    errors.push('Cart total changed. Please refresh your cart and try again.');
  }

  return {
    valid: errors.length === 0,
    errors,
    canonicalAmount,
    canonicalItems,
  };
};

export const createRazorpayOrder = async (req, res) => {
  console.log('🔷 createRazorpayOrder called');
  console.log('📋 Request body:', JSON.stringify(req.body, null, 2));

  const {
    amount,
    currency = 'INR',
    receipt,
    items,
    customerEmail,
    customerName,
    paymentMethod,
    shippingAddress,
    couponCode
  } = req.body;

  console.log('💰 Amount received:', amount);
  console.log('🛒 Cart Items count:', Array.isArray(items) ? items.length : 0);
  if (Array.isArray(items)) {
    items.forEach((item, index) => {
      console.log(`   Item [${index}]: productId=${item.productId}, productName=${item.productName || item.name}, quantity=${item.quantity}, price=${item.price}, variantTitle=${item.variantTitle}`);
    });
  }

  try {
    logger.info('payments.create.request_received', {
      user_id: req.user?.id || null,
      payment_method: paymentMethod || null,
      status: 'requested',
      item_count: Array.isArray(items) ? items.length : 0,
      amount,
      customerEmail,
      customerName,
    });

    // 1. Validate Razorpay configuration & initialization
    if (paymentMethod !== 'cod' && !razorpay) {
      console.log('❌ Razorpay not initialized');
      logger.error('payments.create.razorpay_not_initialized', {
        razorpay_key_id: process.env.RAZORPAY_KEY_ID ? 'SET' : 'MISSING',
        razorpay_key_secret: process.env.RAZORPAY_KEY_SECRET ? 'SET' : 'MISSING',
      });
      return res.status(500).json({
        success: false,
        message: 'Payment gateway not configured. Please contact support.',
      });
    }
    console.log('✅ Razorpay is initialized');

    // 2. Validate total amount
    if (amount === undefined || amount === null) {
      console.log('❌ Total amount is undefined or null');
      return res.status(400).json({
        success: false,
        message: 'Total amount is required and undefined.',
      });
    }

    const numericAmount = Number(amount);
    if (isNaN(numericAmount) || numericAmount <= 0) {
      console.log('❌ Invalid total amount:', amount);
      return res.status(400).json({
        success: false,
        message: 'Invalid total amount. Amount must be greater than 0.',
      });
    }
    console.log('✅ Amount is valid:', amount);

    // 3. Validate customer data
    if (!customerEmail || !customerName) {
      console.log('❌ Customer name or email is missing');
      return res.status(400).json({
        success: false,
        message: 'Customer name and email are required.',
      });
    }
    console.log('✅ Customer data verified:', { customerEmail, customerName });

    // 4. Validate shipping address
    if (!shippingAddress || typeof shippingAddress !== 'object') {
      console.log('❌ Shipping address is missing or invalid');
      return res.status(400).json({
        success: false,
        message: 'Shipping address is required.',
      });
    }

    // Shiprocket shipment creation requires phone + pincode + city/state.
    // Enforce at payment time so we don't end up with paid orders that can't be shipped.
    const requiredAddressFields = ['address', 'city', 'state', 'pinCode', 'phone'];
    const missingAddressFields = requiredAddressFields.filter(field => !shippingAddress[field]);
    if (missingAddressFields.length > 0) {
      console.log('❌ Shipping address is missing fields:', missingAddressFields);
      return res.status(400).json({
        success: false,
        message: `Shipping address is missing required fields: ${missingAddressFields.join(', ')}.`,
      });
    }
    console.log('✅ Shipping address verified');

    // 5. Validate items array
    if (!items || !Array.isArray(items) || items.length === 0) {
      console.log('❌ Items array is missing or empty');
      return res.status(400).json({
        success: false,
        message: 'Cart cannot be empty. Add items before proceeding.',
      });
    }

    // Verify all item details
    for (const item of items) {
      if (!item.productId || !item.quantity || !item.price) {
        console.log('❌ Invalid cart item structure:', item);
        return res.status(400).json({
          success: false,
          message: 'Each cart item must have a valid productId, quantity, and price.',
        });
      }
    }
    console.log('✅ Items valid, count:', items.length);

    const checkoutValidation = await validateCheckoutItems(items, numericAmount, couponCode, customerEmail);
    if (!checkoutValidation.valid) {
      logger.warn('payments.create.cart_validation_failed', {
        errors: checkoutValidation.errors,
      });
      return res.status(400).json({
        success: false,
        message: checkoutValidation.errors[0] || 'Cart validation failed',
        errors: checkoutValidation.errors,
      });
    }

    const validatedItems = checkoutValidation.canonicalItems;
    const validatedAmount = checkoutValidation.canonicalAmount;

    // 6. Check if COD is allowed
    console.log('🔍 Checking COD settings...');
    const settings = await prisma.globalSetting.findUnique({ where: { id: 'default' } });
    const isCodEnabled = settings ? settings.codEnabled : false;
    console.log('✅ COD settings checked, enabled:', isCodEnabled);

    if (paymentMethod === 'cod' && !isCodEnabled) {
      console.log('❌ COD disabled');
      logger.warn('payments.create.cod_disabled');
      return res.status(400).json({
        success: false,
        message: 'Cash on Delivery is currently disabled by admin.',
      });
    }

    // Additional COD validations: country must be India and amount must be under configured max
    if (paymentMethod === 'cod') {
      const country = (shippingAddress?.country || shippingAddress?.countryCode || '').toString().trim().toLowerCase();
      const pincode = String(shippingAddress?.pinCode || shippingAddress?.pincode || '').trim();
      if (country && country !== 'india' && country !== 'in') {
        return res.status(400).json({ success: false, message: 'Cash on Delivery is only available for India.' });
      }

      const maxAllowed = Number(settings?.codMaxAmount || 0);
      if (maxAllowed > 0 && validatedAmount > maxAllowed) {
        return res.status(400).json({ success: false, message: `Cash on Delivery is not available for orders above ₹${maxAllowed}.` });
      }
    }

    const resolvedCustomerId = await resolveCheckoutCustomerId(req, customerEmail);

    // 7. Handle COD
    if (paymentMethod === 'cod') {
      console.log('💳 Processing COD payment');
      logger.info('payments.create.handling_cod', { customerId: resolvedCustomerId });
      const codFee = Number(settings?.codCharges || 0) || 0;

      const orderTotal = validatedAmount + codFee;
      const order = await createOrderWithInvoiceRetry({
        totalAmount: orderTotal,
        status: 'ORDERED',
        paymentStatus: 'PENDING',
        codCharges: codFee,
        customerId: resolvedCustomerId,
        paymentMethod: 'cod',
        shippingAddress: {
          ...shippingAddress,
          email: shippingAddress?.email || customerEmail || null,
          fullName: shippingAddress?.fullName ||
            [shippingAddress?.firstName, shippingAddress?.lastName].filter(Boolean).join(' ') ||
            customerName || null,
        },
        items: {
          create: validatedItems.map(item => ({
            productId: item.productId,
            productName: item.productName || item.name,
            quantity: item.quantity,
            price: item.price,
            variantTitle: item.variantTitle,
          })),
        },
      });

      console.log('✅ Prisma COD order created successfully:', JSON.stringify(order, null, 2));
      logger.info('payments.create.order_inserted', {
        user_id: resolvedCustomerId,
        order_id: order.id,
        payment_id: null,
        status: order.status,
      });

      try {
        await notifyOrderCreated(order);
      } catch (error) {
        logger.error('payments.create.notify_order_created.error', {
          order_id: order.id,
          error: error?.message || String(error),
        });
      }

      await logActivity(order.id, 'ORDER_PLACED', 'Order placed with Cash on Delivery. Payment is pending collection.');

      // Increment coupon usage if used
      if (req.body.couponCode) {
        try {
          await prisma.coupon.update({
            where: { code: req.body.couponCode },
            data: { usedCount: { increment: 1 } }
          });
        } catch (couponErr) {
          logger.error('payments.create.coupon_increment.error', {
            coupon_code: req.body.couponCode,
            error: couponErr?.message || String(couponErr)
          });
        }
      }

      const emailToSend = shippingAddress?.email || customerEmail || null;
      if (emailToSend) {
        await sendMail(emailToSend, 'Order Confirmation - Little Threads', TEMPLATES.ORDER_CONFIRMATION());
      }

      return res.json({
        success: true,
        orderId: order.id,
        paymentMethod,
        status: order.status,
        paymentStatus: order.paymentStatus,
      });
    }

    // 8. Handle Razorpay (Create Razorpay Order + Create DB Order)
    console.log('💳 Processing Razorpay payment');
    const amountInPaise = Math.round(validatedAmount * 100);
    console.log('📊 Razorpay details - Amount (Rupees):', validatedAmount, 'Amount (Paise):', amountInPaise);
    
    if (!Number.isInteger(amountInPaise) || amountInPaise <= 0) {
      console.log('❌ Amount in paise is not a valid integer:', amountInPaise);
      return res.status(400).json({
        success: false,
        message: 'Amount in paise must be a valid positive integer.',
      });
    }

    logger.info('payments.create.preparing_razorpay', {
      amountInRupees: validatedAmount,
      amountInPaise,
      customerName,
      customerEmail,
      itemCount: validatedItems.length,
    });

    const options = {
      amount: amountInPaise,
      currency: currency || 'INR',
      receipt: receipt || `order_${Date.now()}`,
      notes: {
        customerEmail: customerEmail || '',
        customerName: customerName || '',
        paymentMethod: 'razorpay'
      }
    };

    console.log('🎯 Razorpay order options:', JSON.stringify(options, null, 2));
    logger.info('payments.create.razorpay_order_options', options);

    console.log('🚀 Calling razorpay.orders.create()...');
    const razorpayOrder = await razorpay.orders.create(options);
    
    console.log('✅ Razorpay order created:', razorpayOrder.id);
    console.log('✅ Razorpay order response:', JSON.stringify(razorpayOrder, null, 2));
    
    logger.info('payments.create.razorpay_order_created', {
      razorpay_order_id: razorpayOrder.id,
      amount: razorpayOrder.amount,
      currency: razorpayOrder.currency,
      status: razorpayOrder.status,
    });

    // Create a DB order with PENDING status to register the checkout intent
    console.log('🚀 Creating DB order with status PENDING...');
    const order = await createOrderWithInvoiceRetry({
      totalAmount: validatedAmount,
      status: 'PENDING',
      paymentStatus: 'PENDING',
      customerId: resolvedCustomerId,
      razorpayOrderId: razorpayOrder.id,
      paymentMethod: 'razorpay',
      shippingAddress: {
        ...shippingAddress,
        email: shippingAddress?.email || customerEmail || null,
        fullName: shippingAddress?.fullName ||
          [shippingAddress?.firstName, shippingAddress?.lastName].filter(Boolean).join(' ') ||
          customerName || null,
      },
      items: {
          create: validatedItems.map(item => ({
          productId: item.productId,
          productName: item.productName || item.name,
          quantity: item.quantity,
          price: item.price,
          variantTitle: item.variantTitle,
        })),
      },
    });

    console.log('✅ Prisma order created successfully:', JSON.stringify(order, null, 2));
    logger.info('payments.create.db_order_precreated', {
      order_id: order.id,
      razorpay_order_id: razorpayOrder.id
    });

    return res.json({
      success: true,
      id: razorpayOrder.id,
      amount: razorpayOrder.amount,
      currency: razorpayOrder.currency,
      paymentMethod: 'razorpay',
      orderId: order.id
    });

  } catch (error) {
    console.error('💥 Payment Creation Error:', error);
    console.error(error);
    if (error) {
      console.error(error.error);
      console.error(error.statusCode);
    }
    const detailedMessage = error.error?.description || error.description || error.message || 'Failed to create payment order';
    console.error('💥 Detailed error description:', detailedMessage);

    logger.error('payments.create.error', {
      user_id: req.user?.id || null,
      payment_method: paymentMethod || null,
      error: detailedMessage,
      stack: error.stack,
      errorCode: error.code || error.error?.code || 'UNKNOWN',
    });
    
    return res.status(500).json({
      success: false,
      message: detailedMessage,
    });
  }
};

export const verifyPayment = async (req, res) => {
  const { 
    razorpay_order_id, 
    razorpay_payment_id, 
    razorpay_signature,
    orderData // Sent from frontend on success
  } = req.body;

  try {
    logger.info('payments.verify.request_received', {
      user_id: req.user?.id || null,
      payment_id: razorpay_payment_id || null,
      razorpay_order_id: razorpay_order_id || null,
      status: 'requested',
    });

    // 🔥 NEW: Log FULL orderData
    logger.info('🧾 ORDER_DATA_RECEIVED', {
      orderData
    });

    // 1. Verify Signature
    const sign = razorpay_order_id + "|" + razorpay_payment_id;
    const expectedSign = crypto
      .createHmac("sha256", process.env.RAZORPAY_KEY_SECRET)
      .update(sign.toString())
      .digest("hex");

    if (razorpay_signature !== expectedSign) {
      logger.warn('payments.verify.signature_mismatch', {
        user_id: req.user?.id || null,
        payment_id: razorpay_payment_id || null,
        razorpay_order_id: razorpay_order_id || null,
        status: 'failed',
      });
      return res.status(400).json({ message: "Invalid signature sent!" });
    }

    logger.info('payments.verify.signature_valid', {
      user_id: req.user?.id || null,
      payment_id: razorpay_payment_id || null,
      razorpay_order_id: razorpay_order_id || null,
      status: 'verified',
    });

    // 🔥 NEW: Log products inside order
    logger.info('🛒 ORDER_ITEMS', {
      items: orderData?.items?.map(i => ({
        productId: i.productId,
        quantity: i.quantity,
        price: i.price,
        variant: i.variantTitle
      }))
    });

    const existingOrder = await prisma.order.findFirst({
      where: {
        OR: [
          { razorpayPaymentId: razorpay_payment_id },
          { AND: [{ razorpayOrderId: razorpay_order_id }, { status: 'PAID' }] },
        ],
      },
      include: { items: true },
    });

    if (existingOrder) {
      logger.warn('payments.verify.idempotent_hit', {
        user_id: req.user?.id || null,
        payment_id: razorpay_payment_id || null,
        order_id: existingOrder.id,
        status: existingOrder.status,
      });
      return res.json({ message: 'Payment already verified', order: existingOrder });
    }

    const rpOrder = await razorpay.orders.fetch(razorpay_order_id);

    const subtotal = orderData.items.reduce((acc, item) => acc + (item.price * item.quantity), 0);
    const paidAmount = rpOrder.amount / 100;

    logger.info('💰 PAYMENT_DETAILS', {
      subtotal,
      paidAmount,
      razorpay_amount: rpOrder.amount
    });

    const requestedCustomerId = req.user?.id || orderData?.customerId || null;
    let resolvedCustomerId = null;

    if (requestedCustomerId) {
      const existingCustomer = await prisma.customer.findUnique({
        where: { id: requestedCustomerId },
        select: { id: true }
      });
      resolvedCustomerId = existingCustomer?.id || null;
    }

    if (!resolvedCustomerId && orderData?.customerEmail) {
      const emailCustomer = await prisma.customer.findUnique({
        where: { email: String(orderData.customerEmail).trim().toLowerCase() },
        select: { id: true }
      });
      resolvedCustomerId = emailCustomer?.id || null;
    }

    // 🔥 NEW: Log before DB insert
    logger.info('📥 BEFORE_DB_INSERT', {
      customerId: resolvedCustomerId,
      totalAmount: paidAmount,
      itemCount: orderData.items?.length
    });

    let order = await prisma.order.findUnique({
      where: { razorpayOrderId: razorpay_order_id },
      include: { items: true }
    });

    if (order) {
      logger.info('payments.verify.updating_existing_order', {
        order_id: order.id,
        razorpay_order_id
      });
      order = await prisma.order.update({
        where: { id: order.id },
        data: {
          status: 'PAID',
          paymentStatus: 'PAID',
          razorpayPaymentId: razorpay_payment_id,
          razorpaySignature: razorpay_signature,
          paymentMethod: 'razorpay'
        },
        include: { items: true }
      });
    } else {
      logger.info('payments.verify.order_not_found_creating_fallback', {
        razorpay_order_id
      });
      order = await createOrderWithInvoiceRetry({
        totalAmount: paidAmount,
        status: 'PAID',
        paymentStatus: 'PAID',
        customerId: resolvedCustomerId,
        razorpayOrderId: razorpay_order_id,
        razorpayPaymentId: razorpay_payment_id,
        razorpaySignature: razorpay_signature,
        paymentMethod: 'razorpay',
        shippingAddress: {
          ...orderData.shippingAddress,
          email: orderData.shippingAddress?.email || orderData.customerEmail || null,
          fullName: orderData.shippingAddress?.fullName || orderData.customerName || null,
        },
        items: {
          create: orderData.items.map(item => ({
            productId: item.productId,
            productName: item.productName || item.name,
            quantity: item.quantity,
            price: item.price,
            variantTitle: item.variantTitle,
          })),
        },
      }, 4, { items: true });
    }

    // 🔥 NEW: Confirm insert success
    logger.info('✅ ORDER_CREATED_SUCCESS', {
      order_id: order.id,
      payment_id: razorpay_payment_id,
      totalAmount: paidAmount
    });

    // Reduce inventory (don't fail payment if inventory reduction fails)
    try {
      await reduceInventory(order.id);
    } catch (inventoryError) {
      logger.error('payments.verify.inventory_reduce_failed', {
        order_id: order.id,
        payment_id: razorpay_payment_id,
        error: inventoryError.message,
        stack: inventoryError.stack
      });
      // Continue - don't throw, payment is still valid
    }

    // Increment coupon usage if used
    if (orderData?.couponCode) {
      try {
        await prisma.coupon.update({
          where: { code: orderData.couponCode },
          data: { usedCount: { increment: 1 } }
        });
      } catch (couponErr) {
        logger.error('payments.verify.coupon_increment.error', {
          coupon_code: orderData.couponCode,
          error: couponErr?.message || String(couponErr)
        });
      }
    }

    // Track sales
    await Promise.all(order.items.map(item =>
      prisma.sale.create({
        data: {
          productId: item.productId,
          quantity: item.quantity,
          price: item.price * item.quantity,
          source: 'Website',
          orderId: order.id,
          customerName: order.shippingAddress?.fullName || null,
          customerEmail: order.shippingAddress?.email || null,
          customerPhone: order.shippingAddress?.phone || null,
          paymentMode: 'Razorpay',
          paymentId: razorpay_payment_id,
          variantTitle: item.variantTitle || null
        }
      })
    ));

    // Send emails & notifications
    try {
      await notifyPaymentSuccess(order);
      await logActivity(order.id, 'PAYMENT_RECEIVED', `Payment of ₹${paidAmount} verified.`);
      
      const emailToSend = order.shippingAddress?.email || orderData.customerEmail || null;
      if (emailToSend) {
        await sendMail(emailToSend, 'Order Confirmation - Little Threads', TEMPLATES.ORDER_CONFIRMATION());
        // Generate and send invoice
        const invoiceBuffer = await generateInvoice(order);
        if (invoiceBuffer) {
          const subject = `Invoice for Order #${order.invoiceNumber || order.id.slice(-6).toUpperCase()}`;
          const text = TEMPLATES.INVOICE(order.invoiceNumber || order.id);
          await sendInvoiceEmail(emailToSend, subject, text, invoiceBuffer);
        }
      }
    } catch (notifyErr) {
      logger.error('payments.verify.post_actions.error', {
        order_id: order.id,
        error: notifyErr.message
      });
    }

    // Auto-create shipment + AWB + pickup after successful payment (recommended for production)
    const autoShipExplicit = String(
      process.env.SHIPROCKET_AUTO_CREATE_SHIPMENT ||
      process.env.SHIPROCKET_ENABLE_AUTO_SHIPPING ||
      ''
    ).trim().toLowerCase();
    const shouldAutoShip =
      autoShipExplicit === 'true' ||
      (autoShipExplicit !== 'false' && process.env.NODE_ENV === 'production');

    if (shouldAutoShip) {
      try {
        const shippingResult = await shippingService.createShipment({ orderId: order.id });
        logger.info('payments.verify.shipping.auto_ship.success', {
          order_id: order.id,
          created: Boolean(shippingResult?.created),
          awb: shippingResult?.shipment?.awb || null,
        });
      } catch (shipErr) {
        logger.error('payments.verify.shipping.auto_ship.failed', {
          order_id: order.id,
          message: shipErr?.message,
          stack: shipErr?.stack,
        });
      }
    }

    res.json({ message: "Payment verified and order created successfully", order });

  } catch (error) {
    // 🔥 NEW: Detailed error log
    logger.error('❌ VERIFY_PAYMENT_FAILED', {
      error: error.message,
      stack: error.stack,
      razorpay_order_id,
      razorpay_payment_id
    });

    logger.error('payments.verify.error', {
      user_id: req.user?.id || null,
      payment_id: razorpay_payment_id || null,
      razorpay_order_id: razorpay_order_id || null,
      error: error.message,
      stack: error.stack,
    });

    res.status(500).json({ message: "Internal server error" });
  }
};


export const cancelPayment = async (req, res) => {
  const { orderId, razorpay_order_id } = req.body || {};

  if (!orderId && !razorpay_order_id) {
    return res.status(400).json({ message: 'orderId or razorpay_order_id is required' });
  }

  const order = await prisma.order.findUnique({
    where: orderId ? { id: orderId } : { razorpayOrderId: razorpay_order_id },
    select: { id: true, customerId: true, status: true, paymentMethod: true, razorpayPaymentId: true }
  });

  if (!order) {
    return res.status(404).json({ message: 'Order not found' });
  }

  if (order.customerId && req.user?.id && order.customerId !== req.user.id) {
    return res.status(403).json({ message: 'Forbidden: You do not have access to this order' });
  }

  if (order.paymentMethod === 'cod') {
    return res.status(400).json({ message: 'COD payments cannot be cancelled via this endpoint' });
  }

  if (order.status === 'PAID' || order.razorpayPaymentId) {
    return res.status(400).json({ message: 'Paid orders cannot be cancelled' });
  }

  await prisma.order.update({
    where: { id: order.id },
    data: {
      status: 'CANCELED',
      cancellationReason: 'Cancelled before payment completion',
    },
  });

  logger.info('payments.cancel.marked_canceled', {
    user_id: req.user?.id || null,
    payment_id: order.razorpayPaymentId || null,
    order_id: order.id,
    status: 'CANCELED',
  });

  return res.json({ success: true });
};

export const confirmCODPayment = async (req, res) => {
  const { orderId } = req.body;

  if (!orderId) {
    return res.status(400).json({ message: 'orderId is required' });
  }

  try {
    const order = await prisma.order.findUnique({
      where: { id: orderId },
      include: {
        items: true
      }
    });

    if (!order) {
      return res.status(404).json({ message: 'Order not found' });
    }

    if (order.paymentMethod !== 'cod' && order.paymentMethod !== 'COD') {
      return res.status(400).json({ message: 'This order is not a COD order' });
    }

    // Accept legacy and current placed statuses for COD collection.
    if (!['COD_PENDING', 'PENDING', 'ORDERED'].includes(String(order.status || '').toUpperCase())) {
      return res.status(400).json({ message: 'Order is not in a COD-confirmable status' });
    }

    // Keep order lifecycle separate from payment collection.
    const updatedOrder = await prisma.order.update({
      where: { id: orderId },
      data: {
        status: 'COD_CONFIRMED',
        paymentStatus: 'PAID'
      }
    });

    // Log activity
    await logActivity(
      orderId,
      'COD_PAYMENT_CONFIRMED',
      'COD payment confirmed by admin. Order is now active.'
    );

    // Auto-create shipment + AWB + pickup after COD confirmation (treat as successful payment)
    const autoShipExplicit = String(
      process.env.SHIPROCKET_AUTO_CREATE_SHIPMENT ||
      process.env.SHIPROCKET_ENABLE_AUTO_SHIPPING ||
      ''
    ).trim().toLowerCase();
    const shouldAutoShip =
      autoShipExplicit === 'true' ||
      (autoShipExplicit !== 'false' && process.env.NODE_ENV === 'production');

    if (shouldAutoShip) {
      try {
        const shippingResult = await shippingService.createShipment({ orderId: order.id });
        logger.info('payments.cod.shipping.auto_ship.success', {
          order_id: order.id,
          created: Boolean(shippingResult?.created),
          awb: shippingResult?.shipment?.awb || null,
        });
      } catch (shipErr) {
        logger.error('payments.cod.shipping.auto_ship.failed', {
          order_id: order.id,
          message: shipErr?.message,
          stack: shipErr?.stack,
        });
      }
    }

    // Reduce inventory (don't fail payment if inventory reduction fails)
    try {
      await reduceInventory(orderId);
    } catch (inventoryError) {
      logger.error('payments.cod.inventory_reduce_failed', {
        order_id: orderId,
        error: inventoryError.message,
        stack: inventoryError.stack
      });
      // Continue - don't throw, payment is still valid
    }

    // Track the sale
    await Promise.all(order.items.map(item =>
      prisma.sale.create({
        data: {
          productId: item.productId,
          quantity: item.quantity,
          price: item.price,
          source: 'Website',
          orderId: order.id,
          customerName: `${order.shippingAddress?.firstName || ''} ${order.shippingAddress?.lastName || ''}`.trim() || null,
          customerEmail: order.shippingAddress?.email || null,
          customerPhone: order.shippingAddress?.phone || null,
          paymentMode: 'COD',
          paymentId: order.razorpayPaymentId || null
        }
      })
    ));

    // Send confirmation email to customer
    if (order.shippingAddress && typeof order.shippingAddress === 'object') {
      const destEmail = order.shippingAddress.email || null;
      if (destEmail) {
        await sendMail(destEmail, 'COD Payment Confirmed - Little Threads', 'Your COD order has been confirmed and will be processed soon.');
      }
    }

    res.json({ 
      message: 'COD payment confirmed successfully', 
      order: updatedOrder 
    });
  } catch (error) {
    console.error('Error confirming COD payment:', error);
    res.status(500).json({ message: 'Internal server error' });
  }
};
