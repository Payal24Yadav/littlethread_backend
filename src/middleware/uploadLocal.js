import multer from 'multer';
import path from 'path';
import fs from 'fs';

const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    // Determine folder based on route or custom field
    let folder = 'uploads/';
    const type = req.body.uploadType || req.query.uploadType || 'general';
    
    switch (type) {
      case 'product':
        folder += 'products/';
        break;
      case 'collection':
        folder += 'collections/';
        break;
      case 'category':
        folder += 'categories/';
        break;
      case 'user':
        folder += 'users/';
        break;
      case 'invoice':
        folder += 'invoices/';
        break;
      default:
        folder += 'products/'; // Default to products for safety
    }

    if (!fs.existsSync(folder)) {
      fs.mkdirSync(folder, { recursive: true });
    }
    cb(null, folder);
  },
  filename: (req, file, cb) => {
    const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1e9);
    const ext = path.extname(file.originalname);
    const name = file.originalname.replace(ext, '').toLowerCase().replace(/[^a-z0-9]/g, '-');
    cb(null, `${name}-${uniqueSuffix}${ext}`);
  },
});

const fileFilter = (req, file, cb) => {
  const allowedTypes = ['image/jpeg', 'image/png', 'image/webp', 'image/gif', 'application/pdf'];
  if (allowedTypes.includes(file.mimetype)) {
    cb(null, true);
  } else {
    cb(new Error('Invalid file type. Only images and PDFs are allowed.'), false);
  }
};

const uploadLocal = multer({
  storage,
  fileFilter,
  limits: {
    fileSize: 10 * 1024 * 1024, // 10MB limit
  },
});

export default uploadLocal;
