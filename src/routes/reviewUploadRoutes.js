import express from 'express';
import uploadLocal from '../middleware/uploadLocal.js';
import { optimizeImage } from '../utils/imageOptimizer.js';
import fs from 'fs';
import path from 'path';

const router = express.Router();

// Support multiple images for reviews (up to 5)
router.post('/upload', uploadLocal.array('images', 5), async (req, res) => {
  try {
    const files = req.files;
    if (!files || files.length === 0) {
      return res.status(400).json({ error: 'No images uploaded' });
    }

    const uploadPromises = files.map(async (file) => {
      const absolutePath = path.resolve(file.path);
      const result = await optimizeImage(absolutePath);
      return result.optimizedUrl; // or result.thumbnailUrl depending on use case
    });

    const imageUrls = await Promise.all(uploadPromises);
    res.json({ urls: imageUrls });

  } catch (error) {
    console.error('Review image upload error:', error);
    res.status(500).json({ error: 'Failed to upload images', details: error.message });
  }
});

export default router;
