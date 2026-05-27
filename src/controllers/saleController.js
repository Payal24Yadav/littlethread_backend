import prisma from '../utils/prisma.js';
import { appendProductImageVersions } from '../utils/imageUrl.js';

export const getSales = async (req, res) => {
  try {
    const sales = await prisma.sale.findMany({
      include: {
        order: {
          select: { status: true }
        },
        product: {
          select: { name: true, thumbnailUrl: true, images: true }
        }
      },
      orderBy: { createdAt: 'desc' }
    });

    const activeSales = sales.filter((sale) => sale.order?.status !== 'CANCELED');

    const formattedSales = activeSales.map(s => ({
      id: s.id,
      productName: s.product.name,
      thumbnail: appendProductImageVersions(s.product).thumbnailUrl || appendProductImageVersions(s.product).images?.[0],
      quantity: s.quantity,
      price: s.price,
      source: s.source,
      date: s.createdAt,
      customerName: s.customerName,
      customerEmail: s.customerEmail,
      customerPhone: s.customerPhone,
      paymentMode: s.paymentMode,
      paymentId: s.paymentId,
      notes: s.notes,
      variantTitle: s.variantTitle
    }));

    res.json(formattedSales);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

export const registerStoreSale = async (req, res) => {
  const { productId, variantTitle, quantity, price, customerName, customerEmail, customerPhone, paymentMode, paymentId, notes, source } = req.body;

  try {
    // 1. Create Sale record
    const sale = await prisma.sale.create({
      data: {
        productId,
        variantTitle,
        quantity: parseInt(quantity),
        price: parseFloat(price),
        source: source || 'Store',
        customerName,
        customerEmail,
        customerPhone,
        paymentMode,
        paymentId,
        notes
      }
    });

    // 2. Update Stock (Variant or Product)
    if (variantTitle) {
      const variant = await prisma.productVariant.findFirst({
        where: {
          productId,
          title: { equals: variantTitle,    }
        }
      });

      if (variant) {
        await prisma.productVariant.update({
          where: { id: variant.id },
          data: { stock: { decrement: parseInt(quantity) } }
        });
        
        // Also update total stock on product if you track it there
        await prisma.product.update({
          where: { id: productId },
          data: { stock: { decrement: parseInt(quantity) } }
        });
      }
    } else {
      await prisma.product.update({
        where: { id: productId },
        data: {
          stock: { decrement: parseInt(quantity) }
        }
      });
    }

    res.json(sale);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

export const deleteSale = async (req, res) => {
  const { id } = req.params;
  try {
    await prisma.sale.delete({ where: { id } });
    res.json({ success: true, message: 'Sale record deleted successfully' });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

export const updateSale = async (req, res) => {
  const { id } = req.params;
  const { variantTitle, quantity, price, customerName, customerEmail, customerPhone, paymentMode, paymentId, notes, source } = req.body;

  try {
    const oldSale = await prisma.sale.findUnique({ where: { id } });
    if (!oldSale) return res.status(404).json({ error: 'Sale not found' });

    const parsedQuantity = (quantity !== undefined && quantity !== null && quantity !== '') ? parseInt(quantity) : undefined;
    const parsedPrice = (price !== undefined && price !== null && price !== '') ? parseFloat(price) : undefined;

    if (parsedQuantity !== undefined && isNaN(parsedQuantity)) return res.status(400).json({ error: 'Invalid quantity' });
    if (parsedPrice !== undefined && isNaN(parsedPrice)) return res.status(400).json({ error: 'Invalid price' });

    const sale = await prisma.sale.update({
      where: { id },
      data: {
        variantTitle,
        quantity: parsedQuantity,
        price: parsedPrice,
        customerName,
        customerEmail,
        customerPhone,
        paymentMode,
        paymentId,
        notes,
        source
      }
    });

    // Cascade to Order if linked
    if (sale.orderId) {
      try {
        const order = await prisma.order.findUnique({ where: { id: sale.orderId } });
        if (order && order.shippingAddress) {
          const existingAddr = typeof order.shippingAddress === 'object' ? order.shippingAddress : {};
          const updatedAddress = {
            ...existingAddr,
            ...(customerName ? { 
              fullName: customerName, 
              firstName: customerName.split(' ')[0], 
              lastName: customerName.split(' ').slice(1).join(' ') || '' 
            } : {}),
            ...(customerEmail ? { email: customerEmail } : {}),
            ...(customerPhone ? { phone: customerPhone } : {})
          };
          await prisma.order.update({
            where: { id: sale.orderId },
            data: { shippingAddress: updatedAddress }
          });

          // Cascade to Customer if linked to the order
          if (order.customerId) {
            await prisma.customer.update({
              where: { id: order.customerId },
              data: {
                ...(customerName ? { name: customerName } : {}),
                ...(customerEmail ? { email: customerEmail } : {}),
                ...(customerPhone ? { mobile: customerPhone } : {})
              }
            }).catch(err => console.error('Failed to cascade customer update:', err.message));
          }
        }
      } catch (cascadeErr) {
        console.error('Error during sale-to-order cascade:', cascadeErr.message);
      }
    }

    // Adjust stock if quantity changed
    if (parsedQuantity !== undefined && !isNaN(parsedQuantity) && parsedQuantity !== oldSale.quantity) {
      const diff = parsedQuantity - oldSale.quantity;
      
      const vTitle = variantTitle || oldSale.variantTitle;
      if (vTitle) {
        const variant = await prisma.productVariant.findFirst({
          where: { productId: oldSale.productId, title: vTitle }
        });
        if (variant) {
          await prisma.productVariant.update({
            where: { id: variant.id },
            data: { stock: { decrement: diff } }
          });
        }
      }

      await prisma.product.update({
        where: { id: oldSale.productId },
        data: { stock: { decrement: diff } }
      });
    }

    res.json(sale);
  } catch (error) {
    console.error('UpdateSale Error:', error);
    res.status(500).json({ error: error.message });
  }
};
