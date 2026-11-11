-- Papan Akrilik Jambi: foto + komentar customer
-- Jalankan sekali di Supabase > SQL Editor.

-- 1) Tabel
create table if not exists public.customer_photos (
  id          uuid primary key default gen_random_uuid(),
  name        text not null check (char_length(name) between 1 and 40),
  comment     text not null check (char_length(comment) between 1 and 300),
  product_id  text check (product_id is null or char_length(product_id) <= 60),
  image_path  text not null unique check (image_path ~ '^[0-9a-f-]{36}\.jpg$'),
  status      text not null default 'pending' check (status in ('pending','approved','rejected')),
  created_at  timestamptz not null default now()
);
create index if not exists customer_photos_status_created_idx
  on public.customer_photos (status, created_at desc);

-- 2) Row Level Security: publik hanya bisa MEMBACA yang approved dan MENGIRIM baris baru.
alter table public.customer_photos enable row level security;

drop policy if exists "publik baca yang approved" on public.customer_photos;
create policy "publik baca yang approved" on public.customer_photos
  for select to anon, authenticated using (status = 'approved');

drop policy if exists "publik kirim pending" on public.customer_photos;
create policy "publik kirim pending" on public.customer_photos
  for insert to anon, authenticated with check (status = 'pending');

-- 3) Hak kolom: publik tidak bisa mengisi status/id/created_at sendiri, jadi status selalu 'pending'.
revoke all on public.customer_photos from anon, authenticated;
grant select on public.customer_photos to anon, authenticated;
grant insert (name, comment, product_id, image_path) on public.customer_photos to anon, authenticated;

-- 4) Storage: bucket publik (hanya baca), maks 5 MB, hanya gambar.
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('customer-photos', 'customer-photos', true, 5242880, array['image/jpeg','image/png','image/webp'])
on conflict (id) do update
  set public = excluded.public,
      file_size_limit = excluded.file_size_limit,
      allowed_mime_types = excluded.allowed_mime_types;

drop policy if exists "publik unggah foto customer" on storage.objects;
create policy "publik unggah foto customer" on storage.objects
  for insert to anon, authenticated with check (bucket_id = 'customer-photos');

-- MODERASI (lewat Table Editor atau SQL):
--   update public.customer_photos set status = 'approved' where id = '<id>';
--   update public.customer_photos set status = 'rejected' where id = '<id>';
