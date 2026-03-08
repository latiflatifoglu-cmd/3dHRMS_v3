# 3dHR İK Sistemi

Modern İnsan Kaynakları Yönetim Platformu - React + Vite + Supabase

## 🚀 Özellikler

- **Çalışan Yönetimi**: Personel bilgileri, organizasyon şeması
- **İşe Alım**: Başvuru takibi, mülakat değerlendirme, aday yönetimi
- **Performans Değerlendirme**: Hedef belirleme, 360° değerlendirme
- **Eğitim & Seminerler**: Online eğitim, canlı seminerler
- **Bordro Yönetimi**: Maaş hesaplama, raporlama
- **Form & Anketler**: Dinamik form oluşturma, anket yönetimi

## 📁 Proje Yapısı

```
atoms_project/
├── src/
│   ├── components/       # Yeniden kullanılabilir UI bileşenleri
│   │   ├── ui/           # Temel UI bileşenleri (Button, Input, Card, vb.)
│   │   ├── dashboard/    # Dashboard bileşenleri
│   │   ├── profile/      # Profil bileşenleri
│   │   ├── payroll/      # Bordro bileşenleri
│   │   ├── forms/        # Form bileşenleri
│   │   └── dialogs/      # Modal/Dialog bileşenleri
│   ├── pages/            # Sayfa bileşenleri
│   │   ├── admin/        # Admin sayfaları
│   │   ├── hr/           # İK sayfaları
│   │   ├── employee/     # Çalışan sayfaları
│   │   ├── manager/      # Yönetici sayfaları
│   │   ├── payroll/      # Bordro sayfaları
│   │   └── candidate/    # Aday sayfaları
│   ├── contexts/         # React Context'ler
│   ├── hooks/            # Custom React Hook'lar
│   ├── layouts/          # Sayfa layout'ları
│   ├── utils/            # Yardımcı fonksiyonlar
│   ├── lib/              # Kütüphane yapılandırmaları
│   └── styles/           # Global stiller
├── public/               # Statik dosyalar
├── database/             # Supabase SQL şemaları
├── index.html            # HTML giriş noktası
├── vite.config.js        # Vite yapılandırması
├── tailwind.config.js    # Tailwind CSS yapılandırması
└── package.json          # Bağımlılıklar ve script'ler
```

## 🛠️ Teknolojiler

- **Frontend**: React 18, Vite
- **Styling**: Tailwind CSS, Radix UI
- **Backend**: Supabase (PostgreSQL, Auth, Storage)
- **State**: React Context API
- **Charts**: Recharts
- **Forms**: React Hook Form
- **Icons**: Lucide React

## 📦 Kurulum

### Gereksinimler
- Node.js 18+
- npm veya pnpm

### Kurulum Adımları

1. **Bağımlılıkları yükleyin:**
```bash
npm install
```

2. **Ortam değişkenlerini ayarlayın:**
```bash
cp .env.example .env
```

`.env` dosyasını Supabase bilgilerinizle güncelleyin:
```env
VITE_SUPABASE_URL=your_supabase_url
VITE_SUPABASE_ANON_KEY=your_anon_key
```

3. **Geliştirme sunucusunu başlatın:**
```bash
npm run dev
```

Uygulama `http://localhost:3000` adresinde çalışacaktır.

## 📜 Kullanılabilir Script'ler

| Script | Açıklama |
|--------|----------|
| `npm run dev` | Geliştirme sunucusunu başlatır |
| `npm run build` | Prodüksiyon için build alır |
| `npm run preview` | Build edilmiş uygulamayı önizler |
| `npm run lint` | ESLint ile kod kontrolü yapar |

## 🗄️ Veritabanı

Supabase veritabanı şemaları `database/` klasöründe bulunmaktadır:

- `supabase_setup.sql` - Ana şema kurulumu
- `create_exam_violations_table.sql` - Sınav ihlalleri tablosu
- `fix_proctoring_rls.sql` - RLS düzeltmeleri

## 🔐 Güvenlik

- Supabase Row Level Security (RLS) aktif
- `SUPABASE_SERVICE_ROLE_KEY` asla frontend'de kullanılmamalıdır
- Tüm API anahtarları `.env` dosyasında saklanmalıdır

## 📄 Lisans

Bu proje özel lisans altındadır. Tüm hakları saklıdır.
