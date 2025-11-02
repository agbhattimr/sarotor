CREATE TABLE measurement_templates (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name VARCHAR(50) NOT NULL, -- XS, S, M, L, XL
  description TEXT,
  measurements JSONB NOT NULL, -- Standard measurements for this template
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
