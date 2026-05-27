import PDFDocument from 'pdfkit';
import prisma from './prisma.js';
import path from 'path';
import { fileURLToPath } from 'url';
import fs from 'fs';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const BRAND = {
  companyName: 'Little Threads',
  brandName: 'Little Threads Fashion',
  website: 'https://littlethreadsfashion.com',
  websiteDisplay: 'littlethreadsfashion.com',
  supportEmail: 'support@littlethreadsfashion.com'
};

const formatInvoiceNumber = (invoiceNumber, fallback) => {
  const raw = String(invoiceNumber || fallback || '').trim();
  return raw
    .replace(/^GOE-/i, 'LTF-')
    .replace(/^Gof-INV/i, 'LTF-INV')
    .replace(/^Gof-/i, 'LTF-');
};

/**
 * Main PDF Invoice Generation Service
 * Highly readable, large typography, formal corporate design for "Little Threads".
 */
export const generateInvoice = async (orderOrId) => {
  let order;
  if (typeof orderOrId === 'string') {
    // Fetch order details from database if ID is provided
    order = await prisma.order.findUnique({
      where: { id: orderOrId },
      include: {
        customer: {
          select: { name: true, email: true }
        },
        items: {
          include: {
            product: {
              select: { id: true, name: true, price: true, thumbnailUrl: true }
            }
          }
        }
      }
    });
  } else {
    order = orderOrId;
  }

  if (!order) {
    throw new Error('Order not found');
  }

  // Fetch shipment details if any
  const shipment = await prisma.shipment.findUnique({
    where: { orderId: order.id }
  }).catch(() => null);

  return new Promise((resolve, reject) => {
    try {
      const doc = new PDFDocument({
        margin: 0, // We'll manage margins manually
        size: 'A4'
      });
      let buffers = [];

      doc.on('data', (data) => {
        buffers.push(data);
      });

      doc.on('end', () => {
        resolve(Buffer.concat(buffers));
      });

      doc.on('error', (err) => {
        reject(err);
      });

      // --- FORMAL PREMIUM COLOR SYSTEM ---
      const colors = {
        primary: '#333333',        // Dark slate charcoal for primary elements (headers, major titles)
        primaryDark: '#111111',    // Near black for high contrast text
        primaryLight: '#FFFFFF',   // Card backgrounds (clean white)
        
        secondary: '#666666',      // Professional medium gray
        secondaryDark: '#4A4A4A',  // Professional slate gray
        secondaryLight: '#F9F9F9', // Soft gray for alternating table rows / subtle panels
        
        text: '#4A4A4A',           // Readable charcoal gray for body text
        darkText: '#222222',       // Dark text for key values and headers
        textMuted: '#777777',      // Muted gray for fine print / details
        lightGray: '#F5F5F5',      // Soft background gray
        white: '#FFFFFF',          // Clean white
        border: '#DCDCDC',         // Professional light gray border
        borderMuted: '#EAEAEA',    // Subtly lighter border
        
        // Status colors (rendered cleanly)
        successBg: '#E8F8F5',
        successText: '#27AE60',
        pendingBg: '#FEF9E7',
        pendingText: '#D35400',
        dangerBg: '#FDEDEC',
        dangerText: '#C0392B'
      };

      const pageWidth = 595.28; // A4 width
      const pageHeight = 841.89; // A4 height
      const margin = 45;

      // --- PAGE 1 DESIGN ---
      // Top Double Accent Border (Formal dark charcoal & thin slate stripes)
      doc.rect(0, 0, pageWidth, 8).fill(colors.primary);
      doc.rect(0, 8, pageWidth, 3).fill(colors.secondary);

      // --- HEADER ---
      // 1. Logo (Top Left)
      let logoY = 32;
      let usedLogo = false;
      try {
        const logoPath = path.join(__dirname, '../assets/images/logo.png');
        if (fs.existsSync(logoPath)) {
          doc.image(logoPath, margin, logoY, { width: 110 });
          usedLogo = true;
        }
      } catch (err) {
        usedLogo = false;
      }

      if (!usedLogo) {
        // High-end fallback typography logo if image is missing
        doc.fontSize(18)
           .font('Helvetica-Bold')
           .fillColor(colors.primary)
           .text(BRAND.companyName.toUpperCase(), margin, logoY);
      }

      // Spacing adjust (no subtext below logo as requested)
      const subtextY = usedLogo ? logoY + 68 : logoY + 22;

      // 2. INVOICE Title & Info (Top Right)
      doc.fontSize(30)
         .font('Helvetica-Bold')
         .fillColor(colors.primary)
         .text('INVOICE', margin, logoY, { align: 'right', width: pageWidth - 2 * margin });

      const rightX = pageWidth - margin - 190;
      const displayInvoiceNumber = formatInvoiceNumber(
        order.invoiceNumber,
        order.id.slice(-6).toUpperCase()
      );
      
      const orderDate = new Date(order.createdAt);
      const dateStr = orderDate.toLocaleDateString('en-US', { month: 'long', day: 'numeric', year: 'numeric' });

      doc.fontSize(12)
         .font('Helvetica-Bold')
         .fillColor(colors.darkText)
         .text(`Invoice No: `, rightX, logoY + 38, { align: 'right', width: 100 })
         .font('Helvetica')
         .text(displayInvoiceNumber, rightX + 100, logoY + 38, { align: 'left', width: 90 })
         
         .font('Helvetica-Bold')
         .text(`Order Date: `, rightX, logoY + 54, { align: 'right', width: 100 })
         .font('Helvetica')
         .text(dateStr, rightX + 100, logoY + 54, { align: 'left', width: 90 });

      // Divider Line below Header (Clean grey line)
      doc.moveTo(margin, subtextY + 16)
         .lineTo(pageWidth - margin, subtextY + 16)
         .lineWidth(1)
         .strokeColor(colors.border)
         .stroke();

      // --- CUSTOMER & ORDER DETAILS SECTION ---
      const detailsY = subtextY + 32;
      const cardWidth = 240;
      const cardHeight = 112; // Increased height to prevent text overflow from large font sizes
      const cardGap = 25;

      // Left Card: BILLED TO (Formal: White background with clean thin border)
      doc.save();
      doc.roundedRect(margin, detailsY, cardWidth, cardHeight, 5)
         .fillColor(colors.white)
         .fill();
      doc.roundedRect(margin, detailsY, cardWidth, cardHeight, 5)
         .strokeColor(colors.border)
         .lineWidth(0.8)
         .stroke();

      doc.fontSize(11)
         .font('Helvetica-Bold')
         .fillColor(colors.secondaryDark)
         .text('BILLED TO', margin + 14, detailsY + 12);

      const customerName = order.shippingAddress?.fullName || order.customer?.name || 'Customer';
      const customerEmail = order.shippingAddress?.email || order.customer?.email || 'N/A';
      const customerPhone = order.shippingAddress?.phone || 'N/A';

      doc.fontSize(12.5)
         .font('Helvetica-Bold')
         .fillColor(colors.primaryDark)
         .text(customerName, margin + 14, detailsY + 26);

      let addressText = '';
      if (order.shippingAddress?.address) {
        const addressLines = [
          order.shippingAddress.address,
          order.shippingAddress.apartment || '',
          `${order.shippingAddress.city || ''}, ${order.shippingAddress.state || ''} ${order.shippingAddress.pinCode || ''}`.trim()
        ].filter(Boolean);
        addressText = addressLines.join(', ');
      } else {
        addressText = 'No address provided';
      }

      doc.fontSize(10.5)
         .font('Helvetica')
         .fillColor(colors.text)
         .text(customerEmail, margin + 14, detailsY + 41, { width: cardWidth - 28, height: 14, ellipsis: true })
         .text(`Phone: ${customerPhone}`, margin + 14, detailsY + 55)
         .text(addressText, margin + 14, detailsY + 69, { width: cardWidth - 28, height: 32, ellipsis: true, lineGap: 1.5 });
      doc.restore();

      // Right Card: ORDER SUMMARY (Formal: White background with clean thin border)
      const rightCardX = margin + cardWidth + cardGap + 5;
      doc.save();
      doc.roundedRect(rightCardX, detailsY, cardWidth, cardHeight, 5)
         .fillColor(colors.white)
         .fill();
      doc.roundedRect(rightCardX, detailsY, cardWidth, cardHeight, 5)
         .strokeColor(colors.border)
         .lineWidth(0.8)
         .stroke();

      doc.fontSize(11)
         .font('Helvetica-Bold')
         .fillColor(colors.secondaryDark)
         .text('ORDER SUMMARY', rightCardX + 14, detailsY + 12);

      const isCod = String(order.paymentMethod || '').toLowerCase() === 'cod';
      const paymentMethodStr = isCod ? 'Cash on Delivery (COD)' : (order.paymentMethod ? String(order.paymentMethod).toUpperCase() : 'Razorpay (Prepaid)');
      
      let paymentStatusStr = 'PENDING';
      let paymentStatusColor = colors.pendingText;
      let paymentStatusBg = colors.pendingBg;

      if (order.status === 'PAID' || order.status === 'COD_CONFIRMED' || order.paymentStatus === 'PAID') {
        paymentStatusStr = 'PAID';
        paymentStatusColor = colors.successText;
        paymentStatusBg = colors.successBg;
      } else if (order.status === 'CANCELLED' || order.status === 'CANCELED') {
        paymentStatusStr = 'CANCELLED';
        paymentStatusColor = colors.dangerText;
        paymentStatusBg = colors.dangerBg;
      }

      doc.fontSize(10.5)
         .font('Helvetica-Bold')
         .fillColor(colors.darkText)
         .text('Payment Method: ', rightCardX + 14, detailsY + 26)
         .font('Helvetica')
         .fillColor(colors.text)
         .text(paymentMethodStr, rightCardX + 114, detailsY + 26)
         
         .font('Helvetica-Bold')
         .fillColor(colors.darkText)
         .text('Transaction ID: ', rightCardX + 14, detailsY + 40)
         .font('Helvetica')
         .fillColor(colors.text)
         .text(order.razorpayPaymentId || order.razorpayOrderId || 'N/A', rightCardX + 114, detailsY + 40, { width: cardWidth - 128, height: 14, ellipsis: true })
         
         .font('Helvetica-Bold')
         .fillColor(colors.darkText)
         .text('Order Status: ', rightCardX + 14, detailsY + 54)
         .font('Helvetica')
         .fillColor(colors.text)
         .text(order.status || 'ORDERED', rightCardX + 114, detailsY + 54);

      // Payment status badge
      doc.roundedRect(rightCardX + 14, detailsY + 74, 60, 18, 4)
         .fillColor(paymentStatusBg)
         .fill();

      doc.fontSize(8.5)
         .font('Helvetica-Bold')
         .fillColor(paymentStatusColor)
         .text(paymentStatusStr, rightCardX + 14, detailsY + 79, { align: 'center', width: 60 });
      doc.restore();

      // --- PRODUCTS TABLE SECTION ---
      let tableTop = detailsY + cardHeight + 38;
      const colWidths = {
        no: 34,
        desc: 260,
        price: 76,
        qty: 46,
        total: 89.28
      };

      // Table Header Row (Formal: Solid charcoal background, height 28)
      doc.save();
      doc.roundedRect(margin, tableTop, 505.28, 28, 4)
         .fillColor(colors.primary)
         .fill();

      doc.fontSize(11)
         .font('Helvetica-Bold')
         .fillColor(colors.white);

      let currentX = margin + 10;
      doc.text('NO.', currentX, tableTop + 9);
      currentX += colWidths.no;
      doc.text('PRODUCT DESCRIPTION', currentX, tableTop + 9);
      currentX += colWidths.desc;
      doc.text('PRICE', currentX, tableTop + 9, { align: 'right', width: colWidths.price });
      currentX += colWidths.price;
      doc.text('QTY', currentX, tableTop + 9, { align: 'center', width: colWidths.qty });
      doc.text('TOTAL', margin + 414, tableTop + 9, { align: 'right', width: colWidths.total - 10 });
      doc.restore();

      // Table Rows (Formal alternating soft gray, row height increased for large text)
      let rowY = tableTop + 28;
      const items = order.items || [];

      items.forEach((item, index) => {
        const productName = item.productName || item.product?.name || 'Product';
        const description = `${productName}${item.variantTitle ? ` (${item.variantTitle})` : ''}`;

        // Calculate dynamic height based on wrapped text length for font size 12
        doc.font('Helvetica-Bold').fontSize(12);
        const descHeight = doc.heightOfString(description, { width: colWidths.desc - 15, lineGap: 1.5 });
        const rowHeight = Math.max(36, Math.ceil(descHeight) + 12);

        // Row background
        doc.save();
        if (index % 2 === 1) {
          doc.rect(margin, rowY, 505.28, rowHeight)
             .fillColor(colors.secondaryLight)
             .fill();
        } else {
          doc.rect(margin, rowY, 505.28, rowHeight)
             .fillColor(colors.white)
             .fill();
        }

        // Row separator border
        doc.moveTo(margin, rowY + rowHeight)
           .lineTo(margin + 505.28, rowY + rowHeight)
           .lineWidth(0.5)
           .strokeColor(colors.border)
           .stroke();
        doc.restore();

        // Row text values (Font size 12)
        doc.fontSize(12)
           .font('Helvetica')
           .fillColor(colors.darkText);

        // Column: No
        doc.text(String(index + 1), margin + 10, rowY + 10, { align: 'center', width: colWidths.no - 15 });
        
        // Column: Product details (wrapped)
        doc.font('Helvetica-Bold')
           .text(description, margin + colWidths.no + 10, rowY + 10, { width: colWidths.desc - 15, lineGap: 1.5 });
        
        // Column: Price
        doc.font('Helvetica')
           .text(`Rs.${Number(item.price).toFixed(2)}`, margin + colWidths.no + colWidths.desc, rowY + 10, { align: 'right', width: colWidths.price });
        
        // Column: Qty
        doc.text(String(item.quantity), margin + colWidths.no + colWidths.desc + colWidths.price, rowY + 10, { align: 'center', width: colWidths.qty });
        
        // Column: Total
        doc.font('Helvetica-Bold')
           .text(`Rs.${(Number(item.price) * Number(item.quantity)).toFixed(2)}`, margin + 414, rowY + 10, { align: 'right', width: colWidths.total - 10 });

        rowY += rowHeight;
      });

      // Bottom border for table
      doc.moveTo(margin, rowY)
         .lineTo(margin + 505.28, rowY)
         .lineWidth(1.5)
         .strokeColor(colors.primary)
         .stroke();

      // --- LOGISTICS & TOTALS SECTION ---
      const totalSectionY = rowY + 35;
      const summaryWidth = 240;
      const shipmentCardHeight = 102; // Increased height to prevent overflow

      // Left Card: Shipment Status Card (Formal: White background with clean thin border)
      doc.save();
      doc.roundedRect(margin, totalSectionY, summaryWidth, shipmentCardHeight, 5)
         .fillColor(colors.white)
         .fill();
      doc.roundedRect(margin, totalSectionY, summaryWidth, shipmentCardHeight, 5)
         .strokeColor(colors.border)
         .lineWidth(0.8)
         .stroke();

      doc.fontSize(11)
         .font('Helvetica-Bold')
         .fillColor(colors.secondaryDark)
         .text('SHIPPING & DELIVERY', margin + 14, totalSectionY + 12);

      if (shipment && shipment.awb) {
        doc.fontSize(10.5)
           .font('Helvetica-Bold')
           .fillColor(colors.text)
           .text('Courier Partner: ', margin + 14, totalSectionY + 28)
           .font('Helvetica')
           .text(shipment.courier || 'Standard Partner', margin + 102, totalSectionY + 28)
           
           .font('Helvetica-Bold')
           .text('AWB Number: ', margin + 14, totalSectionY + 42)
           .font('Helvetica')
           .fillColor(colors.secondaryDark)
           .text(shipment.awb, margin + 102, totalSectionY + 42)
           
           .font('Helvetica-Bold')
           .fillColor(colors.text)
           .text('Delivery Status: ', margin + 14, totalSectionY + 56)
           .font('Helvetica')
           .text(shipment.status || 'MANIFESTED', margin + 102, totalSectionY + 56)
           
           .fontSize(8)
           .fillColor(colors.textMuted)
           .text('Use AWB to track shipping status on courier site.', margin + 14, totalSectionY + 78, { width: summaryWidth - 28 });
      } else {
        doc.fontSize(10.5)
           .font('Helvetica')
           .fillColor(colors.textMuted)
           .text('Shipment is currently being processed.', margin + 14, totalSectionY + 28, { width: summaryWidth - 28 })
           .text('Logistics courier and tracking information will be updated once shipped.', margin + 14, totalSectionY + 44, { width: summaryWidth - 28, lineGap: 1.5 });
      }
      doc.restore();

      // Right Side: Pricing Summary (Formal)
      const isCodOrder = String(order.paymentMethod || '').toLowerCase() === 'cod';
      const subtotal = order.items.reduce((acc, item) => acc + (item.price * item.quantity), 0);
      const shipping = 0; // free shipping standard
      const codCharges = isCodOrder ? Number(order.codCharges || 0) : 0;
      const grandTotal = subtotal + shipping + codCharges;

      const sumLabelX = pageWidth - margin - 170;
      const sumValueX = pageWidth - margin - 75;

      doc.fontSize(12)
         .font('Helvetica-Bold')
         .fillColor(colors.secondaryDark)
         .text('Subtotal:', sumLabelX, totalSectionY + 6, { width: 90, align: 'right' })
         .font('Helvetica')
         .fillColor(colors.darkText)
         .text(`Rs.${subtotal.toFixed(2)}`, sumValueX, totalSectionY + 6, { width: 75, align: 'right' });

      doc.font('Helvetica-Bold')
         .fillColor(colors.secondaryDark)
         .text('Shipping:', sumLabelX, totalSectionY + 22, { width: 90, align: 'right' })
         .font('Helvetica')
         .fillColor(colors.darkText)
         .text('Free', sumValueX, totalSectionY + 22, { width: 75, align: 'right' });

      let totalsAdjustY = 38;
      if (codCharges > 0) {
        doc.font('Helvetica-Bold')
           .fillColor(colors.secondaryDark)
           .text('COD Charges:', sumLabelX, totalSectionY + totalsAdjustY, { width: 90, align: 'right' })
           .font('Helvetica')
           .fillColor(colors.darkText)
           .text(`Rs.${codCharges.toFixed(2)}`, sumValueX, totalSectionY + totalsAdjustY, { width: 75, align: 'right' });
        totalsAdjustY += 16;
      }

      // Grand Total Highlight Card (Formal: border/charcoal, height 30)
      doc.save();
      doc.roundedRect(sumLabelX + 10, totalSectionY + totalsAdjustY + 4, 160, 30, 4)
         .fillColor(colors.white)
         .strokeColor(colors.primary)
         .lineWidth(1.2)
         .fillAndStroke();

      doc.fontSize(13.5)
         .font('Helvetica-Bold')
         .fillColor(colors.primaryDark)
         .text('Total:', sumLabelX + 15, totalSectionY + totalsAdjustY + 12, { width: 60, align: 'right' })
         .text(`Rs.${grandTotal.toFixed(2)}`, sumLabelX + 80, totalSectionY + totalsAdjustY + 12, { width: 85, align: 'right' });
      doc.restore();

      // --- FOOTER SECTION ---
      const thankYouY = Math.max(715, totalSectionY + 125);
      
      // Draw Divider
      doc.moveTo(margin, thankYouY)
         .lineTo(pageWidth - margin, thankYouY)
         .lineWidth(1)
         .strokeColor(colors.border)
         .stroke();

      // Centered Brand Title in Footer
      doc.fontSize(12.5)
         .font('Helvetica-Bold')
         .fillColor(colors.primary)
         .text(BRAND.brandName, margin, thankYouY + 12, { align: 'center', width: pageWidth - 2 * margin });

      // Clickable Website and Email links side by side in footer (Centered)
      const linkText = `${BRAND.websiteDisplay}   |   ${BRAND.supportEmail}`;
      doc.fontSize(10)
         .font('Helvetica')
         .fillColor(colors.secondaryDark)
         .text(linkText, margin, thankYouY + 28, { align: 'center', width: pageWidth - 2 * margin });
      
      // Add link areas centered over the text
      const fullTextWidth = doc.widthOfString(linkText);
      const textStartX = (pageWidth - fullTextWidth) / 2;
      const webWidth = doc.widthOfString(BRAND.websiteDisplay);
      const emailWidth = doc.widthOfString(BRAND.supportEmail);
      
      // link to website
      doc.link(textStartX, thankYouY + 28, webWidth, 12, { uri: BRAND.website });
      // link to email
      doc.link(textStartX + fullTextWidth - emailWidth, thankYouY + 28, emailWidth, 12, { uri: `mailto:${BRAND.supportEmail}` });

      // Fine print policy note at the very bottom
      doc.fontSize(8.5)
         .fillColor(colors.textMuted)
         .text('Return Policy: We offer hassle-free returns & exchanges within 7 days of delivery. Items must be in original condition with tags intact. Contact support for exchange assistance.', margin, thankYouY + 46, { align: 'center', width: pageWidth - 2 * margin, lineGap: 1.5 });

      doc.end();
    } catch (error) {
      reject(error);
    }
  });
};
