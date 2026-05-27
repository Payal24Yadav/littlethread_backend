import prisma from '../utils/prisma.js';
import { appendProductImageVersions } from '../utils/imageUrl.js';
import csv from 'csv-parser';
import { Readable } from 'stream';
import { logger } from '../utils/logger.js';
import {
  trimValue,
  parseCsvArray,
  parseOptionalFloat,
  parseBoolean,
  generateSlug,
  isEmptyRow,
  parseTagArray,
  buildBrandConnectOrCreate,
  buildRelationalConnectOrCreate,
  validateImportRow,
  buildProductGroups,
} from '../utils/csvImportUtils.js';

// Returns the effective stock for a product:
// - If product has variants → sum of all variant stocks
// - Otherwise → product.stock (global)
const computeStock = (product) => {
  if (product.variants && product.variants.length > 0) {
    return product.variants.reduce((sum, v) => sum + (v.stock || 0), 0);
  }
  return product.stock || 0;
};

// Attach computed totalStock to product
export const withTotalStock = (product) => ({
  ...product,
  totalStock: computeStock(product),
});


const isUuid = (value) => /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i.test(value);

const jsonError = (res, status, message, detail = undefined) =>
  res.status(status).json({
    success: false,
    message,
    ...(process.env.NODE_ENV === 'development' && detail ? { detail } : {}),
  });

export const slugifyProductName = (value) => {
  const slug = generateSlug(value);
  return (slug || 'product').slice(0, 180).replace(/-+$/g, '') || 'product';
};

const toSlug = (value) => slugifyProductName(value);

const toStringOrNull = (value) => {
  const trimmed = trimValue(value);
  return trimmed || null;
};

const toNonNegativeInt = (value, fallback = 0) => {
  const parsed = parseInt(value, 10);
  if (Number.isNaN(parsed) || parsed < 0) return fallback;
  return parsed;
};

const toNonNegativeFloat = (value, fallback = null) => {
  const parsed = parseOptionalFloat(value);
  if (parsed === null || parsed < 0) return fallback;
  return parsed;
};

const normalizeImageArray = (value) => {
  if (Array.isArray(value)) {
    return [...new Set(value.map((item) => trimValue(item)).filter(Boolean))];
  }
  if (typeof value === 'string') {
    try {
      const parsed = JSON.parse(value);
      if (Array.isArray(parsed)) return normalizeImageArray(parsed);
    } catch {
      return parseCsvArray(value);
    }
  }
  return [];
};

const normalizeTags = (value) => {
  if (Array.isArray(value)) return [...new Set(value.map((item) => trimValue(item)).filter(Boolean))];
  if (typeof value === 'string') return parseTagArray(value) || [];
  return [];
};

const normalizeIds = (value) => {
  if (!value) return [];
  const values = Array.isArray(value) ? value : [value];
  return [...new Set(values.map((id) => trimValue(id)).filter((id) => id && id !== 'none'))];
};

const normalizeVariantInput = (variant = {}) => ({
  id: variant.id,
  title: toStringOrNull(variant.title) || 'Default Variant',
  sku: toStringOrNull(variant.sku),
  barcode: toStringOrNull(variant.barcode),
  color: toStringOrNull(variant.color),
  size: toStringOrNull(variant.size),
  price: variant.price === null || variant.price === undefined || trimValue(variant.price) === '' ? null : toNonNegativeFloat(variant.price, null),
  compareAtPrice: toNonNegativeFloat(variant.compareAtPrice, null),
  costPrice: toNonNegativeFloat(variant.costPrice, null),
  stock: toNonNegativeInt(variant.stock, 0),
  images: normalizeImageArray(variant.images),
  thumbnailUrl: toStringOrNull(variant.thumbnailUrl),
  hoverThumbnailUrl: toStringOrNull(variant.hoverThumbnailUrl),
  weight: toNonNegativeFloat(variant.weight, null),
  length: toNonNegativeFloat(variant.length, null),
  breadth: toNonNegativeFloat(variant.breadth, null),
  height: toNonNegativeFloat(variant.height, null),
  active: variant.active !== false,
});

