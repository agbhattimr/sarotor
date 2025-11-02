-- Create measurement_templates table
CREATE TABLE IF NOT EXISTS public.measurement_templates (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name VARCHAR(50) NOT NULL, -- XS, S, M, L, XL
  description TEXT,
  measurements JSONB NOT NULL, -- Standard measurements for this template
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Insert sample measurement templates
INSERT INTO public.measurement_templates (name, description, measurements) VALUES
('XS', 'Extra Small', '{"neck": 14.5, "chest": 36, "waist": 30, "arm_length": 24, "inseam": 30}'),
('S', 'Small', '{"neck": 15, "chest": 38, "waist": 32, "arm_length": 24.5, "inseam": 31}'),
('M', 'Medium', '{"neck": 15.5, "chest": 40, "waist": 34, "arm_length": 25, "inseam": 32}'),
('L', 'Large', '{"neck": 16, "chest": 42, "waist": 36, "arm_length": 25.5, "inseam": 33}'),
('XL', 'Extra Large', '{"neck": 16.5, "chest": 44, "waist": 38, "arm_length": 26, "inseam": 34}');
