-- Insert service categories
INSERT INTO public.service_categories (name, description, icon, sort_order, is_active) VALUES
('Women''s Wear', 'Traditional and modern women''s clothing', '👗', 1, true),
('Men''s Wear', 'Traditional and formal men''s clothing', '👔', 2, true),
('Extras', 'Additional services and add-ons', '➕', 3, true),
('Artisanal Add-Ons', 'Custom embroidery and decorative work', '🎨', 4, true)
ON CONFLICT (name) DO NOTHING;

-- Women's Wear services
INSERT INTO public.services (
  category_id, name, description, price_cents, delivery_days, 
  urgent_delivery_days_min, urgent_delivery_days_max, is_coming_soon, service_type, is_active
) VALUES
(
  (SELECT id FROM public.service_categories WHERE name = 'Women''s Wear'),
  'Simple Suit',
  'Basic two-piece suit with simple stitching and standard finish',
  200000, -- 2000 Rs
  15,
  2,
  3,
  false,
  'standard',
  true
),
(
  (SELECT id FROM public.service_categories WHERE name = 'Women''s Wear'),
  'Double Suit',
  'Premium two-piece suit with enhanced detailing and superior finish',
  400000, -- 4000 Rs
  15,
  2,
  3,
  false,
  'standard',
  true
),
(
  (SELECT id FROM public.service_categories WHERE name = 'Women''s Wear'),
  'Paneled Frock Set',
  'Elegant frock with paneled design and matching accessories',
  600000, -- 6000 Rs
  20,
  3,
  5,
  false,
  'standard',
  true
),
(
  (SELECT id FROM public.service_categories WHERE name = 'Women''s Wear'),
  'Sarhi',
  'Traditional sarhi with intricate work and premium fabric',
  700000, -- 7000 Rs
  25,
  null,
  null,
  false,
  'standard',
  true
),
(
  (SELECT id FROM public.service_categories WHERE name = 'Women''s Wear'),
  'Lehenga Set',
  'Complete lehenga set with blouse and dupatta',
  700000, -- 7000 Rs
  30,
  null,
  null,
  false,
  'standard',
  true
),
(
  (SELECT id FROM public.service_categories WHERE name = 'Women''s Wear'),
  'Bridal Set',
  'Luxury bridal wear with heavy embroidery and premium materials',
  800000, -- 8000 Rs
  45,
  null,
  null,
  false,
  'standard',
  true
),
(
  (SELECT id FROM public.service_categories WHERE name = 'Women''s Wear'),
  'Maxi Set',
  'Long maxi dress with elegant design and comfortable fit',
  700000, -- 7000 Rs
  20,
  3,
  5,
  false,
  'standard',
  true
),
(
  (SELECT id FROM public.service_categories WHERE name = 'Women''s Wear'),
  'Trouser',
  'Well-fitted trousers with professional finish',
  80000, -- 800 Rs
  10,
  2,
  3,
  false,
  'standard',
  true
),
(
  (SELECT id FROM public.service_categories WHERE name = 'Women''s Wear'),
  'Shirt',
  'Classic shirt with proper fit and quality stitching',
  140000, -- 1400 Rs
  12,
  2,
  3,
  false,
  'standard',
  true
);

-- Men's Wear services
INSERT INTO public.services (
  category_id, name, description, price_cents, delivery_days, 
  urgent_delivery_days_min, urgent_delivery_days_max, is_coming_soon, service_type, is_active
) VALUES
(
  (SELECT id FROM public.service_categories WHERE name = 'Men''s Wear'),
  'Shalwar Suit Simple',
  'Traditional shalwar kameez with simple design and comfortable fit',
  250000, -- 2500 Rs
  15,
  2,
  3,
  false,
  'standard',
  true
),
(
  (SELECT id FROM public.service_categories WHERE name = 'Men''s Wear'),
  'Pant Coat',
  'Formal pant and coat set with professional tailoring',
  800000, -- 8000 Rs
  20,
  5,
  7,
  false,
  'standard',
  true
),
(
  (SELECT id FROM public.service_categories WHERE name = 'Men''s Wear'),
  'Waistcoat',
  'Stylish waistcoat to complement formal and traditional wear',
  300000, -- 3000 Rs
  12,
  3,
  4,
  false,
  'standard',
  true
),
(
  (SELECT id FROM public.service_categories WHERE name = 'Men''s Wear'),
  'Sherwani',
  'Elegant sherwani for weddings and formal occasions',
  1200000, -- 12000 Rs
  30,
  null,
  null,
  false,
  'standard',
  true
),
(
  (SELECT id FROM public.service_categories WHERE name = 'Men''s Wear'),
  'Kurta',
  'Simple and elegant kurta for casual and semi-formal wear',
  150000, -- 1500 Rs
  10,
  2,
  3,
  false,
  'standard',
  true
);