const buildBrandRelation = (brandName) => {
  const name = toStringOrNull(brandName);
  if (!name) return undefined;
  const slug = toSlug(name);
  return {
    connectOrCreate: {
      where: { slug },
      create: { name, slug },
    },
  };
};

const validateProductPayload = (payload, { partial = false } = {}) => {
  const errors = [];
  const name = payload.name === undefined && partial ? undefined : toStringOrNull(payload.name);
  const rawHandle = toStringOrNull(payload.handle);
  const handle = payload.handle === undefined && partial ? undefined : (rawHandle ? toSlug(rawHandle) : (name ? toSlug(name) : null));
  const price = payload.price === undefined && partial ? undefined : toNonNegativeFloat(payload.price, null);
  const stock = payload.stock === undefined && partial ? undefined : toNonNegativeInt(payload.stock, 0);
  const images = payload.images === undefined && partial ? undefined : normalizeImageArray(payload.images);
  const variants = Array.isArray(payload.variants) ? payload.variants.map(normalizeVariantInput) : undefined;
  const categoryIds = payload.categoryIds !== undefined || payload.categoryId !== undefined
    ? normalizeIds(payload.categoryIds || (payload.categoryId ? [payload.categoryId] : []))
    : undefined;
  const collectionIds = payload.collectionIds !== undefined || payload.collectionId !== undefined
    ? normalizeIds(payload.collectionIds || (payload.collectionId ? [payload.collectionId] : []))
    : undefined;
  const compareAtPrice = payload.compareAtPrice === undefined && partial ? undefined : toNonNegativeFloat(payload.compareAtPrice, null);
  const costPrice = payload.costPrice === undefined && partial ? undefined : toNonNegativeFloat(payload.costPrice, null);

  if (!partial && !name) errors.push('Product name is required');
  if (!partial && !handle) errors.push('Product handle is required or must be derivable from product name');
  if (!partial && price === null) errors.push('Product price is required and must be a valid non-negative number');
  if (name && name.length > 191) errors.push('Product name is too long');
  if (handle && handle.length > 191) errors.push('Product handle is too long');
  if (compareAtPrice !== undefined && compareAtPrice !== null && price !== undefined && price !== null && compareAtPrice < price) {
    errors.push('Compare at price must be greater than or equal to price');
  }

  const thumbnailUrl = payload.thumbnailUrl === undefined && partial
    ? undefined
    : (toStringOrNull(payload.thumbnailUrl) || images?.[0] || null);
  const hoverThumbnailUrl = payload.hoverThumbnailUrl === undefined && partial
    ? undefined
    : (toStringOrNull(payload.hoverThumbnailUrl) || images?.[1] || images?.[0] || null);

  return {
    valid: errors.length === 0,
    errors,
    data: {
      name,
      subtitle: payload.subtitle === undefined && partial ? undefined : toStringOrNull(payload.subtitle),
      handle,
      description: payload.description === undefined && partial ? undefined : toStringOrNull(payload.description),
      price,
      compareAtPrice,
      costPrice,
      productType: payload.productType === undefined && partial ? undefined : toStringOrNull(payload.productType),
      gender: payload.gender === undefined && partial ? undefined : toStringOrNull(payload.gender),
      ageGroup: payload.ageGroup === undefined && partial ? undefined : toStringOrNull(payload.ageGroup),
      season: payload.season === undefined && partial ? undefined : toStringOrNull(payload.season),
      images,
      thumbnailUrl,
      hoverThumbnailUrl,
      weight: payload.weight === undefined && partial ? undefined : toNonNegativeFloat(payload.weight, null),
      length: payload.length === undefined && partial ? undefined : toNonNegativeFloat(payload.length, null),
      breadth: payload.breadth === undefined && partial ? undefined : toNonNegativeFloat(payload.breadth, null),
      height: payload.height === undefined && partial ? undefined : toNonNegativeFloat(payload.height, null),
      active: payload.active === undefined && partial ? undefined : payload.active !== false,
      tags: payload.tags === undefined && partial ? undefined : normalizeTags(payload.tags),
      categoryIds,
      collectionIds,
      brandName: payload.brandName === undefined && partial ? undefined : toStringOrNull(payload.brandName),
      stock,
      variants,
    },
  };
};

