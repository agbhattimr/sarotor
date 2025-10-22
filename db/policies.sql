-- Enable Row Level Security on the orders table
alter table public.orders enable row level security;

-- Create a policy that allows users to see their own orders
create policy "Allow individual access" on public.orders for select
  using (auth.uid() = user_id);

-- Create a policy that allows admin users to see all orders
create policy "Allow admin access" on public.orders for select
  using (
    (select role from public.profiles where user_id = auth.uid()) = 'admin'
  );

-- Create a policy that allows admin users to update orders
create policy "Allow admin update" on public.orders for update
  using (
    (select role from public.profiles where user_id = auth.uid()) = 'admin'
  );
