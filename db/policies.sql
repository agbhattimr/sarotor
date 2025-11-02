-- Enable Row Level Security on the orders table
alter table public.orders enable row level security;

-- Create a policy that allows users to see their own orders
drop policy if exists "Allow individual access" on public.orders;
create policy "Allow individual access" on public.orders for select
  using (auth.uid() = user_id);

-- Create a policy that allows admin users to see all orders
drop policy if exists "Allow admin access" on public.orders;
create policy "Allow admin access" on public.orders for select
  using (is_admin(auth.uid()));

-- Create a policy that allows admin users to update orders
drop policy if exists "Allow admin update" on public.orders;
create policy "Allow admin update" on public.orders for update
  using (is_admin(auth.uid()));

-- Enable Row Level Security on the profiles table
alter table public.profiles enable row level security;

-- Create a policy that allows users to see their own profile
drop policy if exists "Allow individual access on profiles" on public.profiles;
create policy "Allow individual access on profiles" on public.profiles for select
  using (auth.uid() = user_id);

-- Create a policy that allows users to update their own profile
drop policy if exists "Allow individual update on profiles" on public.profiles;
create policy "Allow individual update on profiles" on public.profiles for update
  using (auth.uid() = user_id);

-- Create a policy that allows admin users to see all profiles
drop policy if exists "Allow admin access on profiles" on public.profiles;
create policy "Allow admin access on profiles" on public.profiles for select
  using (is_admin(auth.uid()));

-- Create a policy that allows admin users to update all profiles
drop policy if exists "Allow admin update on profiles" on public.profiles;
create policy "Allow admin update on profiles" on public.profiles for update
  using (is_admin(auth.uid()));

-- Enable RLS for services table
alter table public.services enable row level security;

-- Allow anyone to view services
drop policy if exists "Allow public read access on services" on public.services;
create policy "Allow public read access on services" on public.services for select
  using (true);

-- Allow admin to insert new services
drop policy if exists "Allow admin insert on services" on public.services;
create policy "Allow admin insert on services" on public.services for insert
  with check (is_admin(auth.uid()));

-- Allow admin to update services
drop policy if exists "Allow admin update on services" on public.services;
create policy "Allow admin update on services" on public.services for update
  using (is_admin(auth.uid()));

-- Allow admin to delete services
drop policy if exists "Allow admin delete on services" on public.services;
create policy "Allow admin delete on services" on public.services for delete
  using (is_admin(auth.uid()));

-- Enable RLS for order_status_history table
alter table public.order_status_history enable row level security;

-- Allow admin to insert into order_status_history
drop policy if exists "Allow admin insert on order_status_history" on public.order_status_history;
create policy "Allow admin insert on order_status_history" on public.order_status_history for insert
  with check (is_admin(auth.uid()));

-- Allow admin to view order_status_history
drop policy if exists "Allow admin access on order_status_history" on public.order_status_history;
create policy "Allow admin access on order_status_history" on public.order_status_history for select
  using (is_admin(auth.uid()));

-- Allow users to view their own order_status_history
drop policy if exists "Allow individual access on order_status_history" on public.order_status_history;
create policy "Allow individual access on order_status_history" on public.order_status_history for select
  using (auth.uid() in (select user_id from public.orders where id = order_id));