const buildUniqueProductHandle = async (baseHandle, { excludeProductId = null, tx = prisma } = {}) => {
  const baseSlug = slugifyProductName(baseHandle);
  const existingProducts = await tx.product.findMany({
    where: {
      handle: {
        startsWith: baseSlug,
      },
      ...(excludeProductId ? { id: { not: excludeProductId } } : {}),
    },
    select: { handle: true },
  });

  const existingHandles = new Set(existingProducts.map((product) => product.handle).filter(Boolean));
  if (!existingHandles.has(baseSlug)) {
    return baseSlug;
  }

  let suffix = 1;
  let candidate = `${baseSlug}-${suffix}`;
  while (existingHandles.has(candidate)) {
    suffix += 1;
    candidate = `${baseSlug}-${suffix}`;
  }

  return candidate;
};

const buildProductData = (normalized, { partial = false } = {}) => {
  const price = normalized.price;
  const compareAtPrice = normalized.compareAtPrice;
  const hasDiscount = compareAtPrice !== null && compareAtPrice !== undefined && price !== null && price !== undefined && compareAtPrice > price;
  const data = {
    name: normalized.name,
    subtitle: normalized.subtitle,
    handle: normalized.handle,
    description: normalized.description,
    price,
    compareAtPrice,
    costPrice: normalized.costPrice,
    productType: normalized.productType,
    gender: normalized.gender,
    ageGroup: normalized.ageGroup,
    season: normalized.season,
    images: normalized.images,
    thumbnailUrl: normalized.thumbnailUrl,
    hoverThumbnailUrl: normalized.hoverThumbnailUrl,
    weight: normalized.weight,
    length: normalized.length,
    breadth: normalized.breadth,
    height: normalized.height,
    active: normalized.active,
    tags: normalized.tags,
    stock: normalized.stock,
    isDiscountable: hasDiscount,
    discountPrice: hasDiscount ? compareAtPrice - price : 0,
    brand: buildBrandRelation(normalized.brandName),
  };

  if (normalized.categoryIds !== undefined) data.categories = { set: normalized.categoryIds.map((id) => ({ id })) };
  if (normalized.collectionIds !== undefined) data.collections = { set: normalized.collectionIds.map((id) => ({ id })) };

  if (partial) {
    if (price === undefined || compareAtPrice === undefined) {
      delete data.isDiscountable;
      delete data.discountPrice;
    }
    Object.keys(data).forEach((key) => {
      if (data[key] === undefined) delete data[key];
    });
  }

  return data;
};

export const withComputedPricing = (product) => {
  if (!product) return null;
  
  const price = product.price || 0;
  const compareAtPrice = product.compareAtPrice || 0;
  const costPrice = product.costPrice || 0;

  let discountAmount = 0;
  let discountPercentage = 0;

  if (compareAtPrice > price) {
    discountAmount = compareAtPrice - price;
    discountPercentage = Math.round((discountAmount / compareAtPrice) * 100);
  }

  const profit = price - costPrice;

  const computedVariants = (product.variants || []).map(v => {
    const vPrice = v.price || price;
    const vCompareAt = v.compareAtPrice || compareAtPrice;
    const vCost = v.costPrice || costPrice;
    
    let vDiscountAmount = 0;
    let vDiscountPercentage = 0;
    if (vCompareAt > vPrice) {
      vDiscountAmount = vCompareAt - vPrice;
      vDiscountPercentage = Math.round((vDiscountAmount / vCompareAt) * 100);
    }
    
    return {
      ...v,
      discountAmount: vDiscountAmount,
      discountPercentage: vDiscountPercentage,
      profit: vPrice - vCost
    };
  });

  return {
    ...product,
    variants: computedVariants,
    discountAmount,
    discountPercentage,
    profit,
    isDiscountable: compareAtPrice > price
  };
};

const buildProductSaveError = (error, action = 'save') => {
  const response = {
    message: `Failed to ${action} product.`,
    detail: error?.message || 'Unknown error'
  };

  if (error?.code === 'P2002') {
    const target = Array.isArray(error?.meta?.target) ? error.meta.target.join(', ') : 'unique field';
    response.message = `Failed to ${action} product: duplicate value.`;
    response.detail = `A record with the same ${target} already exists.`;
  }

  if (error?.code === 'P2025') {
    response.message = `Failed to ${action} product: record not found.`;
    response.detail = 'The product no longer exists or was removed by another user.';
  }

  return response;
};

