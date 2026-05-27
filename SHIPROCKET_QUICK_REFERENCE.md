# Shiprocket Webhook Quick Reference

## Quick Setup (5 minutes)

### 1. Copy your API Key to .env
```bash
# In .env file, add:
SHIPROCKET_API_KEY=mysecret123
```

### 2. Webhook is automatically registered
The webhook routes are already integrated into your server at:
- `POST /api/webhook/shipping` - Main endpoint
- `GET /api/webhook/shipping/health` - Health check

**Note**: Route uses `/webhook/shipping` (NOT `/shiprocket/webhook`) to avoid Shiprocket URL filtering issues.

### 3. Test it
```bash
# Health check
curl http://localhost:5000/api/webhook/shipping/health

# Send test webhook
curl -X POST http://localhost:5000/api/webhook/shipping \
  -H "Content-Type: application/json" \
  -H "X-API-Key: mysecret123" \
  -d '{
    "order_id": "YOUR_ORDER_ID",
    "current_status": "DELIVERED",
    "courier_name": "Fedex",
    "awb_number": "123456789",
    "event_time": "2026-04-28T10:30:00Z"
  }'
```

Or use the test script:
```bash
npm run test:shiprocket
# OR
node test-shiprocket-webhook.js
```

## Integration with Shiprocket

1. Login to Shiprocket Dashboard
2. Go to Settings → Webhooks
3. Configure:
   - **URL**: `https://your-domain.com/api/webhook/shipping`
   - **Headers**:
     - Name: `X-API-Key`
     - Value: `mysecret123`

## Response Status Codes

Your webhook now returns proper HTTP status codes:

| Code | Meaning |
|------|---------|
| **200** | ✅ Webhook processed successfully |
| **400** | ❌ Invalid payload (missing fields) |
| **401** | ❌ Missing X-API-Key header |
| **403** | ❌ Invalid API key |
| **404** | ❌ Order not found in database |
| **500** | ❌ Server error during processing |

## Webhook Payload Format

Shiprocket sends updates like this:

```json
{
  "order_id": "550e8400-e29b-41d4-a716-446655440000",
  "current_status": "DELIVERED",
  "courier_name": "Fedex",
  "awb_number": "123456789",
  "event_time": "2026-04-28T10:30:00Z"
}
```

## Status Mapping

| Shiprocket | Internal |
|-----------|----------|
| SHIPPED | shipped |
| IN TRANSIT | in_transit |
| DELIVERED | delivered |
| RTO | returned |

## What Happens

1. ✅ Shiprocket sends webhook to `/api/webhook/shipping`
2. ✅ Your server validates X-API-Key
3. ✅ Webhook service extracts order_id and status
4. ✅ Finds order in database
5. ✅ Maps Shiprocket status to your status
6. ✅ Updates order with new status
7. ✅ Logs activity for tracking
8. ✅ Checks for duplicate updates (idempotency)
9. ✅ Returns appropriate status code (200/400/404/500)
10. ✅ Failed webhooks are logged for manual reprocessing

## Files Created

```
backend-api/
├── src/
│   ├── middleware/
│   │   └── validateShiprocketToken.js    ← API Key validation
│   ├── controllers/
│   │   └── shiprocketController.js       ← Request handlers
│   ├── routes/
│   │   └── shiprocketRoutes.js           ← Express routes (/api/webhook/shipping)
│   └── services/
│       └── shiprocketWebhookService.js   ← Business logic + failure logging
├── test-shiprocket-webhook.js            ← Test script
├── .env.shiprocket.example               ← Env template
└── SHIPROCKET_WEBHOOK_DOCS.md            ← Full documentation
```

## Production Checklist

- [ ] Set `SHIPROCKET_API_KEY` to strong token
- [ ] Verify database connection
- [ ] Test with Shiprocket sandbox first
- [ ] Monitor logs for errors
- [ ] Set up alerts for webhook failures
- [ ] Configure SSL/HTTPS for production URL
- [ ] Document with your team
- [ ] Update Shiprocket dashboard with new URL

## Troubleshooting

**Webhook not updating orders?**
- Check `SHIPROCKET_API_KEY` in .env
- Verify order_id matches database
- Check server logs for errors

**Getting 401 or 403 errors?**
- Confirm X-API-Key header is being sent
- Check API key matches .env value
- Verify header name (case-insensitive)

**Getting 404 errors?**
- Check that order_id exists in database
- Verify order ID format matches

**Database errors?**
- Ensure DATABASE_URL is configured
- Check Prisma client initialization
- Review database connection

## Common Webhook Scenarios

### Shipped Update
```json
{
  "order_id": "ORDER-123",
  "current_status": "SHIPPED",
  "courier_name": "Fedex",
  "awb_number": "ABC123",
  "event_time": "2026-04-28T10:00:00Z"
}
```
→ Returns: **200 OK**  
→ Order status → `shipped`

### Out for Delivery
```json
{
  "order_id": "ORDER-123",
  "current_status": "IN TRANSIT",
  "event_time": "2026-04-28T14:00:00Z"
}
```
→ Returns: **200 OK**  
→ Order status → `in_transit`

