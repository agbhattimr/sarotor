-- Storage buckets and policies

-- Create public bucket for service images
insert into storage.buckets (id, name, public)
values ('service-images', 'service-images', true)
on conflict (id) do nothing;

-- Public read for service images
drop policy if exists "Public read service-images" on storage.objects;
create policy "Public read service-images"
on storage.objects for select
using (bucket_id = 'service-images');

-- Admin write for service images
drop policy if exists "Admin write service-images" on storage.objects;
create policy "Admin write service-images"
on storage.objects for all
using (bucket_id = 'service-images' and public.is_admin())
with check (bucket_id = 'service-images' and public.is_admin());


