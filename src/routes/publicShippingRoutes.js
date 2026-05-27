import express from 'express';
import prisma from '../utils/prisma.js';
import * as shippingService from '../services/shippingService.js';

const router = express.Router();

/**
 * Public tracking endpoint for customers.
 * GET /api/public/shipping/track/:awb
 */
router.get('/track/:awb', async (req, res) => {
  try {
    const awb = String(req.params.awb || '').trim();
    if (!awb) {
      return res.status(400).json({ success: false, message: 'awb is required' });
    }

    const tracking = await shippingService.trackShipment({ awb });
    return res.status(200).json({ success: true, tracking });
  } catch (error) {
    return res.status(error?.statusCode || 500).json({
      success: false,
      message: error?.message || 'Failed to fetch tracking',
      details: error?.details || null,
    });
  }
});

/**
 * Public timeline from persisted events (webhook + polls).
 * GET /api/public/shipping/timeline/:awb
 */
router.get('/timeline/:awb', async (req, res) => {
  const awb = String(req.params.awb || '').trim();
  if (!awb) {
    return res.status(400).json({ success: false, message: 'awb is required' });
  }

  const events = await prisma.shipmentTrackingEvent.findMany({
    where: { awb },
    orderBy: { eventTime: 'asc' },
    take: 200,
    select: {
      id: true,
      status: true,
      source: true,
      eventTime: true,
      raw: true,
    },
  });

  return res.status(200).json({ success: true, data: events });
});

/**
 * Public: fetch basic shipment record by AWB (for downloads/links).
 * GET /api/public/shipping/shipment/:awb
 */
router.get('/shipment/:awb', async (req, res) => {
  const awb = String(req.params.awb || '').trim();
  if (!awb) {
    return res.status(400).json({ success: false, message: 'awb is required' });
  }

  const shipment = await prisma.shipment.findFirst({
    where: { awb },
    select: {
      orderId: true,
      shipmentId: true,
      awb: true,
      courier: true,
      status: true,
      labelUrl: true,
      pickupId: true,
      createdAt: true,
      updatedAt: true,
    },
  });

  if (!shipment) {
    return res.status(404).json({ success: false, message: 'Shipment not found' });
  }

  return res.status(200).json({ success: true, data: shipment });
});

/**
 * Public: generate or return label URL by AWB.
 * GET /api/public/shipping/label/:awb
 */
router.get('/label/:awb', async (req, res) => {
  try {
    const awb = String(req.params.awb || '').trim();
    if (!awb) {
      return res.status(400).json({ success: false, message: 'awb is required' });
    }

    const shipment = await prisma.shipment.findFirst({
      where: { awb },
      select: { shipmentId: true, orderId: true, labelUrl: true },
    });

    if (!shipment) {
      return res.status(404).json({ success: false, message: 'Shipment not found' });
    }

    if (shipment.labelUrl) {
      return res.status(200).json({ success: true, label_url: shipment.labelUrl, shipment });
    }

    const result = await shippingService.generateLabel({ shipmentId: shipment.shipmentId });
    return res.status(200).json({ success: true, label_url: result.label_url, shipment: result.shipment });
  } catch (error) {
    return res.status(error?.statusCode || 500).json({
      success: false,
      message: error?.message || 'Failed to generate label',
      details: error?.details || null,
    });
  }
});

export default router;
