import sharp from 'sharp';
import path from 'path';
import fs from 'fs';

/**
 * Optimizes an image by resizing and converting to WebP.
 * @param {string} filePath - Absolute path to the original file.
 * @param {string} targetFolder - The folder to save optimized versions.
 * @returns {Promise<{thumbnailUrl: string, hoverThumbnailUrl: string, originalUrl: string}>}
 */
export const optimizeImage = async (filePath) => {
  const ext = path.extname(filePath);
  const baseName = path.basename(filePath, ext);
  const dirName = path.dirname(filePath);

  const optimizedName = `${baseName}_optimized.webp`;
  const thumbName = `${baseName}_thumb.webp`;
  
  const optimizedPath = path.join(dirName, optimizedName);
  const thumbPath = path.join(dirName, thumbName);
  const relativeDir = dirName.split(path.sep).slice(-1)[0]; // e.g., 'products'
  const baseUrl = process.env.API_BASE_URL || 'http://localhost:5000';
  const originalUrl = `${baseUrl}/uploads/${relativeDir}/${path.basename(filePath)}`;
  const isGif = ext.toLowerCase() === '.gif';

  if (isGif) {
    return {
      optimizedUrl: originalUrl,
      thumbnailUrl: originalUrl,
      originalUrl,
    };
  }

  try {
    // 1. Create Main Optimized Image (max 1200px)
    await sharp(filePath)
      .resize(1200, null, { withoutEnlargement: true })
      .webp({ quality: 80 })
      .toFile(optimizedPath);

    // 2. Create Small Thumbnail (300px)
    await sharp(filePath)
      .resize(300, 400, { fit: 'cover' }) // Consistent aspect ratio for thumbnails
      .webp({ quality: 70 })
      .toFile(thumbPath);

    return {
      optimizedUrl: `${baseUrl}/uploads/${relativeDir}/${optimizedName}`,
      thumbnailUrl: `${baseUrl}/uploads/${relativeDir}/${thumbName}`,
      originalUrl,
    };
  } catch (error) {
    console.error('Sharp optimization error:', error);
    // If optimization fails, return the original URL
    const relativeDir = dirName.split(path.sep).slice(-1)[0];
    const baseUrl = process.env.API_BASE_URL || 'http://localhost:5000';
    const url = `${baseUrl}/uploads/${relativeDir}/${path.basename(filePath)}`;
    return { optimizedUrl: url, thumbnailUrl: url, originalUrl: url };
  }
};
