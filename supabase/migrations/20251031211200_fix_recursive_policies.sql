-- Create the is_admin function
CREATE OR REPLACE FUNCTION is_admin()
RETURNS boolean AS $$
DECLARE
  is_admin_user boolean;
BEGIN
  SELECT 'admin' = role INTO is_admin_user
  FROM public.profiles
  WHERE user_id = auth.uid();
  RETURN COALESCE(is_admin_user, false);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER
SET search_path = public;

-- Drop all relevant existing policies before creating the new ones
DROP POLICY IF EXISTS "Allow individual access" ON public.orders;
DROP POLICY IF EXISTS "Allow admin access" ON public.orders;
DROP POLICY IF EXISTS "Allow admin update" ON public.orders;
DROP POLICY IF EXISTS "Allow individual access on profiles" ON public.profiles;
DROP POLICY IF EXISTS "Allow individual update on profiles" ON public.profiles;
DROP POLICY IF EXISTS "Allow admin access on profiles" ON public.profiles;
DROP POLICY IF EXISTS "Allow admin update on profiles" ON public.profiles;

-- Recreate the policies using the is_admin function
-- Enable Row Level Security on the orders table
alter table public.orders enable row level security;

-- Create a policy that allows users to see their own orders
create policy "Allow individual access" on public.orders for select
  using (auth.uid() = user_id);

-- Create a policy that allows admin users to see all orders
create policy "Allow admin access" on public.orders for select
  using (is_admin());

-- Create a policy that allows admin users to update orders
create policy "Allow admin update" on public.orders for update
  using (is_admin());

-- Enable Row Level Security on the profiles table
alter table public.profiles enable row level security;

-- Create a policy that allows users to see their own profile
create policy "Allow individual access on profiles" on public.profiles for select
  using (auth.uid() = user_id);

-- Create a policy that allows users to update their own profile
create policy "Allow individual update on profiles" on public.profiles for update
  using (auth.uid() = user_id);

-- Create a policy that allows admin users to see all profiles
create policy "Allow admin access on profiles" on public.profiles for select
  using (is_admin());

-- Create a policy that allows admin users to update all profiles
create policy "Allow admin update on profiles" on public.profiles for update
  using (is_admin());
