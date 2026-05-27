import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';
import { optimizeImage } from '../utils/imageOptimizer.js';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

export const uploadImage = async (req, res) => {
  try {
    const file = req.file;
    if (!file) {
      return res.status(400).json({ error: "No file uploaded" });
    }

    const absolutePath = path.resolve(file.path);
    
    // Optimize the image
    const result = await optimizeImage(absolutePath);

    res.json({
      message: 'File uploaded and optimized successfully',
      url: result.optimizedUrl,
      thumbnailUrl: result.thumbnailUrl,
      originalUrl: result.originalUrl,
      filename: file.filename
    });
  } catch (err) {
    console.error('Local upload error:', err);
    res.status(500).json({ 
      error: "Server error during upload", 
      message: err.message 
    });
  }
};

export const deleteImage = async (req, res) => {
  try {
    const { url, path: filePath } = req.body;
    if (!url && !filePath) {
      return res.status(400).json({ error: "Image URL or path is required" });
    }

    let targetPath = filePath;

    if (!targetPath && url) {
      // Try to extract path from URL
      // Expected URL: http://localhost:5000/uploads/products/filename.jpg
      const urlObj = new URL(url);
      targetPath = urlObj.pathname.startsWith('/') ? urlObj.pathname.slice(1) : urlObj.pathname;
    }

    if (!targetPath) {
      return res.status(400).json({ error: "Could not resolve file path" });
    }

    // Security: Ensure the path is within the uploads directory
    const absolutePath = path.resolve(targetPath);
    const uploadsDir = path.resolve('uploads');

    if (!absolutePath.startsWith(uploadsDir)) {
      return res.status(403).json({ error: "Access denied" });
    }

    if (fs.existsSync(absolutePath)) {
      fs.unlinkSync(absolutePath);
      res.json({ message: "Image deleted successfully from local storage" });
    } else {
      res.status(404).json({ error: "File not found" });
    }
  } catch (err) {
    console.error('Delete image controller error:', err);
    res.status(500).json({ 
      error: "Internal server error during deletion", 
      message: err.message 
    });
  }
};
