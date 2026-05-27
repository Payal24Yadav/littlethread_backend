import fetch from 'node-fetch';

async function testPayment() {
  const payload = {
    amount: 1000,
    currency: 'INR',
    items: [{
      productId: '3e146278-bb34-453b-80c4-f9f726cf12e2',
      productName: 'Little Star Sleepsuit',
      quantity: 1,
      price: 1000,
      variantTitle: 'M'
    }],
    customerEmail: 'test@example.com',
    customerName: 'Test User',
    paymentMethod: 'razorpay',
    shippingAddress: {
      firstName: 'Test',
      lastName: 'User',
      email: 'test@example.com',
      phone: '9876543210',
      address: '123 Test St',
      apartment: 'Apt 1',
      city: 'Test City',
      state: 'TS',
      pinCode: '123456'
    }
  };

  try {
    console.log('Sending payment request...');
    console.log('Payload:', JSON.stringify(payload, null, 2));

    const response = await fetch('http://localhost:5000/api/payments/create', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(payload)
    });

    const data = await response.text();
    console.log('Status:', response.status);
    console.log('Response:', data);

    if (response.ok) {
      const json = JSON.parse(data);
      console.log('✅ Payment order created:');
      console.log('Order ID:', json.id);
      console.log('Amount:', json.amount);
      console.log('Currency:', json.currency);
    } else {
      console.log('❌ Error:', data);
    }
  } catch (error) {
    console.error('Error:', error.message);
  }
}

testPayment();
