-- ==============================================================================
-- SUPABASE SCHEMA & DATABASE SETUP
-- Project: Scaffolding Visual Tracker (SVT) & HSE Inspection Center
-- Database: PostgreSQL (Supabase)
-- 
-- CARA PENGGUNAAN:
-- 1. Buka Supabase Dashboard Anda: https://supabase.com/dashboard/project/zlstjvxirzxaghbcmbod
-- 2. Di menu sebelah kiri, klik "SQL Editor" (ikon terminal/database)
-- 3. Klik tombol "+ New Query"
-- 4. Salin (copy) dan tempel (paste) seluruh isi file ini
-- 5. Klik tombol hijau "Run" (atau tekan Ctrl + Enter)
-- ==============================================================================

-- ------------------------------------------------------------------------------
-- 1. BUAT TABEL UTAMA: public.scaffolds
-- ------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.scaffolds (
    id TEXT PRIMARY KEY,                           -- ID Unik (contoh: SCF-101, SCF-LIN-202)
    tag_number TEXT NOT NULL,                      -- Nomor Tag Fisik (contoh: TAG-GRN-001)
    location TEXT NOT NULL,                        -- Nama Area Landmark / Lokasi Denah
    type TEXT NOT NULL DEFAULT 'POINT',            -- Jenis Konstruksi: 'POINT' (Tower) atau 'LINEAR' (Membentang)
    status TEXT NOT NULL DEFAULT 'ACTIVE',          -- Status HSE: ACTIVE, BUILDING, REQUESTED, EXPIRED, DISMANTLED
    x NUMERIC,                                     -- Koordinat Denah X (persentase 0 - 100)
    y NUMERIC,                                     -- Koordinat Denah Y (persentase 0 - 100)
    points JSONB,                                  -- Titik koordinat jalur membentang [{x, y}, ...]
    install_date TEXT,                             -- Tanggal Pemasangan / Ereksi (YYYY-MM-DD)
    last_inspection TEXT,                          -- Tanggal Inspeksi Terakhir (YYYY-MM-DD)
    target_dismantle_date TEXT,                    -- Target Tanggal Pembongkaran (YYYY-MM-DD)
    actual_dismantle_date TEXT,                    -- Tanggal Aktual Pembongkaran (YYYY-MM-DD)
    inspector TEXT,                                -- Nama Petugas Inspector HSE
    notes TEXT,                                    -- Catatan Lapangan / Keterangan Pekerjaan
    structure_type TEXT DEFAULT 'Independent Tower',-- Tipe Struktur: Independent Tower, Pipe Rack, Catwalk, dll.
    height_meters TEXT DEFAULT '6m',               -- Dimensi Tinggi (meter)
    length_meters TEXT DEFAULT '-',                -- Dimensi Panjang (meter)
    created_at TIMESTAMPTZ DEFAULT NOW(),          -- Timestamp Waktu Dibuat
    updated_at TIMESTAMPTZ DEFAULT NOW()           -- Timestamp Waktu Terakhir Diperbarui
);

-- Komentar Dokumentasi Kolom Tabel
COMMENT ON TABLE public.scaffolds IS 'Tabel data tracking scaffolding, titik lokasi denah, dan jadwal inspeksi HSE';
COMMENT ON COLUMN public.scaffolds.id IS 'Primary key unik scaffolding';
COMMENT ON COLUMN public.scaffolds.points IS 'Array JSON berisi koordinat [{x,y}, ...] untuk tipe linear membentang';

-- ------------------------------------------------------------------------------
-- 2. OTOMATISASI TIMESTAMP: trigger updated_at
-- ------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.handle_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trigger_scaffolds_updated_at ON public.scaffolds;
CREATE TRIGGER trigger_scaffolds_updated_at
BEFORE UPDATE ON public.scaffolds
FOR EACH ROW
EXECUTE FUNCTION public.handle_updated_at();

-- ------------------------------------------------------------------------------
-- 3. INDEX UNTUK PERFORMA PENCARIAN & FILTERING CEPAT
-- ------------------------------------------------------------------------------
CREATE INDEX IF NOT EXISTS idx_scaffolds_status ON public.scaffolds(status);
CREATE INDEX IF NOT EXISTS idx_scaffolds_tag_number ON public.scaffolds(tag_number);
CREATE INDEX IF NOT EXISTS idx_scaffolds_last_inspection ON public.scaffolds(last_inspection);
CREATE INDEX IF NOT EXISTS idx_scaffolds_location ON public.scaffolds(location);

-- ------------------------------------------------------------------------------
-- 4. ROW LEVEL SECURITY (RLS) & KEBIJAKAN AKSES BROWSER
-- ------------------------------------------------------------------------------
-- Aktifkan Row Level Security
ALTER TABLE public.scaffolds ENABLE ROW LEVEL SECURITY;

-- Beri izin akses penuh (SELECT, INSERT, UPDATE, DELETE) untuk Publishable Key (role anon)
DROP POLICY IF EXISTS "Akses Penuh Scaffolds Anon" ON public.scaffolds;
CREATE POLICY "Akses Penuh Scaffolds Anon" 
ON public.scaffolds 
FOR ALL 
TO anon 
USING (true) 
WITH CHECK (true);

-- Beri izin akses untuk pengguna terautentikasi (authenticated) jika di kemudian hari memakai login Supabase Auth
DROP POLICY IF EXISTS "Akses Penuh Scaffolds Auth" ON public.scaffolds;
CREATE POLICY "Akses Penuh Scaffolds Auth" 
ON public.scaffolds 
FOR ALL 
TO authenticated 
USING (true) 
WITH CHECK (true);

-- ------------------------------------------------------------------------------
-- 5. HAK OPERASI DATABASE (GRANT PERMISSIONS)
-- ------------------------------------------------------------------------------
GRANT ALL ON TABLE public.scaffolds TO anon;
GRANT ALL ON TABLE public.scaffolds TO authenticated;
GRANT ALL ON TABLE public.scaffolds TO service_role;

-- ------------------------------------------------------------------------------
-- 6. AKTIFKAN REPLIKASI REALTIME
-- ------------------------------------------------------------------------------
-- Memastikan tabel masuk ke kanal Realtime Supabase agar update antar tab/perangkat live
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_publication_tables 
        WHERE pubname = 'supabase_realtime' 
        AND schemaname = 'public' 
        AND tablename = 'scaffolds'
    ) THEN
        ALTER PUBLICATION supabase_realtime ADD TABLE public.scaffolds;
    END IF;
END $$;

-- ==============================================================================
-- SELESAI. Script telah siap 100%.
-- Tabel "scaffolds" siap menerima data dari mapping.html & database.html
-- ==============================================================================
