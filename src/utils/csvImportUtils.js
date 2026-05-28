export const trimValue = (value) => (typeof value === 'string' ? value.trim() : value == null ? '' : String(value).trim());

export const generateSlug = (value = '') =>
  String(value || '')
    .toLowerCase()
    .trim()
    .replace(/[^a-z0-9]+/g, '-')
    .replace(/^-+|-+$/g, '');

export const parseCsvArray = (value) => {
  const trimmed = trimValue(value);
  if (!trimmed) return [];

  if (trimmed.startsWith('[')) {
    const parsed = JSON.parse(trimmed);
    if (!Array.isArray(parsed)) {
      throw new Error('must be a JSON array');
    }
    return parsed.map((item) => trimValue(item)).filter(Boolean);
  }

  return trimmed
    .split(/[,;|]/)
    .map((item) => trimValue(item))
    .filter(Boolean);
};

export const parseOptionalFloat = (value) => {
  if (value === undefined || value === null || trimValue(value) === '') return null;
  const parsed = parseFloat(String(value).trim());
  return Number.isNaN(parsed) ? null : parsed;
};

export const parseBoolean = (value, defaultValue = false) => {
  const normalized = trimValue(value).toLowerCase();
  if (normalized === 'true' || normalized === '1' || normalized === 'yes') return true;
  if (normalized === 'false' || normalized === '0' || normalized === 'no') return false;
  return defaultValue;
};

export const isEmptyRow = (row = {}) =>
  Object.values(row).every((value) => trimValue(value) === '');

export const parseTagArray = (value) => {
  const tags = parseCsvArray(value);
  return tags.length > 0 ? tags : null;
};

export const normalizeImportRow = (rawRow) => {
  const productName = trimValue(rawRow.productName);
  const productHandle = trimValue(rawRow.productHandle) || generateSlug(productName);
  const price = parseOptionalFloat(rawRow.price);
  const compareAtPrice = parseOptionalFloat(rawRow.compareAtPrice);
  const costPrice = parseOptionalFloat(rawRow.costPrice);
  const isDiscountable = parseBoolean(rawRow.isDiscountable, false);
  const discountPrice = parseOptionalFloat(rawRow.discountPrice);
  const productImages = parseCsvArray(rawRow.productImages);
  const categories = parseCsvArray(rawRow.categories);
  const collections = parseCsvArray(rawRow.collections);
  const productTags = parseTagArray(rawRow.tags);
  const productType = trimValue(rawRow.productType) || null;
  const gender = trimValue(rawRow.gender) || null;
  const ageGroup = trimValue(rawRow.ageGroup) || null;
  const season = trimValue(rawRow.season) || null;
  const brandName = trimValue(rawRow.brand) || null;
  const productDescription = trimValue(rawRow.productDescription) || null;
  const subtitle = trimValue(rawRow.subtitle) || null;
  const variantSku = trimValue(rawRow.variantSku) || null;
  const variantTitle = trimValue(rawRow.variantTitle) || null;
  const variantColor = trimValue(rawRow.variantColor) || null;
  const variantSize = trimValue(rawRow.variantSize) || null;
  const variantStock = parseInt(trimValue(rawRow.variantStock) || '0', 10);
  const variantPrice = parseOptionalFloat(trimValue(rawRow.variantPrice) || rawRow.price);
  const variantCompareAtPrice = parseOptionalFloat(trimValue(rawRow.variantCompareAtPrice) || rawRow.compareAtPrice);
  const variantCostPrice = parseOptionalFloat(trimValue(rawRow.variantCostPrice) || rawRow.costPrice);
  const variantBarcode = trimValue(rawRow.variantBarcode) || null;
  const variantImages = parseCsvArray(rawRow.variantImageUrls);
  const variantWeight = parseOptionalFloat(rawRow.variantWeight);
  const variantLength = parseOptionalFloat(rawRow.variantLength);
  const variantBreadth = parseOptionalFloat(rawRow.variantBreadth);
  const variantHeight = parseOptionalFloat(rawRow.variantHeight);
  const productWeight = parseOptionalFloat(rawRow.productWeight);
  const productLength = parseOptionalFloat(rawRow.productLength);
  const productBreadth = parseOptionalFloat(rawRow.productBreadth);
  const productHeight = parseOptionalFloat(rawRow.productHeight);
  const productActive = parseBoolean(rawRow.active, true);
  const variantActive = parseBoolean(rawRow.variantActive, true);

  return {
    productHandle,
    productName,
    productDescription,
    subtitle,
    productType,
    brandName,
    gender,
    ageGroup,
    season,
    categories,
    collections,
    tags: productTags,
    price,
    compareAtPrice,
    costPrice,
    isDiscountable,
    discountPrice,
    productImages,
    productWeight,
    productLength,
    productBreadth,
    productHeight,
    productActive,
    variant: {
      sku: variantSku,
      title: variantTitle,
      color: variantColor,
      size: variantSize,
      stock: Number.isNaN(variantStock) ? null : variantStock,
      price: variantPrice,
      compareAtPrice: variantCompareAtPrice,
      costPrice: variantCostPrice,
      barcode: variantBarcode,
      images: variantImages,
      weight: variantWeight,
      length: variantLength,
      breadth: variantBreadth,
      height: variantHeight,
      active: variantActive,
    },
  };
};