-- Extras services
INSERT INTO public.services (
  category_id, name, description, price_cents, delivery_days, 
  urgent_delivery_days_min, urgent_delivery_days_max, is_coming_soon, service_type, is_active,
  custom_pricing
) VALUES
(
  (SELECT id FROM public.service_categories WHERE name = 'Extras'),
  'Dupatta Stitching',
  'Professional dupatta stitching with various design options',
  50000, -- Base price 500 Rs
  5,
  1,
  2,
  false,
  'custom_pricing',
  true,
  '{"type": "range", "min_price": 50000, "max_price": 500000, "base_price": 50000}'::jsonb
),
(
  (SELECT id FROM public.service_categories WHERE name = 'Extras'),
  'Pickup/Delivery',
  'Convenient pickup and delivery service for your orders',
  30000, -- 300 Rs
  1,
  null,
  null,
  false,
  'standard',
  true,
  null
),
(
  (SELECT id FROM public.service_categories WHERE name = 'Extras'),
  'External Purchase Handling',
  'Service fee for handling external fabric and material purchases',
  0, -- Percentage-based pricing
  1,
  null,
  null,
  false,
  'external_purchase',
  true,
  '{"type": "percentage", "percentage": 10.0, "min_fee": 10000}'::jsonb
);

-- Artisanal Add-Ons services
INSERT INTO public.services (
  category_id, name, description, price_cents, delivery_days, 
  urgent_delivery_days_min, urgent_delivery_days_max, is_coming_soon, service_type, is_active,
  custom_pricing, service_options
) VALUES
(
  (SELECT id FROM public.service_categories WHERE name = 'Artisanal Add-Ons'),
  'Custom Embroidery',
  'Hand-crafted embroidery work with various patterns and techniques',
  0, -- Custom pricing
  20,
  null,
  null,
  false,
  'artisanal',
  true,
  '{"type": "custom", "base_price": 200000, "factors": {"complexity": {"simple": 1.0, "medium": 1.5, "complex": 2.0}, "coverage": {"small": 1.0, "medium": 1.3, "large": 1.6}}}'::jsonb,
  '{"options": [{"id": "complexity", "name": "Complexity Level", "type": "select", "required": true, "options": {"simple": "Simple", "medium": "Medium", "complex": "Complex"}}, {"id": "coverage", "name": "Coverage Area", "type": "select", "required": true, "options": {"small": "Small", "medium": "Medium", "large": "Large"}}, {"id": "thread_type", "name": "Thread Type", "type": "select", "required": false, "options": {"cotton": "Cotton", "silk": "Silk", "metallic": "Metallic"}}]}'::jsonb
),
(
  (SELECT id FROM public.service_categories WHERE name = 'Artisanal Add-Ons'),
  'Bead Work',
  'Intricate bead work and sequin application',
  0, -- Custom pricing
  25,
  null,
  null,
  false,
  'artisanal',
  true,
  '{"type": "custom", "base_price": 150000, "factors": {"bead_type": {"plastic": 1.0, "glass": 1.5, "crystal": 2.0}, "density": {"light": 1.0, "medium": 1.4, "heavy": 1.8}}}'::jsonb,
  '{"options": [{"id": "bead_type", "name": "Bead Type", "type": "select", "required": true, "options": {"plastic": "Plastic", "glass": "Glass", "crystal": "Crystal"}}, {"id": "density", "name": "Bead Density", "type": "select", "required": true, "options": {"light": "Light", "medium": "Medium", "heavy": "Heavy"}}]}'::jsonb
),
(
  (SELECT id FROM public.service_categories WHERE name = 'Artisanal Add-Ons'),
  'Zardozi Work',
  'Traditional zardozi embroidery with gold and silver threads',
  0, -- Custom pricing
  30,
  null,
  null,
  false,
  'artisanal',
  true,
  '{"type": "custom", "base_price": 500000, "factors": {"thread_quality": {"standard": 1.0, "premium": 1.8, "luxury": 2.5}, "design_complexity": {"simple": 1.0, "detailed": 1.6, "intricate": 2.2}}}'::jsonb,
  '{"options": [{"id": "thread_quality", "name": "Thread Quality", "type": "select", "required": true, "options": {"standard": "Standard", "premium": "Premium", "luxury": "Luxury"}}, {"id": "design_complexity", "name": "Design Complexity", "type": "select", "required": true, "options": {"simple": "Simple", "detailed": "Detailed", "intricate": "Intricate"}}]}'::jsonb
);

