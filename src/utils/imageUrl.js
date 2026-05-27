export const appendImageVersion = (value) => {
  return value;
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