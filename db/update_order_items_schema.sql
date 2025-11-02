-- Migration: Add per-service notes, images, and measurement profiles
-- Add missing columns to order_items table for production readiness

-- Add notes column for per-service special requirements
ALTER TABLE public.order_items
ADD COLUMN IF NOT EXISTS notes TEXT;

-- Add measurement profile reference for per-service measurements
ALTER TABLE public.order_items
ADD COLUMN IF NOT EXISTS measurement_profile_id UUID REFERENCES public.measurements(id);

-- Add image URLs array for per-service reference images
ALTER TABLE public.order_items
ADD COLUMN IF NOT EXISTS image_urls TEXT[];

-- Create index for measurement profile lookups
CREATE INDEX IF NOT EXISTS idx_order_items_measurement_profile_id
ON public.order_items(measurement_profile_id);

-- Update the RPC function to handle the new structure
-- (existing function should still work as it only deals with quantity * price_cents)
