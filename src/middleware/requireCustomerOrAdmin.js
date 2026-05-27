import jwt from 'jsonwebtoken';
const JWT_SECRET = process.env.JWT_SECRET || 'default-secret';

export const requireCustomerOrAdmin = async (req, res, next) => {
  // Check cookies first
  const customerToken = req.cookies?.token;
  const adminToken = req.cookies?.adminToken;
  
  // Authorization header fallback
  const authHeader = req.headers.authorization;
  const headerToken = authHeader?.startsWith('Bearer ') ? authHeader.slice(7) : null;

  const token = customerToken || adminToken || headerToken;

  if (!token) {
    return res.status(401).json({ message: 'Unauthorized: Missing token' });
  }

  try {
    const decoded = jwt.verify(token, JWT_SECRET);
    
    // Check if it's an admin token
    if (decoded.role === 'admin' || token === adminToken) {
      req.user = decoded;
      req.auth = { type: 'admin', id: decoded.id };
      return next();
    }

    // Check if it's a customer token
    if (decoded.role === 'customer' || token === customerToken) {
      req.user = decoded;
      req.auth = { type: 'customer', id: decoded.id };
      return next();
    }

    return res.status(401).json({ message: 'Unauthorized: Invalid role' });
  } catch (error) {
    return res.status(401).json({ message: 'Unauthorized: Authentication failed' });
  }
};

