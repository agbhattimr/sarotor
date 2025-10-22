-- Add is_admin_template field to measurements table
-- This will help distinguish between admin-created templates and user-created templates
ALTER TABLE public.measurements 
ADD COLUMN IF NOT EXISTS is_admin_template boolean DEFAULT false;

-- Add index for faster queries on admin templates
CREATE INDEX IF NOT EXISTS idx_measurements_admin_template ON public.measurements(is_admin_template);

-- Update RLS policies to restrict template editing to admin only
-- Users can only create their own measurement profiles (not templates)
-- Only admins can create, update, or delete templates

-- Drop existing policies
DROP POLICY IF EXISTS "meas owner rw" ON public.measurements;
DROP POLICY IF EXISTS "meas admin read" ON public.measurements;

-- Create new policies with template restrictions
CREATE POLICY "measurements_owner_rw" ON public.measurements 
FOR ALL 
USING (auth.uid() = user_id AND is_admin_template = false) 
WITH CHECK (auth.uid() = user_id AND is_admin_template = false);

-- Admin can read all measurements
CREATE POLICY "measurements_admin_read" ON public.measurements 
FOR SELECT 
USING (public.is_admin());

-- Admin can create templates (is_admin_template = true)
CREATE POLICY "measurements_admin_create_template" ON public.measurements 
FOR INSERT 
WITH CHECK (public.is_admin() AND is_admin_template = true);

-- Admin can update templates (is_admin_template = true)
CREATE POLICY "measurements_admin_update_template" ON public.measurements 
FOR UPDATE 
USING (public.is_admin() AND is_admin_template = true)
WITH CHECK (public.is_admin() AND is_admin_template = true);

-- Admin can delete templates (is_admin_template = true)
CREATE POLICY "measurements_admin_delete_template" ON public.measurements 
FOR DELETE 
USING (public.is_admin() AND is_admin_template = true);

-- Users can create their own measurement profiles (not templates)
CREATE POLICY "measurements_user_create_profile" ON public.measurements 
FOR INSERT 
WITH CHECK (auth.uid() = user_id AND is_admin_template = false);

-- Users can update their own measurement profiles (not templates)
CREATE POLICY "measurements_user_update_profile" ON public.measurements 
FOR UPDATE 
USING (auth.uid() = user_id AND is_admin_template = false)
WITH CHECK (auth.uid() = user_id AND is_admin_template = false);

-- Users can delete their own measurement profiles (not templates)
CREATE POLICY "measurements_user_delete_profile" ON public.measurements 
FOR DELETE 
USING (auth.uid() = user_id AND is_admin_template = false);

-- Add comment to document the template restrictions
COMMENT ON COLUMN public.measurements.is_admin_template IS 'Indicates if this measurement profile is an admin-created template. Only admins can create/edit/delete templates.';
