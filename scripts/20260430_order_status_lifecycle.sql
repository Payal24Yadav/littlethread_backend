-- Normalize order statuses for lifecycle visibility in admin
-- Run manually against Supabase/PostgreSQL.

-- 1) Backfill old values to canonical values used by admin filters
UPDATE public."Order"
SET status = CASE
  WHEN UPPER(status) IN ('PAID', 'COD_CONFIRMED', 'COD_PENDING', 'PAYMENT_PENDING', 'PENDING', 'PROCESSING', 'READY_TO_SHIP', 'AWB_ASSIGNED', 'PICKUP_SCHEDULED', 'PICKED', 'ORDERED') THEN 'ORDERED'
  WHEN UPPER(status) IN ('SHIPPED', 'IN_TRANSIT', 'OUT_FOR_DELIVERY') THEN 'SHIPPED'
  WHEN UPPER(status) = 'DELIVERED' THEN 'DELIVERED'
  WHEN UPPER(status) IN ('CANCELED', 'CANCELLED', 'FAILED') THEN 'CANCELED'
  ELSE status
END;

-- 2) Ensure new rows default to ORDERED if status is not passed
ALTER TABLE public."Order"
  ALTER COLUMN status SET DEFAULT 'ORDERED';

-- 3) Add index for status filter performance
CREATE INDEX IF NOT EXISTS "Order_status_idx" ON public."Order" (status);
