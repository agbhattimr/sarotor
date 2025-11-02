-- Promote user to admin role
-- User ID: 68c3df1c-0738-4986-8780-5cf4265cdf3a
-- Email: sartorbase@gmail.com

-- 1. Query to check current role and profile
SELECT
  p.user_id,
  p.full_name,
  p.phone,
  p.role,
  p.created_at,
  u.email
FROM public.profiles p
INNER JOIN auth.users u ON p.user_id = u.id
WHERE p.user_id = '68c3df1c-0738-4986-8780-5cf4265cdf3a'::uuid
  AND u.email = 'sartorbase@gmail.com';

-- 2. UPDATE query to set role = 'admin' for this user_id
UPDATE public.profiles
SET role = 'admin'
WHERE user_id = '68c3df1c-0738-4986-8780-5cf4265cdf3a'::uuid;

-- 3. Verification query to confirm the role change
SELECT
  p.user_id,
  p.full_name,
  p.phone,
  p.role,
  p.created_at,
  u.email
FROM public.profiles p
INNER JOIN auth.users u ON p.user_id = u.id
WHERE p.user_id = '68c3df1c-0738-4986-8780-5cf4265cdf3a'::uuid
  AND u.email = 'sartorbase@gmail.com';

-- 4. Complete sequence with proper error handling
DO $$
DECLARE
    current_role text;
    user_exists boolean := false;
BEGIN
    -- Check if user exists and get current role
    SELECT EXISTS(
        SELECT 1
        FROM public.profiles p
        INNER JOIN auth.users u ON p.user_id = u.id
        WHERE p.user_id = '68c3df1c-0738-4986-8780-5cf4265cdf3a'::uuid
          AND u.email = 'sartorbase@gmail.com'
    ) INTO user_exists;

    IF NOT user_exists THEN
        RAISE EXCEPTION 'User with ID % and email % not found', '68c3df1c-0738-4986-8780-5cf4265cdf3a', 'sartorbase@gmail.com';
    END IF;

    -- Get current role
    SELECT p.role INTO current_role
    FROM public.profiles p
    WHERE p.user_id = '68c3df1c-0738-4986-8780-5cf4265cdf3a'::uuid;

    -- Check if already admin
    IF current_role = 'admin' THEN
        RAISE NOTICE 'User % is already an admin', '68c3df1c-0738-4986-8780-5cf4265cdf3a';
        RETURN;
    END IF;

    -- Update role to admin
    UPDATE public.profiles
    SET role = 'admin'
    WHERE user_id = '68c3df1c-0738-4986-8780-5cf4265cdf3a'::uuid;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Failed to update role for user ID %', '68c3df1c-0738-4986-8780-5cf4265cdf3a';
    END IF;

    -- Verify the update
    SELECT p.role INTO current_role
    FROM public.profiles p
    WHERE p.user_id = '68c3df1c-0738-4986-8780-5cf4265cdf3a'::uuid;

    IF current_role != 'admin' THEN
        RAISE EXCEPTION 'Role update failed - current role is %', current_role;
    END IF;

    RAISE NOTICE 'Successfully promoted user % (email: %) to admin role', '68c3df1c-0738-4986-8780-5cf4265cdf3a', 'sartorbase@gmail.com';

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Error promoting user to admin: %', SQLERRM;
END $$;
