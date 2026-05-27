import { generateInvoice } from './src/utils/invoiceGenerator.js';
import prisma from './src/utils/prisma.js';
import fs from 'fs';

async function test() {
  try {
    console.log('Fetching first order from database...');
    const order = await prisma.order.findFirst({
      include: {
        customer: true,
        items: {
          include: {
            product: true
          }
        }
      }
    });

    if (!order) {
      console.log('No orders found in database to test with. Creating dummy data...');
      // Let's create a mock order structure for testing
      const mockOrder = {
        id: 'test-order-id-123456',
        invoiceNumber: 'LTF-2026-TEST',
        createdAt: new Date(),
        totalAmount: 1899.00,
        status: 'ORDERED',
        paymentStatus: 'PAID',
        paymentMethod: 'razorpay',
        razorpayPaymentId: 'pay_P1a2b3c4d5e6f7',
        razorpayOrderId: 'order_P1a2b3c4d5e6f7',
        shippingAddress: {
          fullName: 'Payal Sharma',
          email: 'payal@example.com',
          phone: '9876543210',
          address: 'Flat 402, Royal Residency, Road No. 4',
          apartment: 'Banjara Hills',
          city: 'Hyderabad',
          state: 'Telangana',
          pinCode: '500034'
        },
        items: [
          {
            id: 'item-1',
            productName: 'Soft Cotton Floral Summer Dress',
            variantTitle: '2-3 Years / Pastel Pink',
            quantity: 2,
            price: 799.00,
            product: {
              id: 'prod-1',
              name: 'Soft Cotton Floral Summer Dress',
              thumbnailUrl: 'https://images.unsplash.com/photo-1518837695005-2083093ee35b?w=100'
            }
          },
          {
            id: 'item-2',
            productName: 'Kids Linen Striped Shorts',
            variantTitle: '3-4 Years / Sky Blue',
            quantity: 1,
            price: 301.00,
            product: {
              id: 'prod-2',
              name: 'Kids Linen Striped Shorts',
              thumbnailUrl: null
            }
          }
        ]
      };

      console.log('Generating invoice PDF with mock data...');
      const pdfBuffer = await generateInvoice(mockOrder);
      fs.writeFileSync('invoice_mock_test.pdf', pdfBuffer);
      console.log('Success! Mock invoice PDF generated: invoice_mock_test.pdf');
    } else {
      console.log(`Found order ID: ${order.id}. Generating invoice PDF...`);
      const pdfBuffer = await generateInvoice(order.id);
      fs.writeFileSync('invoice_db_test.pdf', pdfBuffer);
      console.log(`Success! Database order invoice PDF generated: invoice_db_test.pdf`);
    }

  } catch (error) {
    console.error('Error generating test invoice:', error);
  } finally {
    await prisma.$disconnect();
  }
}

test();
