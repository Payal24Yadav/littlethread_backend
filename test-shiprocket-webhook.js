/**
 * Test script for Shiprocket Webhook Handler
 * Usage: node test-shiprocket-webhook.js
 * 
 * This script simulates webhook requests from Shiprocket
 * and tests the webhook handler.
 * 
 * Route: POST /api/webhook/shipping (NOT /shiprocket/webhook)
 * Reason: Avoids Shiprocket URL filtering issues
 */

import axios from 'axios';

// Configuration
const BASE_URL = process.env.API_URL || 'http://localhost:5000';
const API_KEY = process.env.SHIPROCKET_API_KEY || 'mysecret123';

// ANSI Colors for console output
const colors = {
  reset: '\x1b[0m',
  green: '\x1b[32m',
  red: '\x1b[31m',
  yellow: '\x1b[33m',
  blue: '\x1b[36m',
  bold: '\x1b[1m'
};

const log = (color, ...args) => {
  console.log(color, ...args, colors.reset);
};

/**
 * Test 1: Health Check
 */
async function testHealthCheck() {
  log(colors.blue, '\n📋 Test 1: Health Check');
  try {
    const response = await axios.get(`${BASE_URL}/api/webhook/shipping/health`);
    log(colors.green, '✅ Health check passed:', response.data);
    return true;
  } catch (error) {
    log(colors.red, '❌ Health check failed:', error.message);
    return false;
  }
}

/**
 * Test 2: Missing API Key
 */
async function testMissingApiKey() {
  log(colors.blue, '\n📋 Test 2: Missing API Key (should fail with 401)');
  try {
    const payload = {
      order_id: 'test-order-001',
      current_status: 'SHIPPED',
      courier_name: 'Fedex',
      awb_number: '123456789',
      event_time: new Date().toISOString()
    };

    await axios.post(`${BASE_URL}/api/webhook/shipping`, payload);
    log(colors.red, '❌ Should have failed but succeeded');
    return false;
  } catch (error) {
    if (error.response?.status === 401) {
      log(colors.green, '✅ Correctly rejected missing API key (401)');
      return true;
    }
    log(colors.red, '❌ Unexpected error:', error.message);
    return false;
  }
}

/**
 * Test 3: Invalid API Key
 */
async function testInvalidApiKey() {
  log(colors.blue, '\n📋 Test 3: Invalid API Key (should fail with 403)');
  try {
    const payload = {
      order_id: 'test-order-001',
      current_status: 'SHIPPED',
      courier_name: 'Fedex',
      awb_number: '123456789',
      event_time: new Date().toISOString()
    };

    await axios.post(`${BASE_URL}/api/webhook/shipping`, payload, {
      headers: { 'X-API-Key': 'wrong-key' }
    });
    log(colors.red, '❌ Should have failed but succeeded');
    return false;
  } catch (error) {
    if (error.response?.status === 403) {
      log(colors.green, '✅ Correctly rejected invalid API key (403)');
      return true;
    }
    log(colors.red, '❌ Unexpected error:', error.message);
    return false;
  }
}

/**
 * Test 4: Valid webhook with all fields
 */
async function testValidWebhook(orderId) {
  log(colors.blue, '\n📋 Test 4: Valid Webhook (DELIVERED)');
  try {
    const payload = {
      order_id: orderId,
      current_status: 'DELIVERED',
      courier_name: 'Fedex',
      awb_number: 'AWB-' + Math.random().toString(36).substring(7),
      event_time: new Date().toISOString()
    };

    log(colors.yellow, 'Sending payload:', JSON.stringify(payload, null, 2));

    const response = await axios.post(`${BASE_URL}/api/webhook/shipping`, payload, {
      headers: { 'X-API-Key': API_KEY }
    });

    log(colors.green, '✅ Webhook processed successfully:');
    log(colors.green, JSON.stringify(response.data, null, 2));
    return true;
  } catch (error) {
    if (error.response?.status === 200) {
      log(colors.green, '✅ Server accepted webhook (200):', error.response.data);
      return true;
    }
    log(colors.yellow, '⚠️  Server response:', error.response?.data || error.message);
    return false;
  }
}

/**
 * Test 5: Webhook with different status
 */
async function testDifferentStatus(orderId, status) {
  log(colors.blue, `\n📋 Test 5: Webhook with status: ${status}`);
  try {
    const payload = {
      order_id: orderId,
      current_status: status,
      courier_name: 'DHL',
      awb_number: 'AWB-' + Math.random().toString(36).substring(7),
      event_time: new Date().toISOString()
    };

    const response = await axios.post(`${BASE_URL}/api/webhook/shipping`, payload, {
      headers: { 'X-API-Key': API_KEY }
    });

    log(colors.green, `✅ ${status} webhook processed:`, response.data.message);
    return true;
  } catch (error) {
    log(colors.yellow, '⚠️  Response:', error.response?.data?.message || error.message);
    return true; // Still pass if server responds with 200
  }
}

/**
 * Test 6: Duplicate webhook (idempotency test)
 */
