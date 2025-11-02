ALTER TABLE measurements
ADD COLUMN template_id UUID REFERENCES measurement_templates(id),
ADD COLUMN is_custom BOOLEAN NOT NULL DEFAULT true;
