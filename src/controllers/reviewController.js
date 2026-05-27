import prisma from '../utils/prisma.js';
import { appendImageVersionToArray } from '../utils/imageUrl.js';

export const createReview = async (req, res) => {
  try {
    let { rating, comment, userName, name, userEmail, email, userPhone, mobile, phone, productId, images } = req.body;
    
    // Support aliases
    const finalUserName = userName || name || 'Anonymous';
    const finalUserEmail = userEmail || email || null; // Avoid anonymous@example.com
    const finalUserPhone = userPhone || mobile || phone || null;
    const finalImages = Array.isArray(images) ? images : [];

    // Resolve productId if it's a handle
    const isUuid = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i.test(productId);
    if (!isUuid) {
      const product = await prisma.product.findUnique({ where: { handle: productId } });
      if (product) productId = product.id;
    }

    // Check if user has already reviewed this product
    if (finalUserEmail) {
      const emailToCheck = finalUserEmail.trim().toLowerCase();
      
      console.log(`[Review] Checking existing review for Product: ${productId}, Email: ${emailToCheck}`);
      
      const existingReview = await prisma.review.findFirst({
        where: {
          productId: productId,
          userEmail: {
            equals: emailToCheck,
              
          }
        }
      });

      if (existingReview) {
        return res.status(400).json({ error: "You have already submitted a review for this product." });
      }
    }

    const review = await prisma.review.create({
      data: {
        rating: parseInt(rating),
        comment,
        userName: finalUserName,
        userEmail: finalUserEmail,
        userPhone: finalUserPhone,
        images: finalImages,
        productId
      }
    });
    res.status(201).json({ ...review, images: appendImageVersionToArray(review.images) });
  } catch (error) {
    console.error('Create review error:', error);
    res.status(500).json({ error: error.message });
  }
};

export const getReviewsByProduct = async (req, res) => {
  try {
    let { productId } = req.params;
    
    // Resolve productId if it's a handle
    const isUuid = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i.test(productId);
    if (!isUuid) {
      const product = await prisma.product.findUnique({ where: { handle: productId } });
      if (product) productId = product.id;
      else return res.json([]); // If handle not found, return empty reviews
    }

    const reviews = await prisma.review.findMany({
      where: { productId },
      orderBy: { createdAt: 'desc' }
    });
    res.json(reviews.map((review) => ({ ...review, images: appendImageVersionToArray(review.images) })));
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

export const getAllReviews = async (req, res) => {
  try {
    const reviews = await prisma.review.findMany({
      include: { product: { select: { name: true } } },
      orderBy: { createdAt: 'desc' }
    });
    res.json(reviews.map((review) => ({ ...review, images: appendImageVersionToArray(review.images) })));
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

export const deleteReview = async (req, res) => {
  try {
    await prisma.review.delete({
      where: { id: req.params.id }
    });
    res.json({ message: "Review deleted" });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};
