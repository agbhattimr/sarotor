-- Update measurements table to include comprehensive tailoring measurements
-- Run this in Supabase SQL Editor after the initial schema

-- Add new measurement fields
ALTER TABLE public.measurements 
ADD COLUMN IF NOT EXISTS shirt_length numeric(5,2),
ADD COLUMN IF NOT EXISTS shoulder numeric(5,2),
ADD COLUMN IF NOT EXISTS chest numeric(5,2),
ADD COLUMN IF NOT EXISTS waist numeric(5,2),
ADD COLUMN IF NOT EXISTS hip numeric(5,2),
ADD COLUMN IF NOT EXISTS daman numeric(5,2),
ADD COLUMN IF NOT EXISTS side numeric(5,2),
ADD COLUMN IF NOT EXISTS sleeves_length numeric(5,2),
ADD COLUMN IF NOT EXISTS wrist numeric(5,2),
ADD COLUMN IF NOT EXISTS bicep numeric(5,2),
ADD COLUMN IF NOT EXISTS armhole numeric(5,2);

-- Add boolean fields for shirt options
ALTER TABLE public.measurements 
ADD COLUMN IF NOT EXISTS zip boolean DEFAULT false,
ADD COLUMN IF NOT EXISTS pleats boolean DEFAULT false;

-- Add shalwar/kurta specific measurements
ALTER TABLE public.measurements 
ADD COLUMN IF NOT EXISTS shalwar_length numeric(5,2),
ADD COLUMN IF NOT EXISTS paincha numeric(5,2),
ADD COLUMN IF NOT EXISTS ghair numeric(5,2),
ADD COLUMN IF NOT EXISTS belt numeric(5,2),
ADD COLUMN IF NOT EXISTS lastic numeric(5,2);

-- Add trouser specific measurements
ALTER TABLE public.measurements 
ADD COLUMN IF NOT EXISTS trouser_length numeric(5,2),
ADD COLUMN IF NOT EXISTS paincha_trouser numeric(5,2),
ADD COLUMN IF NOT EXISTS upper_thai numeric(5,2),
ADD COLUMN IF NOT EXISTS lower_thai_front numeric(5,2),
ADD COLUMN IF NOT EXISTS full_thai numeric(5,2),
ADD COLUMN IF NOT EXISTS asan_front numeric(5,2),
ADD COLUMN IF NOT EXISTS asan_back numeric(5,2),
ADD COLUMN IF NOT EXISTS lastic_trouser numeric(5,2);

-- Add phone and notes fields
ALTER TABLE public.measurements 
ADD COLUMN IF NOT EXISTS phone text,
ADD COLUMN IF NOT EXISTS notes text;

-- Add is_active field for tracking active measurement profile
ALTER TABLE public.measurements 
ADD COLUMN IF NOT EXISTS is_active boolean DEFAULT false;

-- Add index for faster queries on user_id and is_active
CREATE INDEX IF NOT EXISTS idx_measurements_user_active ON public.measurements(user_id, is_active);
CREATE INDEX IF NOT EXISTS idx_measurements_user_created ON public.measurements(user_id, created_at DESC);

-- Add comment to document the comprehensive measurement fields
COMMENT ON TABLE public.measurements IS 'Comprehensive tailoring measurements including shirt, shalwar, and trouser specific fields with active profile tracking';
