# Stage 1: Build & Prisma Generate
FROM node:18-alpine AS builder

# Install OpenSSL for Prisma
RUN apk add --no-cache openssl python3 make g++

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install ALL dependencies (including devDependencies needed for build)
RUN npm ci

# Copy Prisma schema
COPY prisma ./prisma/

# Generate Prisma client
RUN npx prisma generate

# Copy source code
COPY . .

# Stage 2: Production Image
FROM node:18-alpine AS production

# Install OpenSSL for Prisma at runtime
RUN apk add --no-cache openssl

WORKDIR /app

# Set NODE_ENV
ENV NODE_ENV=production

# Copy package files
COPY package*.json ./

# Install ONLY production dependencies
RUN npm ci --omit=dev

# Copy Prisma client from builder
COPY --from=builder /app/node_modules/.prisma ./node_modules/.prisma
COPY --from=builder /app/node_modules/@prisma ./node_modules/@prisma

# Copy source code from builder
COPY --from=builder /app/src ./src
COPY --from=builder /app/prisma ./prisma

# Change ownership to the unprivileged node user
RUN chown -R node:node /app

# Switch to the non-root user for security
USER node

# Add a healthcheck using native Node.js instead of wget
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD node -e "require('http').get('http://localhost:3000/health', (r) => r.statusCode === 200 ? process.exit(0) : process.exit(1)).on('error', () => process.exit(1))"

EXPOSE 3000

# Start command
CMD ["npm", "start"]
