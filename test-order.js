import 'dotenv/config';
import prisma from './src/utils/prisma.js';

async function test() {
  try {
    await prisma.order.create({
      data: {
        totalAmount: 150,
        status: "PENDING",
        customerId: "44c63690-302c-4a53-b2a4-627b6b8e6b14",
        razorpayOrderId: "order_SdlGoSVKuODvcK",
        paymentMethod: "razorpay",
        shippingAddress: {},
        items: {
          create: [
            { productId: "some-id", quantity: 1, price: 150 }
          ]
        }
      }
    });
  } catch (error) {
    console.log("FORMATTED ERROR:");
    console.log(error.message);
  }
}
test();
