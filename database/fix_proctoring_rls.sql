-- =====================================================
-- FIX: workflow_proctoring_settings RLS Policies
-- =====================================================
-- Bu script, proctoring ayarlarının doğru çalışması için
-- gerekli tablo ve RLS politikalarını oluşturur/düzeltir.
-- 
-- Supabase Dashboard > SQL Editor'da çalıştırın.
-- =====================================================

-- 1. Tablo yoksa oluştur
CREATE TABLE IF NOT EXISTS workflow_proctoring_settings (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    workflow_id UUID NOT NULL UNIQUE,
    enabled BOOLEAN DEFAULT false,
    camera_enabled BOOLEAN DEFAULT true,
    microphone_enabled BOOLEAN DEFAULT true,
    screen_share_enabled BOOLEAN DEFAULT true,
    fullscreen_enforcement BOOLEAN DEFAULT true,
    copy_paste_prevention BOOLEAN DEFAULT true,
    right_click_prevention BOOLEAN DEFAULT true,
    second_person_detection BOOLEAN DEFAULT true,
    new_tab_detection BOOLEAN DEFAULT true,
    developer_tools_detection BOOLEAN DEFAULT true,
    window_blur_detection BOOLEAN DEFAULT true,
    suspicious_activity_detection BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. RLS'yi etkinleştir
ALTER TABLE workflow_proctoring_settings ENABLE ROW LEVEL SECURITY;

-- 3. Mevcut politikaları temizle (hata verirse devam et)
DROP POLICY IF EXISTS "Allow authenticated users to read proctoring settings" ON workflow_proctoring_settings;
DROP POLICY IF EXISTS "Allow authenticated users to insert proctoring settings" ON workflow_proctoring_settings;
DROP POLICY IF EXISTS "Allow authenticated users to update proctoring settings" ON workflow_proctoring_settings;
DROP POLICY IF EXISTS "Allow public read for proctoring settings" ON workflow_proctoring_settings;
DROP POLICY IF EXISTS "proctoring_settings_select" ON workflow_proctoring_settings;
DROP POLICY IF EXISTS "proctoring_settings_insert" ON workflow_proctoring_settings;
DROP POLICY IF EXISTS "proctoring_settings_update" ON workflow_proctoring_settings;

-- 4. Yeni RLS politikaları oluştur

-- SELECT: Tüm authenticated kullanıcılar okuyabilir
CREATE POLICY "proctoring_settings_select" 
ON workflow_proctoring_settings 
FOR SELECT 
TO authenticated 
USING (true);

-- INSERT: Authenticated kullanıcılar ekleyebilir
CREATE POLICY "proctoring_settings_insert" 
ON workflow_proctoring_settings 
FOR INSERT 
TO authenticated 
WITH CHECK (true);

-- UPDATE: Authenticated kullanıcılar güncelleyebilir
CREATE POLICY "proctoring_settings_update" 
ON workflow_proctoring_settings 
FOR UPDATE 
TO authenticated 
USING (true)
WITH CHECK (true);

-- 5. Aday kullanıcıları için de okuma izni (sınav sırasında ayarları okuyabilmeleri için)
-- Bu politika, candidate rolündeki kullanıcıların da ayarları okumasını sağlar
CREATE POLICY "Allow public read for proctoring settings" 
ON workflow_proctoring_settings 
FOR SELECT 
TO anon 
USING (true);

-- 6. Test verisi ekle (opsiyonel - belirli bir workflow için)
-- Aşağıdaki satırı kendi workflow_id'niz ile güncelleyin
-- INSERT INTO workflow_proctoring_settings (workflow_id, enabled)
-- VALUES ('b2626cfe-10ae-4f3f-9296-a967b65095fb', true)
-- ON CONFLICT (workflow_id) DO UPDATE SET enabled = true, updated_at = NOW();

-- =====================================================
-- DOĞRULAMA: Aşağıdaki sorguyu çalıştırarak kontrol edin
-- =====================================================
-- SELECT * FROM workflow_proctoring_settings;