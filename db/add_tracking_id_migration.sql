-- Migration: Add tracking_id column to orders table
-- This column is used for short, user-friendly order tracking IDs

-- Add tracking_id column to orders table
ALTER TABLE public.orders
ADD COLUMN IF NOT EXISTS tracking_id TEXT UNIQUE;

-- Create index for fast lookup
CREATE INDEX IF NOT EXISTS idx_orders_tracking_id
ON public.orders(tracking_id);

-- Add constraint for tracking_id format (optional, adjust as needed)
-- ALTER TABLE public.orders
-- ADD CONSTRAINT tracking_id_format CHECK (tracking_id ~ '^[A-Z]{2}\d{4}$');
