-- Tailoring MVP - Database Schema (Supabase)
-- Run this in Supabase SQL Editor. Requires pgcrypto/uuid-ossp for gen_random_uuid().

-- Enable required extension (already available in Supabase, safe to call)
create extension if not exists pgcrypto;

-- profiles
create table if not exists public.profiles (
  user_id uuid primary key references auth.users(id) on delete cascade,
  full_name text,
  phone text,
  role text not null default 'client' check (role in ('client', 'rider', 'tailor', 'manager', 'admin')),
  created_at timestamptz default now()
);

-- measurements (inches)
create table if not exists public.measurements (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  profile_name text not null,
  neck numeric(5,2),
  chest numeric(5,2),
  waist numeric(5,2),
  arm_length numeric(5,2),
  inseam numeric(5,2),
  style_prefs jsonb default '{}'::jsonb,
  created_at timestamptz default now()
);

-- service catalog
create table if not exists public.service_categories (
  id bigint primary key generated always as identity,
  name text not null unique
);

create table if not exists public.services (
  id bigint primary key generated always as identity,
  category_id bigint not null references public.service_categories(id) on delete restrict,
  name text not null,
  description text,
  price_cents int not null,
  image_path text,
  is_active boolean not null default true
);

-- orders
do $$
begin
  if not exists (select 1 from pg_type where typname = 'order_status') then
    create type order_status as enum ('pending','in_progress','ready','completed','cancelled');
  end if;
end $$;

create table if not exists public.orders (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  measurement_id uuid references public.measurements(id),
  status order_status not null default 'pending',
  total_cents int not null default 0,
  notes text,
  created_at timestamptz default now()
);

-- order items: supports multi-service + quantities; price snapshot captured at order time
create table if not exists public.order_items (
  id uuid primary key default gen_random_uuid(),
  order_id uuid not null references public.orders(id) on delete cascade,
  service_id bigint not null references public.services(id) on delete restrict,
  quantity int not null default 1 check (quantity > 0),
  price_cents int not null check (price_cents >= 0)
);

create unique index if not exists order_items_unique_service_per_order on public.order_items(order_id, service_id);

create table if not exists public.order_status_history (
  id bigint primary key generated always as identity,
  order_id uuid not null references public.orders(id) on delete cascade,
  status order_status not null,
  changed_by uuid references auth.users(id),
  changed_at timestamptz default now()
);

-- RPC to recalculate order totals from items
create or replace function public.update_order_total(p_order_id uuid)
returns void language sql security definer as $$
  update public.orders o
  set total_cents = coalesce((
    select sum(oi.quantity * oi.price_cents)
    from public.order_items oi
    where oi.order_id = p_order_id
  ), 0)
  where o.id = p_order_id;
$$;
