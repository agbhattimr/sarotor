-- Add 'in_progress' to the order_status enum if it doesn't already exist.
-- The IF NOT EXISTS clause prevents errors if the value has already been added.
ALTER TYPE public.order_status ADD VALUE IF NOT EXISTS 'in_progress';

-- It appears there might be a check constraint named orders_valid_status
-- that is not in the schema.sql file. This is a common source of errors
-- if the live database schema diverges from the committed schema.
--
-- If the ALTER TYPE command above does not resolve the issue, you may
-- need to investigate the constraints on the public.orders table directly
-- in your Supabase dashboard's SQL editor using a query like:
--
-- SELECT conname, consrc
-- FROM pg_constraint
-- WHERE conrelid = 'public.orders'::regclass;
--
-- This will list the constraints on the table, and you can inspect
-- orders_valid_status to see what the allowed values are. You may need
-- to drop that constraint if it conflicts with the enum type.
