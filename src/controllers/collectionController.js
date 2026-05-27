import prisma from '../utils/prisma.js';
import { appendCollectionImageVersion, appendProductImageVersions } from '../utils/imageUrl.js';
import { withTotalStock, withComputedPricing } from './productController.js';

const isUuid = (value) => /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i.test(value);
const slugify = (value = '') => value.toLowerCase().trim().replace(/[^a-z0-9]+/g, '-').replace(/^-+|-+$/g, '');

export const getCollections = async (req, res) => {
  const page = Math.max(1, parseInt(req.query.page, 10) || 1);
  const limit = Math.min(100, Math.max(1, parseInt(req.query.limit, 10) || 20));
  const skip = (page - 1) * limit;

  try {
    const paginationEnabled = req.query.page || req.query.limit;

    if (!prisma || !prisma.collection) {
      throw new Error('Prisma client is not initialized (collection).');
    }

    const collections = await prisma.collection.findMany({
      include: {
        _count: {
          select: { products: true }
        }
      },
      skip,
      take: limit,
      orderBy: { order: 'asc' }
    });

    const normalized = collections
      .slice()
      .sort((a, b) => (a.order ?? Number.MAX_SAFE_INTEGER) - (b.order ?? Number.MAX_SAFE_INTEGER))
      .map((c) => appendCollectionImageVersion({
        id: c.id,
        name: c.name,
        description: c.description,
        imageUrl: c.imageUrl,
        img: c.imageUrl,
        order: c.order ?? 0,
        createdAt: c.createdAt,
        updatedAt: c.updatedAt,
        productsCount: c._count?.products ?? 0,
        products: [],
      }));

    if (!paginationEnabled) {
      return res.json(normalized);
    }

    const total = await prisma.collection.count();

    res.json({
      data: normalized,
      meta: {
        page,
        limit,
        total,
        totalPages: Math.ceil(total / limit)
      }
    });
  } catch (error) {
    // fallback for old schema or missing order field.
    if (/Unknown argument `order`/.test(error.message)) {
      try {
        const collections = await prisma.collection.findMany({
          include: { _count: { select: { products: true } } },
          skip,
          take: limit,
          orderBy: { createdAt: 'desc' }
        });

        const normalized = collections.map((c) => appendCollectionImageVersion({
          ...c,
          img: c.imageUrl,
          productsCount: c._count?.products ?? 0,
          products: []
        }));

        const total = await prisma.collection.count();

        return res.json({
          data: normalized,
          meta: { page, limit, total, totalPages: Math.ceil(total / limit) }
        });
      } catch (err) {
        return res.status(500).json({ error: err.message });
      }
    }

    res.status(500).json({ error: error.message });
  }
};

export const createCollection = async (req, res) => {
  try {
    const { name, description, imageUrl } = req.body;
    
    // Check for existing collection with same name
    const existing = await prisma.collection.findUnique({
      where: { name }
    });

    if (existing) {
      return res.status(400).json({ message: 'Collection already exists with this name' });
    }

    // Get the highest order number
    const collection = await prisma.collection.create({
      data: { name, description, imageUrl }
    });
    res.json(appendCollectionImageVersion(collection));
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

export const updateCollection = async (req, res) => {
  try {
    const { name, description, imageUrl } = req.body;
    const collection = await prisma.collection.update({
      where: { id: req.params.id },
      data: { name, description, imageUrl }
    });
    res.json(appendCollectionImageVersion(collection));
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

export const getCollectionById = async (req, res) => {
  try {
    const lookup = req.params.id;
    const includeQuery = {
      products: {
        include: {
          categories: { select: { id: true, name: true } },
          collections: { select: { id: true, name: true } },
          variants: true,
        }
      }
    };

    const mapProducts = (col) => {
      if (col && col.products) {
        col.products = col.products.map(p =>
          withComputedPricing(withTotalStock(appendProductImageVersions(p)))
        );
      }
      return appendCollectionImageVersion(col);
    };

    const collection = await prisma.collection.findUnique({
      where: isUuid(lookup) ? { id: lookup } : undefined,
      include: includeQuery,
    });

    if (collection) {
      return res.json(mapProducts(collection));
    }

    const slugMatch = await prisma.collection.findFirst({
      where: {
        name: {
          in: [lookup, lookup.replace(/-/g, ' ')],
        }
      },
      include: includeQuery,
    });

    if (slugMatch) {
      return res.json(mapProducts(slugMatch));
    }

    const allCollections = await prisma.collection.findMany({
      select: {
        id: true,
        name: true,
        description: true,
        imageUrl: true
      }
    });

    const normalizedMatch = allCollections.find((item) => slugify(item.name) === slugify(lookup));
    if (!normalizedMatch) {
      return res.status(404).json({ message: 'Collection not found' });
    }

    const resolvedCollection = await prisma.collection.findUnique({
      where: { id: normalizedMatch.id },
      include: includeQuery,
    });

    return res.json(mapProducts(resolvedCollection));
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

export const deleteCollection = async (req, res) => {
  try {
    await prisma.collection.delete({
      where: { id: req.params.id }
    });
    res.json({ message: 'Collection deleted' });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};
export const reorderCollections = async (req, res) => {
  const { items } = req.body; // Array of { id, order }
  try {
    await Promise.all(
      items.map((item) =>
        prisma.collection.update({
          where: { id: item.id },
          data: { order: item.order },
        })
      )
    );
    res.json({ message: 'Collections reordered' });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};