export const importProducts = async (req, res) => {
  try {
    if (!req.file) {
      return res.status(400).json({ message: 'CSV file is required' });
    }

    const rows = [];
    await new Promise((resolve, reject) => {
      Readable.from([req.file.buffer])
        .pipe(csv())
        .on('data', (row) => rows.push(row))
        .on('end', resolve)
        .on('error', reject);
    });

    const normalizedRows = [];
    const rowErrors = [];

    rows.forEach((rawRow, index) => {
      const rowNumber = index + 2;
      if (isEmptyRow(rawRow)) {
        return;
      }

      const normalized = {
        ...((rawRow && typeof rawRow === 'object') ? rawRow : {}),
        rowNumber,
      };

      normalizedRows.push(normalized);
    });

    const parsedRows = normalizedRows.map((rawRow) => {
      const normalized = {
        rowNumber: rawRow.rowNumber,
        productName: trimValue(rawRow.productName || rawRow.name),
        productHandle: trimValue(rawRow.productHandle || rawRow.handle) || generateSlug(trimValue(rawRow.productName || rawRow.name)),
        productDescription: trimValue(rawRow.productDescription || rawRow.description) || null,
        subtitle: trimValue(rawRow.subtitle) || null,
        productType: trimValue(rawRow.productType) || null,
        gender: trimValue(rawRow.gender) || null,
        ageGroup: trimValue(rawRow.ageGroup) || null,
        season: trimValue(rawRow.season) || null,
        brandName: trimValue(rawRow.brandName) || null,
        categories: parseCsvArray(rawRow.categories),
        collections: parseCsvArray(rawRow.collections),
        tags: parseTagArray(rawRow.tags),
        price: parseOptionalFloat(rawRow.price),
        compareAtPrice: parseOptionalFloat(rawRow.compareAtPrice),
        costPrice: parseOptionalFloat(rawRow.costPrice),
        isDiscountable: parseBoolean(rawRow.isDiscountable, false),
        discountPrice: parseOptionalFloat(rawRow.discountPrice),
        productImages: parseCsvArray(rawRow.productImages),
        variant: {
          sku: trimValue(rawRow.variantSku) || null,
          title: trimValue(rawRow.variantTitle) || null,
          color: trimValue(rawRow.variantColor) || null,
          size: trimValue(rawRow.variantSize) || null,
          stock: Number.isNaN(parseInt(trimValue(rawRow.variantStock || '0'), 10)) ? null : parseInt(trimValue(rawRow.variantStock || '0'), 10),
          price: parseOptionalFloat(trimValue(rawRow.variantPrice) || rawRow.price),
          compareAtPrice: parseOptionalFloat(trimValue(rawRow.variantCompareAtPrice) || rawRow.compareAtPrice),
          costPrice: parseOptionalFloat(trimValue(rawRow.variantCostPrice) || rawRow.costPrice),
          barcode: trimValue(rawRow.variantBarcode) || null,
          images: parseCsvArray(rawRow.variantImageUrls),
          weight: parseOptionalFloat(rawRow.variantWeight),
          length: parseOptionalFloat(rawRow.variantLength),
          breadth: parseOptionalFloat(rawRow.variantBreadth),
          height: parseOptionalFloat(rawRow.variantHeight),
          active: parseBoolean(rawRow.variantActive, true),
        },
        productWeight: parseOptionalFloat(rawRow.productWeight),
        productLength: parseOptionalFloat(rawRow.productLength),
        productBreadth: parseOptionalFloat(rawRow.productBreadth),
        productHeight: parseOptionalFloat(rawRow.productHeight),
        productActive: parseBoolean(rawRow.active, true),
        thumbnailUrl: trimValue(rawRow.thumbnailUrl) || null,
        hoverThumbnailUrl: trimValue(rawRow.hoverThumbnailUrl) || null,
      };

      const validationResult = validateImportRow(normalized, rawRow.rowNumber);
      if (!validationResult.valid) {
        rowErrors.push({ row: rawRow.rowNumber, errors: validationResult.errors });
      }

      return normalized;
    });

    if (rowErrors.length > 0) {
      return res.status(400).json({ message: 'CSV validation failed', errors: rowErrors });
    }

    const productGroups = buildProductGroups(parsedRows);

    const failedRows = [];
    let successCount = 0;

    for (const group of productGroups) {
      if (group.errors && group.errors.length > 0) {
        failedRows.push({ rows: group.rowNumbers, errors: group.errors });
        continue;
      }

      const { productHandle, productName, variants, productData } = group;
      const existingProduct = await prisma.product.findUnique({ where: { handle: productHandle } });
      if (existingProduct) {
        failedRows.push({ rows: group.rowNumbers, errors: [`Product handle ${productHandle} already exists`] });
        continue;
      }

      const productImages = Array.from(new Set([...(productData.productImages || []), ...variants.flatMap((variant) => variant.images || [])]));
      const thumbnailUrl = productData.thumbnailUrl || productImages[0] || null;
      const hoverThumbnailUrl = productData.hoverThumbnailUrl || productImages[1] || productImages[0] || null;
      const brand = buildBrandConnectOrCreate(productData.brandName);

      const categoryConnectOrCreate = buildRelationalConnectOrCreate(productData.categories, 'Category');
      const collectionConnectOrCreate = buildRelationalConnectOrCreate(productData.collections, 'Collection');

      try {
        await prisma.$transaction(async (tx) => {
          const createdProduct = await tx.product.create({
            data: {
              name: productName,
              handle: productHandle,
              subtitle: productData.subtitle,
              description: productData.productDescription,
              price: productData.price,
              compareAtPrice: productData.compareAtPrice,
              costPrice: productData.costPrice,
              isDiscountable: (productData.compareAtPrice || 0) > (productData.price || 0),
              discountPrice: (productData.compareAtPrice || 0) > (productData.price || 0) ? (productData.compareAtPrice - productData.price) : 0,
              stock: variants.reduce((sum, item) => sum + (item.stock || 0), 0),
              images: productImages,
              thumbnailUrl,
              hoverThumbnailUrl,
              active: productData.productActive,
              weight: productData.productWeight,
              length: productData.productLength,
              breadth: productData.productBreadth,
              height: productData.productHeight,
              ...(brand ? { brand } : {}),
              categories: categoryConnectOrCreate.length > 0 ? { connectOrCreate: categoryConnectOrCreate } : undefined,
              collections: collectionConnectOrCreate.length > 0 ? { connectOrCreate: collectionConnectOrCreate } : undefined,
              tags: productData.tags ? { set: productData.tags } : undefined,
              variants: {
                create: variants.map((variant) => ({
                  sku: variant.sku,
                  title: variant.title,
                  color: variant.color,
                  size: variant.size,
                  stock: variant.stock,
                  price: variant.price,
                  compareAtPrice: variant.compareAtPrice,
                  costPrice: variant.costPrice,
                  barcode: variant.barcode,
                  images: variant.images,
                  weight: variant.weight,
                  length: variant.length,
                  breadth: variant.breadth,
                  height: variant.height,
                  active: variant.active,
                })),
              },
            },
          });

          if (!createdProduct) {
            throw new Error('Failed to create product');
          }
        });

        successCount += 1;
      } catch (error) {
        failedRows.push({ rows: group.rowNumbers, error: error.message });
      }
    }

    return res.json({
      successCount,
      failedCount: failedRows.length,
      failedRows,
    });
  } catch (error) {
    return res.status(500).json({ message: 'Failed to import products', error: error.message });
  }
};

