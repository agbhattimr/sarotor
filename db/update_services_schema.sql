-- Update service categories table with additional fields
ALTER TABLE public.service_categories 
ADD COLUMN IF NOT EXISTS description text,
ADD COLUMN IF NOT EXISTS icon text DEFAULT 'category',
ADD COLUMN IF NOT EXISTS sort_order integer DEFAULT 0,
ADD COLUMN IF NOT EXISTS is_active boolean DEFAULT true,
ADD COLUMN IF NOT EXISTS created_at timestamptz DEFAULT now(),
ADD COLUMN IF NOT EXISTS updated_at timestamptz DEFAULT now();

-- Update services table with comprehensive fields
ALTER TABLE public.services 
ADD COLUMN IF NOT EXISTS delivery_days integer DEFAULT 15,
ADD COLUMN IF NOT EXISTS urgent_delivery_days_min integer,
ADD COLUMN IF NOT EXISTS urgent_delivery_days_max integer,
ADD COLUMN IF NOT EXISTS is_coming_soon boolean DEFAULT false,
ADD COLUMN IF NOT EXISTS service_type text DEFAULT 'standard' CHECK (service_type IN ('standard', 'custom_pricing', 'external_purchase', 'artisanal')),
ADD COLUMN IF NOT EXISTS custom_pricing jsonb,
ADD COLUMN IF NOT EXISTS service_options jsonb,
ADD COLUMN IF NOT EXISTS created_at timestamptz DEFAULT now(),
ADD COLUMN IF NOT EXISTS updated_at timestamptz DEFAULT now();

-- Add indexes for better performance
CREATE INDEX IF NOT EXISTS idx_services_category_active ON public.services(category_id, is_active);
CREATE INDEX IF NOT EXISTS idx_services_type ON public.services(service_type);
CREATE INDEX IF NOT EXISTS idx_service_categories_active ON public.service_categories(is_active);
CREATE INDEX IF NOT EXISTS idx_service_categories_sort ON public.service_categories(sort_order);

-- Update RLS policies for service categories
DROP POLICY IF EXISTS "service_categories_read" ON public.service_categories;
DROP POLICY IF EXISTS "service_categories_admin_insert" ON public.service_categories;
DROP POLICY IF EXISTS "service_categories_admin_update" ON public.service_categories;
DROP POLICY IF EXISTS "service_categories_admin_delete" ON public.service_categories;

CREATE POLICY "service_categories_read" ON public.service_categories 
FOR SELECT 
USING (true);

CREATE POLICY "service_categories_admin_insert" ON public.service_categories 
FOR INSERT 
WITH CHECK (public.is_admin());

CREATE POLICY "service_categories_admin_update" ON public.service_categories 
FOR UPDATE 
USING (public.is_admin()) 
WITH CHECK (public.is_admin());

CREATE POLICY "service_categories_admin_delete" ON public.service_categories 
FOR DELETE 
USING (public.is_admin());

-- Update RLS policies for services
DROP POLICY IF EXISTS "services_read" ON public.services;
DROP POLICY IF EXISTS "services_admin_insert" ON public.services;
DROP POLICY IF EXISTS "services_admin_update" ON public.services;
DROP POLICY IF EXISTS "services_admin_delete" ON public.services;

CREATE POLICY "services_read" ON public.services 
FOR SELECT 
USING (true);

CREATE POLICY "services_admin_insert" ON public.services 
FOR INSERT 
WITH CHECK (public.is_admin());

CREATE POLICY "services_admin_update" ON public.services 
FOR UPDATE 
USING (public.is_admin()) 
WITH CHECK (public.is_admin());

CREATE POLICY "services_admin_delete" ON public.services 
FOR DELETE 
USING (public.is_admin());

-- Add comments for documentation
COMMENT ON TABLE public.service_categories IS 'Service categories with icons and sorting';
COMMENT ON TABLE public.services IS 'Services with pricing, delivery times, and custom options';
COMMENT ON COLUMN public.services.delivery_days IS 'Standard delivery time in days';
COMMENT ON COLUMN public.services.urgent_delivery_days_min IS 'Minimum days for urgent delivery';
COMMENT ON COLUMN public.services.urgent_delivery_days_max IS 'Maximum days for urgent delivery';
COMMENT ON COLUMN public.services.service_type IS 'Type of service: standard, custom_pricing, external_purchase, artisanal';
COMMENT ON COLUMN public.services.custom_pricing IS 'JSON configuration for custom pricing rules';
COMMENT ON COLUMN public.services.service_options IS 'JSON configuration for service options and variants';
