import nodemailer from 'nodemailer';

const EMAIL_USER = process.env.EMAIL_USER;
const EMAIL_PASSWORD = process.env.EMAIL_PASSWORD;
const BRAND_NAME = 'Little Threads';

if (!EMAIL_USER || !EMAIL_PASSWORD) {
  // Fail fast in production; in dev, still throw so it's obvious during setup.
  throw new Error('Missing EMAIL_USER or EMAIL_PASSWORD in environment');
}

const transporter = nodemailer.createTransport({
  service: 'gmail',
  auth: {
    user: EMAIL_USER,
    pass: EMAIL_PASSWORD,
  },
});

export const TEMPLATES = {
  LOGIN_OTP: (otp) => `Dear Customer,\nYour secure login OTP is ${otp}\nThis OTP is valid for 2 minutes. Please do not share it with anyone.\nRegards,\n${BRAND_NAME}`,
  SIGNUP_OTP: (otp) => `Welcome to ${BRAND_NAME}. Your sign up OTP is ${otp}\nLet's get you started.\nRegards,\n${BRAND_NAME}`,
  FORGOT_PASSWORD_OTP: (otp) => `Dear Customer, your OTP to reset your password is ${otp}. The OTP is valid for 2 minutes.\nRegards,\n${BRAND_NAME}`,
  ORDER_CONFIRMATION: () => `Dear Customer,\nYour order has been placed successfully. We will notify you once it is processed.\nRegards,\n${BRAND_NAME}`,
  INVOICE: (orderId) => `Dear Customer,\nYour order has been successfully placed and payment is confirmed.\n\nOrder ID: ${orderId}\n\nYour invoice is attached to this email. Thank you for shopping with us!\nRegards,\n${BRAND_NAME}`,
  ORDER_PACKED: () => `Dear Customer,\nYour order has been packed and is ready for dispatch.\nRegards,\n${BRAND_NAME}`,
  ORDER_SHIPPED: (trackingLink = '') => `Dear Customer,\nYour order has been shipped.\nTracking link: ${trackingLink}\nRegards,\n${BRAND_NAME}`,
  OUT_FOR_DELIVERY: () => `Dear Customer,\nYour order is out for delivery and it will be delivered shortly.\nRegards,\n${BRAND_NAME}`,
  DELIVERED: () => `Dear Customer,\nYour order has been successfully delivered. Thank you for shopping with us.\nRegards,\n${BRAND_NAME}`,
  ORDER_CANCELLED: () => `Dear Customer,\nYour order has been cancelled successfully. For any assistance please contact us.\nRegards,\n${BRAND_NAME}`,
  PAYMENT_SUCCESS: () => `Dear Customer,\nYour payment has been successfully received. Your order is now confirmed.\nRegards,\n${BRAND_NAME}`,
  PAYMENT_FAILED: () => `Dear Customer,\nYour payment was unsuccessful. Kindly retry or use an alternate payment method.\nRegards,\n${BRAND_NAME}`,
  REFUND_INITIATED: () => `Dear Customer,\nYour refund has been initiated and will be processed within 5-6 working days.\nRegards,\n${BRAND_NAME}`,
  REFUND_COMPLETED: () => `Dear Customer,\nYour refund has been successfully processed and credited.\nRegards,\n${BRAND_NAME}`,
  RETURN_APPROVED: (refundAmount) => `Dear Customer,\n\nYour return request has been approved!\n\nRefund Amount: Rs.${refundAmount}\n\nPlease arrange to send the product back to us. Our team will schedule a return pickup for you today.\n\nOnce we receive and verify the returned item, the refund will be processed within 5-7 business days.\n\nThank you for shopping with ${BRAND_NAME}!\n\nRegards,\n${BRAND_NAME}`,
  EXCHANGE_APPROVED: (variantTitle) => `Dear Customer,\n\nYour exchange request has been approved!\n\nPreferred Replacement: ${variantTitle}\n\nOur team will arrange a return pickup for the item being exchanged today. Once we receive your item, we'll send out your replacement at the earliest.\n\nThank you for shopping with ${BRAND_NAME}!\n\nRegards,\n${BRAND_NAME}`,
  REFUND_COMPLETED_EMAIL: (refundAmount) => `Dear Customer,\n\nGreat news! Your refund has been successfully processed.\n\nRefund Amount: Rs.${refundAmount}\n\nThe amount will be credited to your original payment method within 5-7 business days. Please check your bank account for the credit.\n\nThank you for shopping with ${BRAND_NAME}!\n\nRegards,\n${BRAND_NAME}`,
  RETURN_PICKUP_SCHEDULED: () => `Dear Customer,\n\nYour return pickup has been scheduled. The courier will collect the parcel based on serviceability and courier availability.\n\nRegards,\n${BRAND_NAME}`,
  RETURN_PICKUP_FAILED: () => `Dear Customer,\n\nWe were unable to complete the return pickup attempt. Our team will review the status and reschedule if needed.\n\nRegards,\n${BRAND_NAME}`,
  RETURN_RECEIVED: () => `Dear Customer,\n\nYour returned item has reached our warehouse and is now under inspection.\n\nRegards,\n${BRAND_NAME}`,
  EXCHANGE_PICKUP_SCHEDULED: () => `Dear Customer,\n\nYour exchange pickup has been scheduled. The courier will collect the return parcel based on serviceability and courier availability.\n\nRegards,\n${BRAND_NAME}`,
  EXCHANGE_RECEIVED: (variantTitle) => `Dear Customer,\n\nWe have received the item you returned for exchange. Your replacement item${variantTitle ? ` (${variantTitle})` : ''} will be processed next.\n\nRegards,\n${BRAND_NAME}`
};

export const sendMail = async (to, subject, text) => {
  try {
    if (!to) return false;
    const mailOptions = {
      from: EMAIL_USER,
      to,
      subject,
      text
    };
    await transporter.sendMail(mailOptions);
    console.log(`Email sent: ${subject} to ${to}`);
    return true;
  } catch (error) {
    console.error(`Error sending email to ${to}:`, error);
    return false;
  }
};

export const sendInvoiceEmail = async (to, subject, text, invoicePDF, invoiceFileName = 'little-threads-invoice.pdf') => {
  try {
    if (!to) return false;
    const mailOptions = {
      from: EMAIL_USER,
      to,
      subject,
      text,
      attachments: [
        {
          filename: invoiceFileName,
          content: invoicePDF,
          contentType: 'application/pdf'
        }
      ]
    };
    await transporter.sendMail(mailOptions);
    console.log(`Invoice email sent: ${subject} to ${to} with attachment: ${invoiceFileName}`);
    return true;
  } catch (error) {
    console.error(`Error sending invoice email to ${to}:`, error);
    return false;
  }
};