export const getAllProducts = async (req, res) => {
  const page = Math.max(1, parseInt(req.query.page, 10) || 1);
  const limit = Math.min(100, Math.max(5, parseInt(req.query.limit, 10) || 20));
  const skip = (page - 1) * limit;
  const { collectionId, categoryId, search, includeInactive } = req.query;

  try {
    const where = {};
    if (String(includeInactive).toLowerCase() !== 'true') {
      where.active = true;
    }
    if (collectionId) {
      if (isUuid(collectionId)) {
        where.collections = { some: { id: collectionId } };
      } else {
        const collections = await prisma.collection.findMany({
          select: { id: true, name: true }
        });
        const matchedCollection = collections.find((item) => toSlug(item.name) === toSlug(collectionId));
        where.collections = { some: matchedCollection ? { id: matchedCollection.id } : { id: '__no_collection_match__' } };
      }
    }
    if (categoryId) {
      if (isUuid(categoryId)) {
        where.categories = { some: { id: categoryId } };
      } else {
        const categories = await prisma.category.findMany({
          select: { id: true, name: true }
        });
        const matchedCategory = categories.find((item) => toSlug(item.name) === toSlug(categoryId));
        where.categories = { some: matchedCategory ? { id: matchedCategory.id } : { id: '__no_category_match__' } };
      }
    }
    if (search?.trim()) {
      const query = search.trim();
      where.OR = [
        { name: { contains: query,    } },
        { subtitle: { contains: query,    } },
        { description: { contains: query,    } },
        { handle: { contains: query.toLowerCase(),    } }
      ];
    }

    const [products, total] = await Promise.all([
      prisma.product.findMany({
        where,
        skip,
        take: limit,
        orderBy: { createdAt: 'desc' },
        select: {
          id: true,
          name: true,
          subtitle: true,
          handle: true,
          price: true,
          discountPrice: true,
          isDiscountable: true,
          thumbnailUrl: true,
          hoverThumbnailUrl: true,
          images: true,
          stock: true,
          active: true,
          compareAtPrice: true,
          costPrice: true,
          weight: true,
          length: true,
          breadth: true,
          height: true,
          createdAt: true,
          categories: {
            select: { id: true, name: true }
          },
          collections: {
            select: { id: true, name: true }
          },
          variants: true,
        }
      }),
      prisma.product.count({ where })
    ]);

    res.json({
      success: true,
      data: products.map(p => withComputedPricing(withTotalStock(appendProductImageVersions(p)))),
      meta: { page, limit, total, totalPages: Math.ceil(total / limit) }
    });
  } catch (error) {
    logger.error('products.list.error', { message: error?.message, stack: error?.stack, page, limit });
    return res.status(500).json({
      success: false,
      message: 'Failed to fetch products',
      error: process.env.NODE_ENV === 'development' ? error?.message : undefined,
    });
  }
};

