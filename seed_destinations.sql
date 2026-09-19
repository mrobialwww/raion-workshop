-- Membuat 1 Trip Plan Induk dengan ID buatan untuk keperluan seed.
INSERT INTO public.trip_plans (id, user_id, title, created_at)
VALUES 
  ('12345678-1234-5678-1234-567812345678', 'SILAKAN_ISI_DENGAN_USER_ID_ANDA', 'Trip Wisatain (Data Contoh)', NOW())
ON CONFLICT (id) DO NOTHING;

-- Langsung menyisipkan anak-anak destinasi menggunakan ID Trip Plan statis yang baru dibuat di atas
INSERT INTO public.trip_plan_items (trip_plan_id, name, daerah, harga_rupiah, status, order_index, created_at, photo_url, updated_at)
VALUES 
  ('12345678-1234-5678-1234-567812345678', 'Pantai Kelingking', 'Bali', 250000, 'planned', 0, NOW(), NULL, NOW()),
  ('12345678-1234-5678-1234-567812345678', 'Bromo Sunrise', 'Jawa Timur', 400000, 'planned', 1, NOW(), NULL, NOW()),
  ('12345678-1234-5678-1234-567812345678', 'Raja Ampat', 'Papua Barat', 1500000, 'planned', 2, NOW(), NULL, NOW()),
  ('12345678-1234-5678-1234-567812345678', 'Danau Toba', 'Sumatera Utara', 300000, 'planned', 3, NOW(), NULL, NOW()),
  ('12345678-1234-5678-1234-567812345678', 'Kawah Ijen', 'Jawa Timur', 350000, 'planned', 4, NOW(), NULL, NOW());