### Delivered
```json
{
  "order_id": "ORDER-123",
  "current_status": "DELIVERED",
  "event_time": "2026-04-28T18:00:00Z"
}
```
→ Returns: **200 OK**  
→ Order status → `delivered`

### Invalid Payload
```json
{
  "current_status": "DELIVERED"
  // Missing order_id
}
```
→ Returns: **400 Bad Request**  
→ No update applied

### Order Not Found
```json
{
  "order_id": "NONEXISTENT-ID",
  "current_status": "DELIVERED",
  "event_time": "2026-04-28T18:00:00Z"
}
```
→ Returns: **404 Not Found**  
→ Failed webhook is logged for manual inspection

## Next Steps

1. Read [SHIPROCKET_WEBHOOK_DOCS.md](./SHIPROCKET_WEBHOOK_DOCS.md) for full details
2. Update Shiprocket dashboard with: `https://your-domain.com/api/webhook/shipping`
3. Run test suite: `node test-shiprocket-webhook.js`
4. Monitor logs and verify updates
5. Set up error alerts for production

## Support

For questions or issues:
- Check logs: `grep -i shiprocket` on your server logs
- Review database: Verify Order table has status updates
- Test endpoint: GET `/api/webhook/shipping/health`
- Check network: Verify firewall allows webhook requests

---

**Last Updated**: 2026-04-28  
**Version**: 1.1 (Updated with proper status codes and failure logging)
**Status**: Production Ready ✅

## Webhook Payload Format

Shiprocket sends updates like this:

```json
{
  "order_id": "550e8400-e29b-41d4-a716-446655440000",
  "current_status": "DELIVERED",
  "courier_name": "Fedex",
  "awb_number": "123456789",
  "event_time": "2026-04-28T10:30:00Z"
}
```

## Status Mapping

| Shiprocket | Internal |
|-----------|----------|
| SHIPPED | shipped |
| IN TRANSIT | in_transit |
| DELIVERED | delivered |
| RTO | returned |

## What Happens

1. ✅ Shiprocket sends webhook
2. ✅ Your server validates X-API-Key
3. ✅ Webhook service extracts order_id and status
4. ✅ Finds order in database
5. ✅ Maps Shiprocket status to your status
6. ✅ Updates order with new status
7. ✅ Logs activity for tracking
8. ✅ Returns 200 OK immediately
9. ✅ Prevents duplicate updates (idempotency)

## Files Created

```
backend-api/
├── src/
│   ├── middleware/
│   │   └── validateShiprocketToken.js    ← API Key validation
│   ├── controllers/
│   │   └── shiprocketController.js       ← Request handlers
│   ├── routes/
│   │   └── shiprocketRoutes.js           ← Express routes
│   └── services/
│       └── shiprocketWebhookService.js   ← Business logic
├── test-shiprocket-webhook.js            ← Test script
├── .env.shiprocket.example               ← Env template
└── SHIPROCKET_WEBHOOK_DOCS.md            ← Full documentation
```

## Production Checklist

- [ ] Set `SHIPROCKET_API_KEY` to strong token
- [ ] Verify database connection
- [ ] Test with Shiprocket sandbox first
- [ ] Monitor logs for errors
- [ ] Set up alerts for webhook failures
- [ ] Configure SSL/HTTPS for production URL
- [ ] Document with your team

## Troubleshooting

**Webhook not updating orders?**
- Check `SHIPROCKET_API_KEY` in .env
- Verify order_id matches database
- Check server logs

**Getting 401 or 403 errors?**
- Confirm X-API-Key header is being sent
- Check API key matches .env value
- Verify header name (case-insensitive)

**Database errors?**
- Ensure DATABASE_URL is configured
- Check Prisma client initialization
- Review database connection

## Common Webhook Scenarios

### Shipped Update
```json
{
  "order_id": "ORDER-123",
  "current_status": "SHIPPED",
  "courier_name": "Fedex",
  "awb_number": "ABC123",
  "event_time": "2026-04-28T10:00:00Z"
}
```
→ Order status → `shipped`

### Out for Delivery
```json
{
  "order_id": "ORDER-123",
  "current_status": "IN TRANSIT",
  "event_time": "2026-04-28T14:00:00Z"
}
```
→ Order status → `in_transit`

### Delivered
```json
{
  "order_id": "ORDER-123",
  "current_status": "DELIVERED",
  "event_time": "2026-04-28T18:00:00Z"
}
```
→ Order status → `delivered`

### Return to Origin
```json
{
  "order_id": "ORDER-123",
  "current_status": "RTO",
  "event_time": "2026-04-28T20:00:00Z"
}
```
→ Order status → `returned`

## Next Steps

1. Read [SHIPROCKET_WEBHOOK_DOCS.md](./SHIPROCKET_WEBHOOK_DOCS.md) for full details
2. Run test suite: `node test-shiprocket-webhook.js`
3. Configure in Shiprocket Dashboard
4. Monitor logs and verify updates
5. Add customer notifications (optional)
6. Set up monitoring/alerts for production

## Support

For questions or issues:
- Check logs: `grep -i shiprocket` on your server logs
- Review database: Verify Order table has status updates
- Test endpoint: GET `/api/shiprocket/webhook/health`
- Check network: Verify firewall allows Shiprocket IPs

---

**Last Updated**: 2026-04-28  
**Status**: Production Ready ✅