export const getProductById = async (req, res) => {
  try {
    const { id } = req.params;
    const product = await prisma.product.findUnique({
      where: { id },
      include: {
        categories: true,
        collections: true,
        variants: true,
        reviews: true
      }
    });

    if (!product) {
      logger.warn('products.get_by_id.not_found', { id });
      return res.status(404).json({
        success: false,
        message: 'Product not found',
        id
      });
    }

    res.json(withComputedPricing(appendProductImageVersions(product)));
  } catch (error) {
    logger.error('products.get_by_id.error', { id: req.params.id, message: error?.message, stack: error?.stack });
    return res.status(500).json({
      success: false,
      message: 'Failed to fetch product',
      error: process.env.NODE_ENV === 'development' ? error?.message : undefined,
    });
  }
};

export const getProductByHandle = async (req, res) => {
  try {
    const { handle } = req.params;

    logger.info('products.get_by_handle.request', { handle });

    // Primary lookup: by handle (slug/string)
    let product = await prisma.product.findUnique({
      where: { handle },
      include: {
        categories: true,
        collections: true,
        variants: true,
        reviews: true,
      },
    });

    // Fallback lookup: if the param is a UUID, it may actually be a product id.
    if (!product && isUuid(handle)) {
      logger.warn('products.get_by_handle.fallback_to_uuid_id', { handle });
      product = await prisma.product.findUnique({
        where: { id: handle },
        include: {
          categories: true,
          collections: true,
          variants: true,
          reviews: true,
        },
      });
    }

    if (!product || product.active === false) {
      logger.warn('products.get_by_handle.not_found', { handle });
      return res.status(404).json({
        success: false,
        message: 'Product not found',
        handle,
      });
    }

    // Also fetch related products (same category)
    const relatedCategoryIds = Array.isArray(product.categories)
      ? product.categories.map((category) => category.id).filter(Boolean)
      : [];

    const relatedProducts = relatedCategoryIds.length
      ? await prisma.product.findMany({
          where: {
            categories: {
              some: {
                id: { in: relatedCategoryIds },
              },
            },
            id: { not: product.id },
          },
          take: 4,
          select: {
          id: true,
          name: true,
          handle: true,
          price: true,
          compareAtPrice: true,
          discountPrice: true,
          isDiscountable: true,
          images: true,
          thumbnailUrl: true,
          hoverThumbnailUrl: true,
          stock: true,
          variants: true,
        },
        })
      : [];

    return res.status(200).json(
      withComputedPricing({
        success: true,
        ...withTotalStock(appendProductImageVersions(product)),
        relatedProducts: relatedProducts.map((p) => withComputedPricing(appendProductImageVersions(p))),
      })
    );
  } catch (error) {
    logger.error('products.get_by_handle.error', {
      handle: req.params.handle,
      message: error?.message,
      stack: error?.stack,
    });

    return res.status(500).json({
      success: false,
      message: 'Failed to fetch product',
      error: process.env.NODE_ENV === 'development' ? error?.message : undefined,
    });
  }
};

