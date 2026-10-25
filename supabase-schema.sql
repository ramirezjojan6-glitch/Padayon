create table if not exists public.user_records (
  user_id uuid not null references auth.users(id) on delete cascade,
  cloud_id uuid not null,
  store text not null check (store in ('files', 'cards', 'quiz', 'plans', 'tasks')),
  data jsonb not null,
  updated_at bigint not null,
  deleted boolean not null default false,
  primary key (user_id, cloud_id)
);

alter table public.user_records enable row level security;
grant select, insert, update, delete on public.user_records to authenticated;

drop policy if exists "Users can access their own records" on public.user_records;
create policy "Users can access their own records"
  on public.user_records
  for all
  to authenticated
  using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);

insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('user-files', 'user-files', false, 52428800, array['application/pdf'])
on conflict (id) do update
  set public = false,
      file_size_limit = excluded.file_size_limit,
      allowed_mime_types = excluded.allowed_mime_types;

drop policy if exists "Users can read their own PDFs" on storage.objects;
create policy "Users can read their own PDFs"
  on storage.objects
  for select
  to authenticated
  using (
    bucket_id = 'user-files'
    and (storage.foldername(name))[1] = (select auth.uid())::text
  );

drop policy if exists "Users can upload PDFs to their own folder" on storage.objects;
create policy "Users can upload PDFs to their own folder"
  on storage.objects
  for insert
  to authenticated
  with check (
    bucket_id = 'user-files'
    and (storage.foldername(name))[1] = (select auth.uid())::text
    and lower(storage.filename(name)) like '%.pdf'
  );

drop policy if exists "Users can update PDFs in their own folder" on storage.objects;
create policy "Users can update PDFs in their own folder"
  on storage.objects
  for update
  to authenticated
  using (
    bucket_id = 'user-files'
    and (storage.foldername(name))[1] = (select auth.uid())::text
  )
  with check (
    bucket_id = 'user-files'
    and (storage.foldername(name))[1] = (select auth.uid())::text
    and lower(storage.filename(name)) like '%.pdf'
  );

drop policy if exists "Users can delete PDFs in their own folder" on storage.objects;
create policy "Users can delete PDFs in their own folder"
  on storage.objects
  for delete
  to authenticated
  using (
    bucket_id = 'user-files'
    and (storage.foldername(name))[1] = (select auth.uid())::text
  );
