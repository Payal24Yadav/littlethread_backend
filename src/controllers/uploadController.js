import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';
import { optimizeImage } from '../utils/imageOptimizer.js';
import {
  buildStorageObjectPath,
  deleteFileFromSupabaseUrl,
  isSupabaseStorageConfigured,
  uploadFileToSupabase,
} from '../utils/supabaseStorage.js';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const removeIfExists = async (filePath) => {
  if (!filePath) return;
  try {
    if (fs.existsSync(filePath)) {
      await fs.promises.unlink(filePath);
    }
  } catch (error) {
    console.warn('Temporary upload cleanup failed:', error.message);
  }
};

const contentTypeFor = (filePath, fallback = 'application/octet-stream') => {
  const ext = path.extname(filePath).toLowerCase();
  if (ext === '.webp') return 'image/webp';
  if (ext === '.png') return 'image/png';
  if (ext === '.jpg' || ext === '.jpeg') return 'image/jpeg';
  if (ext === '.gif') return 'image/gif';
  if (ext === '.pdf') return 'application/pdf';
  return fallback;
};

const localUrlToPath = (url) => {
  if (!url) return null;
  try {
    const parsed = new URL(url);
    return parsed.pathname.startsWith('/uploads/') ? parsed.pathname.slice(1) : null;
  } catch {
    return url.startsWith('/uploads/') ? url.slice(1) : null;
  }
};

export const uploadImage = async (req, res) => {
  try {
    const file = req.file;
    if (!file) {
      return res.status(400).json({ error: "No file uploaded" });
    }

    const absolutePath = path.resolve(file.path);
    
    // Optimize the image
    const result = await optimizeImage(absolutePath);
    const uploadFolder = path.basename(path.dirname(absolutePath)) || 'products';

    if (isSupabaseStorageConfigured()) {
      const optimizedPath = path.resolve(localUrlToPath(result.optimizedUrl) || absolutePath);
      const thumbnailPath = path.resolve(localUrlToPath(result.thumbnailUrl) || optimizedPath);
      const originalPath = path.resolve(localUrlToPath(result.originalUrl) || absolutePath);

      const [optimizedUrl, thumbnailUrl, originalUrl] = await Promise.all([
        uploadFileToSupabase(
          optimizedPath,
          buildStorageObjectPath(uploadFolder, path.basename(optimizedPath)),
          contentTypeFor(optimizedPath, file.mimetype)
        ),
        uploadFileToSupabase(
          thumbnailPath,
          buildStorageObjectPath(uploadFolder, path.basename(thumbnailPath)),
          contentTypeFor(thumbnailPath, file.mimetype)
        ),
        uploadFileToSupabase(
          originalPath,
          buildStorageObjectPath(uploadFolder, path.basename(originalPath)),
          contentTypeFor(originalPath, file.mimetype)
        ),
      ]);

      await Promise.all([
        removeIfExists(absolutePath),
        removeIfExists(optimizedPath),
        removeIfExists(thumbnailPath),
      ]);

      return res.json({
        message: 'File uploaded and optimized successfully',
        url: optimizedUrl,
        thumbnailUrl,
        originalUrl,
        filename: path.basename(optimizedPath),
        storage: 'supabase',
      });
    }

    console.warn('SUPABASE_URL/SUPABASE_SERVICE_ROLE_KEY not configured. Falling back to local uploads; files may disappear on Render after restart/redeploy.');

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

    if (url && await deleteFileFromSupabaseUrl(url)) {
      return res.json({ message: "Image deleted successfully from Supabase storage" });
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
