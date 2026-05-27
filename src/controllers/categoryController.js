import prisma from '../utils/prisma.js';
import { logger } from '../utils/logger.js';

export const getCategories = async (req, res) => {
  try {
    const categories = await prisma.category.findMany();
    return res.status(200).json({
      success: true,
      data: categories,
    });
  } catch (error) {
    logger.error('categories.list.error', { message: error?.message, stack: error?.stack });
    return res.status(500).json({
      success: false,
      message: 'Failed to fetch categories',
      error: process.env.NODE_ENV === 'development' ? error?.message : undefined,
    });
  }
};

export const getCategoryById = async (req, res) => {
  try {
    const category = await prisma.category.findUnique({
      where: { id: req.params.id },
      include: { products: true }
    });
    if (!category) return res.status(404).json({ message: 'Category not found' });
    return res.status(200).json({ success: true, data: category });
  } catch (error) {
    logger.error('categories.get.error', { id: req.params.id, message: error?.message, stack: error?.stack });
    return res.status(500).json({
      success: false,
      message: 'Failed to fetch category',
      error: process.env.NODE_ENV === 'development' ? error?.message : undefined,
    });
  }
};
export const createCategory = async (req, res) => {
  const requestId = `${Date.now()}-${Math.random().toString(36).slice(2, 8)}`;

  try {
    console.log('[categories.create] request received', {
      requestId,
      body: req.body,
    });

    const name = typeof req.body?.name === 'string' ? req.body.name.trim() : '';
    const description = typeof req.body?.description === 'string' ? req.body.description.trim() : undefined;

    if (!name) {
      console.warn('[categories.create] validation failed', {
        requestId,
        reason: 'missing_name',
      });

      return res.status(400).json({
        success: false,
        message: 'Category name is required',
      });
    }

    if (name.length > 191) {
      console.warn('[categories.create] validation failed', {
        requestId,
        reason: 'name_too_long',
        length: name.length,
      });

      return res.status(400).json({
        success: false,
        message: 'Category name is too long',
      });
    }

    const existingCategory = await prisma.category.findUnique({
      where: { name },
    });

    if (existingCategory) {
      console.warn('[categories.create] duplicate category blocked before create', {
        requestId,
        categoryId: existingCategory.id,
        name,
      });

      return res.status(400).json({
        success: false,
        message: 'Category already exists',
      });
    }

    console.log('[categories.create] creating category', {
      requestId,
      name,
    });

    const category = await prisma.category.create({
      data: {
        name,
        description: description || null,
      },
    });

    console.log('[categories.create] category created', {
      requestId,
      categoryId: category.id,
      name: category.name,
    });

    return res.status(201).json({
      success: true,
      message: 'Category created successfully',
      data: category,
    });
  } catch (error) {
    if (error?.code === 'P2002') {
      console.warn('[categories.create] duplicate category blocked by Prisma', {
        requestId,
        target: error?.meta?.target,
      });

      return res.status(400).json({
        success: false,
        message: 'Category already exists',
      });
    }

    console.error('[categories.create] unhandled error', {
      requestId,
      message: error?.message,
      code: error?.code,
      stack: error?.stack,
    });
    logger.error('categories.create.error', { requestId, code: error?.code, message: error?.message, stack: error?.stack });

    return res.status(500).json({
      success: false,
      message: 'Failed to create category',
      error: process.env.NODE_ENV === 'development' ? error?.message : undefined,
    });
  }
};

export const deleteCategory = async (req, res) => {
  try {
    await prisma.category.delete({
      where: { id: req.params.id }
    });
    return res.status(200).json({ success: true, message: 'Category deleted' });
  } catch (error) {
    logger.error('categories.delete.error', { id: req.params.id, message: error?.message, stack: error?.stack });
    return res.status(500).json({
      success: false,
      message: 'Failed to delete category',
      error: process.env.NODE_ENV === 'development' ? error?.message : undefined,
    });
  }
};
