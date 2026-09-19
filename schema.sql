-- Tabel Trip Plans
CREATE TABLE IF NOT EXISTS public.trip_plans (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Tabel Trip Destinations (Items)
CREATE TABLE IF NOT EXISTS public.trip_plan_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    trip_plan_id UUID NOT NULL REFERENCES public.trip_plans(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    daerah TEXT DEFAULT ''::text,
    harga_rupiah INTEGER DEFAULT 0,
    status TEXT DEFAULT 'planned'::text,
    photo_url TEXT,
    order_index INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Buat aturan bebas masuk untuk trip_plans
CREATE POLICY "Bebas akses untuk siapa saja"
ON public.trip_plans FOR ALL
USING (true)
WITH CHECK (true);

-- Buat aturan bebas masuk untuk trip_plan_items
CREATE POLICY "Bebas akses untuk siapa saja"
ON public.trip_plan_items FOR ALL
USING (true)
WITH CHECK (true);