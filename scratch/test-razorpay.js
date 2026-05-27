import dotenv from 'dotenv';
dotenv.config();
import Razorpay from 'razorpay';

console.log('Key ID:', process.env.RAZORPAY_KEY_ID);
console.log('Key Secret:', process.env.RAZORPAY_KEY_SECRET);

const razorpay = new Razorpay({
  key_id: process.env.RAZORPAY_KEY_ID,
  key_secret: process.env.RAZORPAY_KEY_SECRET,
});

async function run() {
  try {
    const order = await razorpay.orders.create({
      amount: 1000,
      currency: 'INR',
      receipt: 'test_receipt',
    });
    console.log('SUCCESS:', order);
  } catch (err) {
    console.error('ERROR:', err);
  }
}

run();
