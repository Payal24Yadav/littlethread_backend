import fetch from 'node-fetch';
import crypto from 'crypto';
import { PrismaClient } from '@prisma/client';
import dotenv from 'dotenv';

dotenv.config();

const prisma = new PrismaClient();
const RAZORPAY_KEY_SECRET = process.env.RAZORPAY_KEY_SECRET;

async function testVerify() {
  try {
    // 1. Fetch a valid product from the database
    const product = await prisma.product.findFirst();
    if (!product) {
      console.error('No products found in the database. Please add a product first.');
      return;
    }
    console.log(`Found valid product: ${product.name} (ID: ${product.id})`);

    const razorpay_order_id = 'order_test_' + Math.random().toString(36).substring(7);
    const razorpay_payment_id = 'pay_test_' + Math.random().toString(36).substring(7);
    
    // Signature calculation: razorpay_order_id + "|" + razorpay_payment_id
    const sign = razorpay_order_id + "|" + razorpay_payment_id;
    const razorpay_signature = crypto
      .createHmac("sha256", RAZORPAY_KEY_SECRET)
      .update(sign.toString())
      .digest("hex");

    const payload = {
      razorpay_order_id,
      razorpay_payment_id,
      razorpay_signature,
      orderData: {
        amount: 1000,
        customerEmail: 'test@example.com',
        customerName: 'Test User',
        items: [{
          productId: product.id,
          productName: product.name,
          quantity: 1,
          price: 1000,
        }],
        shippingAddress: {
          firstName: 'Test',
          lastName: 'User',
          email: 'test@example.com',
          phone: '9876543210',
          address: '123 Test St',
          city: 'Test City',
          state: 'TS',
          pinCode: '123456'
        }
      }
    };

    console.log('Sending verify request...');
    const response = await fetch('http://localhost:5000/api/payments/verify', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(payload)
    });

    console.log('Status:', response.status);
    const data = await response.text();
    console.log('Response:', data);

  } catch (error) {
    console.error('Error:', error.message);
  } finally {
    await prisma.$disconnect();
  }
}

testVerify();