export const createProduct = async (req, res) => {
  try {
    logger.info('products.create.request', {
      admin_id: req.user?.id || null,
      name: req.body?.name,
      handle: req.body?.handle,
    });

    const validation = validateProductPayload(req.body);
    if (!validation.valid) {
      return jsonError(res, 400, 'Invalid product data', validation.errors);
    }

    const normalized = {
      ...validation.data,
      handle: await buildUniqueProductHandle(validation.data.handle || validation.data.name),
    };

    const productData = buildProductData(normalized);
    if (normalized.categoryIds !== undefined) productData.categories = { connect: normalized.categoryIds.map((id) => ({ id })) };
    if (normalized.collectionIds !== undefined) productData.collections = { connect: normalized.collectionIds.map((id) => ({ id })) };

    const product = await prisma.product.create({
      data: {
        ...productData,
        variants: normalized.variants?.length
          ? {
              create: normalized.variants.map((variant) => {
                const { id: _variantId, ...variantData } = variant;
                return variantData;
              }),
            }
          : undefined,
      },
      include: { categories: true, collections: true, variants: true, reviews: true, brand: true },
    });

    logger.info('products.create.success', {
      product_id: product.id,
      handle: product.handle,
    });

    return res.status(201).json({
      success: true,
      message: 'Product created successfully',
      data: withComputedPricing(withTotalStock(appendProductImageVersions(product))),
    });
  } catch (error) {
    logger.error('products.create.error', { code: error?.code, message: error?.message, stack: error?.stack });
    if (error?.code === 'P2002' && String(error?.meta?.target || '').includes('handle')) {
      return jsonError(res, 400, 'Product handle already exists. Please try another slug.');
    }
    const payload = buildProductSaveError(error, 'create');
    return res.status(error?.code === 'P2002' ? 400 : 500).json({ success: false, ...payload });
  }
};

export const updateProduct = async (req, res) => {
  try {
    const { id } = req.params;
    logger.info('products.update.request', { product_id: id, admin_id: req.user?.id || null });

    const validation = validateProductPayload(req.body);
    if (!validation.valid) {
      return jsonError(res, 400, 'Invalid product data', validation.errors);
    }

    const normalized = {
      ...validation.data,
      handle: await buildUniqueProductHandle(validation.data.handle || validation.data.name, { excludeProductId: id }),
    };

    const variantIds = normalized.variants?.filter((variant) => variant.id).map((variant) => variant.id) || [];

    const product = await prisma.product.update({
      where: { id },
      data: {
        ...buildProductData(normalized),
        variants: normalized.variants ? {
          deleteMany: {
            id: {
              notIn: variantIds,
            },
            productId: id,
          },
          update: normalized.variants.filter(v => v.id).map(v => {
            const { id: variantId, ...variantData } = normalizeVariantInput(v);
            return {
              where: { id: variantId },
              data: variantData,
            };
          }),
          create: normalized.variants.filter(v => !v.id).map(v => {
            const { id: _variantId, ...variantData } = normalizeVariantInput(v);
            return variantData;
          }),
        } : undefined,
      },
      include: { categories: true, collections: true, variants: true, reviews: true, brand: true },
    });

    return res.json({
      success: true,
      message: 'Product updated successfully',
      data: withComputedPricing(withTotalStock(appendProductImageVersions(product))),
    });
  } catch (error) {
    logger.error('products.update.error', { product_id: req.params.id, code: error?.code, message: error?.message, stack: error?.stack });
    if (error?.code === 'P2002' && String(error?.meta?.target || '').includes('handle')) {
      return jsonError(res, 400, 'Product handle already exists. Please try another slug.');
    }
    const payload = buildProductSaveError(error, 'update');
    return res.status(error?.code === 'P2002' ? 400 : error?.code === 'P2025' ? 404 : 500).json({ success: false, ...payload });
  }
};