export const standardizeEnumValue = (value, allowedValues) => {
  if (!value) return null;
  const normalized = generateSlug(value).toUpperCase().replace(/-/g, '_');
  return allowedValues.includes(normalized) ? normalized : null;
};

export const buildRelationalConnectOrCreate = (names, modelName = 'Category') =>
  [...new Set(names.filter(Boolean))].map((name) => ({
    where: { name },
    create: { name },
  }));

export const buildBrandConnectOrCreate = (brandName) => {
  if (!brandName) return null;
  const slug = generateSlug(brandName);
  return {
    connectOrCreate: {
      where: { slug },
      create: { name: brandName, slug },
    },
  };
};

export const validateImportRow = (normalized, rowNumber) => {
  const errors = [];
  if (!normalized.productName) {
    errors.push('productName is required');
  }
  if (!normalized.productHandle) {
    errors.push('productHandle is required or must be derivable from productName');
  }
  if (normalized.price === null) {
    errors.push('price is required and must be a valid number');
  }
  if (normalized.variant.stock === null) {
    errors.push('variantStock is required and must be a valid number');
  }
  if (!normalized.variant.sku && !normalized.variant.title) {
    errors.push('variantSku or variantTitle is required');
  }
  if (normalized.gender && !['MALE', 'FEMALE', 'UNISEX'].includes(standardizeEnumValue(normalized.gender, ['MALE', 'FEMALE', 'UNISEX']))) {
    errors.push('gender must be one of MALE, FEMALE, UNISEX');
  }
  if (normalized.ageGroup && !['NEWBORN', 'INFANT', 'TODDLER', 'KIDS', 'TEEN', 'ADULT'].includes(standardizeEnumValue(normalized.ageGroup, ['NEWBORN', 'INFANT', 'TODDLER', 'KIDS', 'TEEN', 'ADULT']))) {
    errors.push('ageGroup must be one of NEWBORN, INFANT, TODDLER, KIDS, TEEN, ADULT');
  }
  if (normalized.season && !['SUMMER', 'WINTER', 'SPRING', 'FALL', 'FESTIVE', 'ALL_SEASON'].includes(standardizeEnumValue(normalized.season, ['SUMMER', 'WINTER', 'SPRING', 'FALL', 'FESTIVE', 'ALL_SEASON']))) {
    errors.push('season must be one of SUMMER, WINTER, SPRING, FALL, FESTIVE, ALL_SEASON');
  }

  if (errors.length > 0) {
    return { rowNumber, valid: false, errors };
  }
  return { rowNumber, valid: true };
};

export const buildProductGroups = (normalizedRows) => {
  const groups = new Map();

  normalizedRows.forEach((entry) => {
    const { productHandle, productName, variant, ...productData } = entry;
    const rowKey = productHandle;
    if (!groups.has(rowKey)) {
      groups.set(rowKey, {
        productHandle,
        productName,
        rowNumbers: [entry.rowNumber],
        productData: { ...productData },
        variants: [variant],
      });
      return;
    }

    const group = groups.get(rowKey);
    group.rowNumbers.push(entry.rowNumber);

    if (group.productName !== productName) {
      group.errors = group.errors || [];
      group.errors.push(`Mismatched productName for handle ${productHandle}`);
    }

    group.productData.productImages = [
      ...new Set([...group.productData.productImages, ...productData.productImages]),
    ];
    group.productData.categories = [...new Set([...group.productData.categories, ...productData.categories])];
    group.productData.collections = [...new Set([...group.productData.collections, ...productData.collections])];
    if (!group.productData.brandName && productData.brandName) group.productData.brandName = productData.brandName;
    if (!group.productData.productDescription && productData.productDescription) group.productData.productDescription = productData.productDescription;
    group.variants.push(variant);
  });

  return Array.from(groups.values());
};
