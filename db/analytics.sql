-- Admin analytics RPCs (admin-only via RLS and SECURITY DEFINER)

create or replace function public.analytics_overview()
returns table(total_orders bigint, revenue_cents bigint, pending bigint, in_progress bigint, ready bigint, completed bigint, cancelled bigint)
language sql security definer as $$
  select
    (select count(*) from public.orders) as total_orders,
    (select coalesce(sum(total_cents),0) from public.orders) as revenue_cents,
    (select count(*) from public.orders where status = 'pending') as pending,
    (select count(*) from public.orders where status = 'in_progress') as in_progress,
    (select count(*) from public.orders where status = 'ready') as ready,
    (select count(*) from public.orders where status = 'completed') as completed,
    (select count(*) from public.orders where status = 'cancelled') as cancelled;
$$;

revoke all on function public.analytics_overview() from anon, authenticated;
grant execute on function public.analytics_overview() to authenticated;

-- Allow only admins to execute using RLS-like guard inside a wrapper
create or replace function public.analytics_overview_guarded()
returns table(total_orders bigint, revenue_cents bigint, pending bigint, in_progress bigint, ready bigint, completed bigint, cancelled bigint)
language plpgsql security definer as $$
begin
  if not public.is_admin() then
    raise exception 'forbidden';
  end if;
  return query select * from public.analytics_overview();
end;
$$;


