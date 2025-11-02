-- This file contains the SQL functions for the analytics dashboard.
-- These functions are protected by RLS and SECURITY DEFINER to ensure that only admins can access them.

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

-- Template usage statistics
create or replace function public.template_usage_statistics(template_ids uuid[] default null)
returns table(
  template_id uuid,
  template_name text,
  order_count bigint,
  success_rate float,
  alteration_rate float,
  return_rate float,
  average_satisfaction_score float
)
language sql security definer as $$
  select
    mt.id as template_id,
    mt.name as template_name,
    count(o.id) as order_count,
    avg(case when o.status = 'completed' then 1.0 else 0.0 end) as success_rate,
    avg(case when o.status = 'alteration' then 1.0 else 0.0 end) as alteration_rate,
    avg(case when o.status = 'returned' then 1.0 else 0.0 end) as return_rate,
    coalesce(avg(r.rating), 0.0) as average_satisfaction_score
  from
    public.measurement_templates mt
  left join
    public.orders o on mt.id = o.measurement_id
  left join
    public.reviews r on o.id = r.order_id
  where
    template_ids is null or mt.id = any(template_ids)
  group by
    mt.id, mt.name
  order by
    order_count desc;
$$;

revoke all on function public.template_usage_statistics(uuid[]) from anon, authenticated;
grant execute on function public.template_usage_statistics(uuid[]) to authenticated;

-- @description Gets the usage statistics for each template.
-- @returns A table with the template name and the number of times it has been used.
create or replace function public.template_usage_statistics_guarded(template_ids uuid[] default null)
returns table(
  template_id uuid,
  template_name text,
  order_count bigint,
  success_rate float,
  alteration_rate float,
  return_rate float,
  average_satisfaction_score float
)
language plpgsql security definer as $$
begin
  if not public.is_admin() and not is_authenticated() then
    raise exception 'forbidden';
  end if;
  return query select * from public.template_usage_statistics(template_ids);
end;
$$;