export const patchProduct = async (req, res) => {
  try {
    const { id } = req.params;
    const { id: _bodyId, createdAt, updatedAt, categories, collections, ...patchableBody } = req.body;
    const validation = validateProductPayload(patchableBody, { partial: true });
    if (!validation.valid) {
      return jsonError(res, 400, 'Invalid product data', validation.errors);
    }

    const data = buildProductData(validation.data, { partial: true });
    if (validation.data.variants) {
      const variantsData = validation.data.variants;
      data.variants = {
        deleteMany: {
          id: {
            notIn: variantsData.filter(v => v.id).map(v => v.id)
          },
          productId: id
        },
        update: variantsData.filter(v => v.id).map(v => {
          const { id: variantId, ...variantData } = normalizeVariantInput(v);
          return {
            where: { id: variantId },
            data: variantData
          };
        }),
        create: variantsData.filter(v => !v.id).map(v => {
          const { id: _variantId, ...variantData } = normalizeVariantInput(v);
          return variantData;
        })
      };
    }

    const product = await prisma.product.update({
      where: { id: id },
      data,
      include: {
        categories: true,
        collections: true,
        variants: true,
        reviews: true
      }
    });
    return res.json({
      success: true,
      message: 'Product updated successfully',
      data: withComputedPricing(withTotalStock(appendProductImageVersions(product))),
    });
  } catch (error) {
    logger.error('products.patch.error', { product_id: req.params.id, code: error?.code, message: error?.message, stack: error?.stack });
    const payload = buildProductSaveError(error, 'update');
    return res.status(error?.code === 'P2002' ? 400 : error?.code === 'P2025' ? 404 : 500).json({ success: false, ...payload });
  }
};

export const getBestSellers = async (req, res) => {
  try {
    const products = await prisma.product.findMany({
      where: {
        collections: {
          some: {
            name: {
              contains: 'Best Seller',
            }
          }
        },
        active: true
      },
      take: 8,
      select: {
        id: true,
        name: true,
        handle: true,
        price: true,
        discountPrice: true,
        isDiscountable: true,
        thumbnailUrl: true,
        hoverThumbnailUrl: true,
        images: true,
        stock: true,
        variants: true,
        compareAtPrice: true,
        costPrice: true
      }
    });

    res.json(products.map((product) => withComputedPricing(withTotalStock(appendProductImageVersions(product)))));
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

export const getNewArrivals = async (req, res) => {
  try {
    const products = await prisma.product.findMany({
      where: { active: true },
      orderBy: { createdAt: 'desc' },
      take: 8,
      select: {
        id: true,
        name: true,
        handle: true,
        price: true,
        discountPrice: true,
        isDiscountable: true,
        thumbnailUrl: true,
        hoverThumbnailUrl: true,
        images: true,
        stock: true,
        compareAtPrice: true,
        costPrice: true,
        variants: true
      }
    });
    res.json(products.map((product) => withComputedPricing(withTotalStock(appendProductImageVersions(product)))));
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

export const deleteProduct = async (req, res) => {
  try {
    const { id } = req.params;
    await prisma.product.delete({
      where: { id: id },
    });
    res.json({ success: true, message: 'Product deleted successfully' });
  } catch (error) {
    logger.error('products.delete.error', { product_id: req.params.id, code: error?.code, message: error?.message, stack: error?.stack });
    res.status(error?.code === 'P2025' ? 404 : 500).json({
      success: false,
      message: error?.code === 'P2025' ? 'Product not found' : 'Failed to delete product',
      error: process.env.NODE_ENV === 'development' ? error?.message : undefined,
    });
  }
};
