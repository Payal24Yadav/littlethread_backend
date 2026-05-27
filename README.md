# Ecommerce Backend API

Backend engine powering the storefront and admin dashboard. Built with Node.js, Express, and Prisma ORM.

## 🛠 Tech Stack
- **Framework**: Express.js (v5)
- **Database Logic**: Prisma ORM with **MySQL** (see `prisma/schema.prisma`)
- **Storage**: Local uploads under `uploads/` (optimized via `sharp`)
- **Authentication**: JWT & Bcrypt
- **Mailing**: Nodemailer
- **File Handling**: Multer

## 📂 Project Structure
- `src/controllers/`: Business logic for each resource.
- `src/routes/`: API endpoint definitions.
- `src/middleware/`: Authentication and request middleware.
- `prisma/`: Database schema (migrations are not currently committed).

## 🚀 Getting Started

1. **Install dependencies**:
   ```bash
   npm install
   ```

2. **Configure Environment Variables**:
   Create `backend-api/.env` from the example:
   ```bash
   cp .env.example .env
   ```

   Minimum required to boot the server:
   ```env
   DATABASE_URL="mysql://user:password@localhost:3306/db"
   JWT_SECRET="your_secret_key"
   EMAIL_USER="your_gmail_address@gmail.com"
   EMAIL_PASSWORD="your_gmail_app_password"
   ```

3. **Database Setup**:
   ```bash
   npx prisma generate

   # This repo does not include prisma migrations right now.
   # For a fresh local database, `db push` is the simplest:
   npx prisma db push
   ```

   If you only changed `schema.prisma`, `npx prisma generate` alone is usually enough.

4. **Run Server**:
   ```bash
   npm run dev
   ```

By default the backend listens on `PORT=8000` (override with `.env`).

## OTP & SMS Verification

1. Ensure your backend `.env` contains `FAST2SMS_API_KEY` (used by `POST /api/auth/send-otp` and order-status SMS).
2. Restart the backend after running `prisma generate`.
3. Verify these endpoints work:
   - `POST /api/auth/send-otp` (body: `{ "mobile": "10-digit-number" }`)
   - `POST /api/auth/verify-otp` (body: `{ "mobile": "10-digit-number", "otp": "1234" }`)
   - `POST /api/auth/email-login` (body: `{ "email": "...", "password": "..." }`)

## 📡 API Endpoints

### Authentication
- `POST /api/auth/register` - User registration
- `POST /api/auth/login` - User login
- `POST /api/auth/customer/login` - Storefront customer login

### Products & Management
- `GET /api/products` - List all products
- `GET /api/products/best-sellers` - Get best selling products
- `GET /api/products/new-arrivals` - Get most recent products
- `GET /api/products/:id` - Get product details
- `POST /api/products` - Create product (Admin)
- `PUT /api/products/:id` - Update product (Admin)
- `PATCH /api/products/:id` - Partial update product (Admin)
- `DELETE /api/products/:id` - Delete product (Admin)

### Categories & Collections
- `GET /api/categories` - Fetch categories
- `GET /api/collections` - Fetch collections

### Reviews & Sales
- `POST /api/reviews` - Submit product review
- `GET /api/sales` - Fetch sales analytics (Admin)

### Uploads
- `POST /api/upload` - Handle image uploads to Supabase

### Shipping
- `POST /api/shipping/create` - Create a Shiprocket shipment for an existing order
- `GET /api/shipping/track?awb=<awb>` - Fetch live shipment tracking details
- `GET /api/shipping/track?orderId=<orderId>` - Fetch tracking details using a stored shipment
- `GET /api/shipping/order/:orderId` - Fetch stored shipment data for an order

## Shipping Setup

Add these environment variables before using the shipping APIs:

```env
SHIPROCKET_EMAIL="your-shiprocket-email"
SHIPROCKET_PASSWORD="your-shiprocket-password"
SHIPROCKET_BASE_URL="https://apiv2.shiprocket.in"
SHIPROCKET_PICKUP_LOCATION="Primary"
SHIPROCKET_PICKUP_POSTCODE="110001"
```

Optional:

```env
SHIPROCKET_TOKEN="existing-jwt-token"
```

Example request body for `POST /api/shipping/create`:

```json
{
  "orderId": "your-order-id",
  "weight": 0.8,
  "length": 12,
  "breadth": 10,
  "height": 6
}
```

The service loads the order, customer, items, and shipping address from the database, creates the Shiprocket order, assigns an AWB, stores the shipment in PostgreSQL, and returns clean JSON for your frontend.

---
## 💡 Features
- **Strict Data Validation**: Leveraging Prisma's type safety.
- **Efficient Image Handling**: Direct streaming to Supabase buckets.
- **RESTful Best Practices**: Clean URL structures and appropriate HTTP methods.