-- Add some sample service images (placeholder URLs) - using image_path column
UPDATE public.services SET image_path = 'https://via.placeholder.com/300x400/FF6B6B/FFFFFF?text=Simple+Suit' WHERE name = 'Simple Suit';
UPDATE public.services SET image_path = 'https://via.placeholder.com/300x400/4ECDC4/FFFFFF?text=Double+Suit' WHERE name = 'Double Suit';
UPDATE public.services SET image_path = 'https://via.placeholder.com/300x400/45B7D1/FFFFFF?text=Paneled+Frock' WHERE name = 'Paneled Frock Set';
UPDATE public.services SET image_path = 'https://via.placeholder.com/300x400/96CEB4/FFFFFF?text=Sarhi' WHERE name = 'Sarhi';
UPDATE public.services SET image_path = 'https://via.placeholder.com/300x400/FFEAA7/FFFFFF?text=Lehenga+Set' WHERE name = 'Lehenga Set';
UPDATE public.services SET image_path = 'https://via.placeholder.com/300x400/DDA0DD/FFFFFF?text=Bridal+Set' WHERE name = 'Bridal Set';
UPDATE public.services SET image_path = 'https://via.placeholder.com/300x400/98D8C8/FFFFFF?text=Maxi+Set' WHERE name = 'Maxi Set';
UPDATE public.services SET image_path = 'https://via.placeholder.com/300x400/F7DC6F/FFFFFF?text=Trouser' WHERE name = 'Trouser';
UPDATE public.services SET image_path = 'https://via.placeholder.com/300x400/BB8FCE/FFFFFF?text=Shirt' WHERE name = 'Shirt';
UPDATE public.services SET image_path = 'https://via.placeholder.com/300x400/85C1E9/FFFFFF?text=Shalwar+Suit' WHERE name = 'Shalwar Suit Simple';
UPDATE public.services SET image_path = 'https://via.placeholder.com/300x400/F8C471/FFFFFF?text=Pant+Coat' WHERE name = 'Pant Coat';
UPDATE public.services SET image_path = 'https://via.placeholder.com/300x400/7D3C98/FFFFFF?text=Waistcoat' WHERE name = 'Waistcoat';
UPDATE public.services SET image_path = 'https://via.placeholder.com/300x400/2E86C1/FFFFFF?text=Sherwani' WHERE name = 'Sherwani';
UPDATE public.services SET image_path = 'https://via.placeholder.com/300x400/1ABC9C/FFFFFF?text=Kurta' WHERE name = 'Kurta';
UPDATE public.services SET image_path = 'https://via.placeholder.com/300x400/82E0AA/FFFFFF?text=Dupatta' WHERE name = 'Dupatta Stitching';
UPDATE public.services SET image_path = 'https://via.placeholder.com/300x400/F1948A/FFFFFF?text=Pickup+Delivery' WHERE name = 'Pickup/Delivery';
UPDATE public.services SET image_path = 'https://via.placeholder.com/300x400/85C1E9/FFFFFF?text=External+Purchase' WHERE name = 'External Purchase Handling';
UPDATE public.services SET image_path = 'https://via.placeholder.com/300x400/D7BDE2/FFFFFF?text=Embroidery' WHERE name = 'Custom Embroidery';
UPDATE public.services SET image_path = 'https://via.placeholder.com/300x400/F9E79F/FFFFFF?text=Bead+Work' WHERE name = 'Bead Work';
UPDATE public.services SET image_path = 'https://via.placeholder.com/300x400/FADBD8/FFFFFF?text=Zardozi' WHERE name = 'Zardozi Work';