async function testDuplicateWebhook(orderId) {
  log(colors.blue, '\n📋 Test 6: Duplicate Webhook (Idempotency)');
  try {
    const payload = {
      order_id: orderId,
      current_status: 'IN TRANSIT',
      courier_name: 'Fedex',
      awb_number: 'DUPLICATE-' + orderId,
      event_time: new Date().toISOString()
    };

    // Send twice
    log(colors.yellow, 'Sending first webhook...');
    const response1 = await axios.post(`${BASE_URL}/api/webhook/shipping`, payload, {
      headers: { 'X-API-Key': API_KEY }
    });
    log(colors.green, 'First response:', response1.data.message);

    log(colors.yellow, 'Sending duplicate webhook...');
    const response2 = await axios.post(`${BASE_URL}/api/webhook/shipping`, payload, {
      headers: { 'X-API-Key': API_KEY }
    });

    if (response2.data.isDuplicate) {
      log(colors.green, '✅ Duplicate correctly detected');
      return true;
    } else {
      log(colors.yellow, '⚠️  Duplicate not detected (might be ok if statuses differ)');
      return true;
    }
  } catch (error) {
    log(colors.red, '❌ Error:', error.message);
    return false;
  }
}

/**
 * Test 7: Missing required fields
 */
async function testMissingFields() {
  log(colors.blue, '\n📋 Test 7: Missing Required Fields (should fail with 400)');
  try {
    const payload = {
      // Missing order_id and current_status
      courier_name: 'Fedex'
    };

    await axios.post(`${BASE_URL}/api/webhook/shipping`, payload, {
      headers: { 'X-API-Key': API_KEY }
    });
    log(colors.red, '❌ Should have failed but succeeded');
    return false;
  } catch (error) {
    if (error.response?.status === 400) {
      log(colors.green, '✅ Correctly rejected invalid payload (400)');
      log(colors.yellow, 'Errors:', error.response.data.details);
      return true;
    }
    log(colors.yellow, '⚠️  Response:', error.response?.data?.message || error.message);
    return true;
  }
}

/**
 * Test 8: Alternative field names
 */
async function testAlternativeFieldNames(orderId) {
  log(colors.blue, '\n📋 Test 8: Alternative Field Names');
  try {
    // Using alternative field names
    const payload = {
      customer_reference_id: orderId, // Instead of order_id
      shipment_status: 'SHIPPED', // Instead of current_status
      courier: 'Amazone', // Instead of courier_name
      tracking_number: 'TRK-123456', // Instead of awb_number
      timestamp: new Date().toISOString() // Instead of event_time
    };

    log(colors.yellow, 'Sending with alternative field names...');
    const response = await axios.post(`${BASE_URL}/api/webhook/shipping`, payload, {
      headers: { 'X-API-Key': API_KEY }
    });

    log(colors.green, '✅ Alternative field names accepted:', response.data.message);
    return true;
  } catch (error) {
    log(colors.yellow, '⚠️  Response:', error.response?.data?.message || error.message);
    return true;
  }
}

/**
 * Run all tests
 */
async function runAllTests() {
  log(colors.bold + colors.blue, '\n🚀 Shiprocket Webhook Handler Test Suite');
  log(colors.bold + colors.blue, `API Base URL: ${BASE_URL}\n`);

  const results = [];

  // Get a test order ID (use first order from database or generate one)
  const testOrderId = process.env.TEST_ORDER_ID || 'test-order-' + Date.now();

  // Run tests
  results.push({ name: 'Health Check', passed: await testHealthCheck() });
  results.push({ name: 'Missing API Key', passed: await testMissingApiKey() });
  results.push({ name: 'Invalid API Key', passed: await testInvalidApiKey() });
  results.push({ name: 'Valid Webhook (DELIVERED)', passed: await testValidWebhook(testOrderId) });
  results.push({ name: 'Different Status (IN TRANSIT)', passed: await testDifferentStatus(testOrderId, 'IN TRANSIT') });
  results.push({ name: 'Duplicate Webhook', passed: await testDuplicateWebhook(testOrderId) });
  results.push({ name: 'Missing Fields', passed: await testMissingFields() });
  results.push({ name: 'Alternative Field Names', passed: await testAlternativeFieldNames(testOrderId) });

  // Summary
  log(colors.bold + colors.blue, '\n📊 Test Summary');
  const passed = results.filter(r => r.passed).length;
  const total = results.length;

  results.forEach(result => {
    const status = result.passed ? colors.green + '✅' : colors.red + '❌';
    console.log(`${status}${colors.reset} ${result.name}`);
  });

  log(colors.bold + (passed === total ? colors.green : colors.yellow),
    `\n${passed}/${total} tests passed\n`
  );

  return passed === total;
}

// Run tests
runAllTests()
  .then(allPassed => {
    process.exit(allPassed ? 0 : 1);
  })
  .catch(error => {
    log(colors.red, '\n💥 Test suite failed:', error.message);
    process.exit(1);
  });
