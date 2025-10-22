-- Seed data for service categories and services

-- categories
insert into public.service_categories(name)
values ('suits'),('shirts'),('trousers'),('alterations')
on conflict (name) do nothing;

-- services
with cat as (
  select id, name from public.service_categories
)
insert into public.services (category_id, name, description, price_cents, image_path)
select 
  (select id from cat where name = 'suits'), 'Two-Piece Suit', 'Custom tailored two-piece suit', 50000, null
union all
select 
  (select id from cat where name = 'suits'), 'Three-Piece Suit', 'Custom tailored three-piece suit', 65000, null
union all
select 
  (select id from cat where name = 'shirts'), 'Dress Shirt', 'Tailored cotton dress shirt', 8000, null
union all
select 
  (select id from cat where name = 'trousers'), 'Tailored Trousers', 'Custom tailored trousers', 12000, null
union all
select 
  (select id from cat where name = 'alterations'), 'Hem Adjustment', 'Hem shortening/lengthening', 3000, null
on conflict do nothing;


