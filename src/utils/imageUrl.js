export const getImageUrl = (value) => {
  if (!value) return '/placeholder-product.png';
  if (typeof value !== 'string') return value;
  if (value.startsWith('http://localhost:5000/uploads/products/')) {
    const filename = value.replace('http://localhost:5000/uploads/products/', '');
    return `https://littlethread-backend.onrender.com/uploads/products/${filename}`;
  }
  if (value.startsWith('http://localhost:5000/uploads/')) {
    const relativePart = value.replace('http://localhost:5000/uploads/', '');
    return `https://littlethread-backend.onrender.com/uploads/${relativePart}`;
  }
  if (value.startsWith('/uploads/')) {
    return `https://littlethread-backend.onrender.com${value}`;
  }
  if (value.startsWith('http://') || value.startsWith('https://')) {
    return value;
  }
  // Otherwise treat as filename in products
  return `https://littlethread-backend.onrender.com/uploads/products/${value}`;
};

export const appendImageVersion = (value) => {
  return getImageUrl(value);
};

export const appendImageVersionToArray = (values) => {
  if (!Array.isArray(values)) return values;
  return values.map(appendImageVersion);
};

export const appendProductImageVersions = (product) => {
  if (!product) return product;

  return {
    ...product,
    thumbnailUrl: appendImageVersion(product.thumbnailUrl),
    hoverThumbnailUrl: appendImageVersion(product.hoverThumbnailUrl),
    images: appendImageVersionToArray(product.images),
    variants: Array.isArray(product.variants)
      ? product.variants.map((variant) => ({
          ...variant,
          images: appendImageVersionToArray(variant.images),
        }))
      : product.variants,
    reviews: Array.isArray(product.reviews)
      ? product.reviews.map((review) => ({
          ...review,
          images: appendImageVersionToArray(review.images),
        }))
      : product.reviews,
  };
};

export const appendCollectionImageVersion = (collection) => {
  if (!collection) return collection;

  return {
    ...collection,
    imageUrl: appendImageVersion(collection.imageUrl),
    img: appendImageVersion(collection.img),
    products: Array.isArray(collection.products)
      ? collection.products.map((product) => ({
          ...product,
          thumbnailUrl: appendImageVersion(product.thumbnailUrl),
          images: appendImageVersionToArray(product.images),
        }))
      : collection.products,
  };
};

export const appendBannerImageVersion = (banner) => {
  if (!banner) return banner;

  return {
    ...banner,
    imageUrl: appendImageVersion(banner.imageUrl),
  };
};

export const appendOrderImageVersions = (order) => {
  if (!order) return order;

  return {
    ...order,
    items: Array.isArray(order.items)
      ? order.items.map((item) => ({
          ...item,
          product: item.product
            ? {
                ...item.product,
                thumbnailUrl: appendImageVersion(item.product.thumbnailUrl),
                images: appendImageVersionToArray(item.product.images),
              }
            : item.product,
        }))
      : order.items,
  };
};