# Papan Akrilik Jambi — web katalog

Situs statis: `index.html` + folder `img/`. Tanpa build step.

## Pasang di Netlify
Seret folder ini ke https://app.netlify.com/drop, atau hubungkan repo dan biarkan build command kosong (publish directory: `.`).

## Supabase (sudah aktif)
- Project: papanakrilik-jbi (region Singapore, plan Free)
- Dashboard: https://supabase.com/dashboard/project/emklljioepqzefoopbds
- URL dan publishable key sudah terpasang di index.html. Key ini memang publik; keamanan dijaga RLS.

## Deploy ke Vercel
Import folder ini ke Vercel (Framework Preset: Other, tanpa build command, output directory: `.`), atau jalankan `vercel --prod` di folder ini.

## Pasang ulang di project Supabase lain (opsional)
1. Buat project di Supabase.
2. SQL Editor: jalankan isi `supabase/schema.sql`.
3. Project Settings > API: salin Project URL dan anon public key.
4. Di `index.html`, isi `SUPABASE_URL` dan `SUPABASE_ANON_KEY` (dekat awal `<script>`).
   Jangan pernah memasang `service_role` key di sini.

## Moderasi
Kiriman customer masuk dengan `status = pending` dan belum tampil.
Table Editor > `customer_photos` > ubah `status` menjadi `approved` (tampil) atau `rejected`.

## Ubah produk
Edit daftar `PRODUK` di `index.html`. Foto: `img/<id>.jpg`.
