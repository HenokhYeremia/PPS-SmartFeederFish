# 04 — Design System & Blueprint UI "Premium"

> Status: **SEBAGIAN** — chunk C1 (tokens/theme/font) dan C2 (auth
> premium) selesai & terverifikasi 2026-10-22 (analyze 0 issue,
> 7 test hijau). Audit di bawah menggambarkan kondisi **sebelum
> C1/C2**; C3–C4 (dashboard shell, aset/launcher/splash) masih
> BLUEPRINT.

## 1. Audit: Kenapa UI Saat Ini Terasa "Jelek" / Bukan Premium

| # | Masalah | Bukti di kode |
|---|---|---|
| 1 | **Theme hampir kosong.** Hanya seed teal + varian AppBar + margin card — semua widget lain memakai default generator M3 sehingga tampil seperti template Flutter | `lib/app/theme.dart` (50 baris) |
| 2 | **Tidak ada font custom.** Default Roboto; `pubspec.yaml` bahkan tidak punya blok assets/fonts | `pubspec.yaml` |
| 3 | **Form login polos.** Field tanpa ikon, tanpa toggle lihat-password, pesan sukses/error hanyalah `Text` kecil di bawah; tidak ada branding/hero dasbor | `auth_page.dart` |
| 4 | **Pasca-login = placeholder.** Teks "Application foundation ready" + UID/email — bukan wajah produk | `foundation_page.dart` |
| 5 | **Loading satu-satunya** `CircularProgressIndicator` default | `auth_gate.dart` |
| 6 | **Tidak ada state desain**: empty/error/skeleton tidak ada konsepnya | seluruh `lib/` |
| 7 | **Tidak ada splash screen**, launcher icon masih bawaan Flutter, tidak ada logo/aset sama sekali | `android/`, `chrome/web/icons` |
| 8 | **Tidak ada motion**: semua transisi instan (push default, tanpa animasi konten) | seluruh `lib/` |
| 9 | **Dark mode "gratis" dari seed** — belum pernah didesain (kontras & tone tidak dikontrol) | `theme.dart` |
| 10 | `-databaseURL` belum ada, sehingga UI dengan data sensor asli memang belum mungkin — tapi itu tidak menghalangi shell UI premium dengan data tiruan terpisah | `firebase_options.dart` |

Intinya: aplikasi ini baru punya **fondasi logika**; lapisan **identitas
visual belum pernah dibuat**. Itulah mengapa terasa jelek.

## 2. Prinsip (target quality bar)

1. **Satu sumber token**: warna, tipografi, spacing, radius, motion —
   semuanya konstanta di `lib/app/design_tokens.dart`, tidak ada
   angka ajaib tersebar di layar.
2. **Setiap state punya desain**: loading (skeleton), empty, error
   (dengan retry), sukses.
3. **Motion halus & jarang**: 150–350 ms, satu kurva khas, fade-through
   antar halaman; animasi hanya pada feedback, bukan dekorasi.
4. **Hierarki permukaan**: background tinted halus, card putih/gelap
   dengan radius besar; tanpa border kasar.
5. **Dark mode didesain ulang**, bukan hasil seed otomatis.

## 3. Design Tokens (usulan)

### 3.1 Warna — family "Lagoon" (melanjutkan teal yang sudah jadi identitas)

| Token | Light | Dark | Pemakaian |
|---|---|---|---|
| `bg` | `#F3F7F6` | `#0C1719` | latar Scaffold |
| `surface` | `#FFFFFF` | `#112124` | card |
| `surfaceAlt` | `#EEF4F3` | `#16292C` | chip, input filled |
| `primary` | `#0E7A6C` | `#2BB69B` | aksi utama, brand |
| `primarySoft` | `#D8F1EB` | `#0E3B34` | ikon-tone, badge |
| `accentFeed` | `#F59E0B` | `#FBBF24` | aksi "Feed sekarang", stok |
| `warn` | `#D97706` / container `#FEF3C7` | `#F59E0B` / `#3B2F0B` | stok rendah |
| `danger` | `#DC2626` / container `#FEE2E2` | `#F87171` / `#3B1212` | gagal, offline |
| `success` | `#16A34A` | `#4ADE80` | online, ack sukses |
| `textPrimary` | `#0F2A27` | `#E6F2F0` | judul/nilai |
| `textSecondary` | `#5B7370` | `#93AAA7` | subteks |

### 3.2 Tipografi

- Display/heading: **Plus Jakarta Sans** (700/600) — karakter modern & tegas.
- Body: **Inter** (400/500). Keduanya berlisensi SIL (OFL) — bebas dibundel.
- Scale: display 28/34 · h1 24/32 · h2 20/28 · title 16/24 · body 14/20 ·
  label 12/16 (ukuran/tracking). Angka sensor pakai tabular figures.

### 3.3 Spacing & Radius

- Spacing 4-base: `4, 8, 12, 16, 24, 32, 48`. Padding layar standar **16**,
  antar-card **12**, dalam-card **16**.
- Radius: `sm 10` (chip/badge), `md 14` (field/tombol), `lg 20` (card),
  `xl 28` (sheet/hero card), `full` (pill).
- Bayangan: card datar dengan shadow lembut
  `0 8 24 rgba(12,58,54,0.08)` — bukan `elevation` bawaan yang keras.

### 3.4 Motion

| Token | Nilai | Pemakaian |
|---|---|---|
| `motionFast` | 150 ms, `easeOutCubic` | hover/press, chip |
| `motionBase` | 250 ms, `Curves.easeOutCubicEmphasized`-like | fade-through halaman |
| `motionSlow` | 350 ms | splash, sheet |
| `motionSpring` | `Curves.easeOutBack` ringan | konfirmasi feed success (pop ikon) |

## 4. ThemeData Target (daftar component theme yang harus disetel)

Semua jadi satu `SmartFishFeederTheme.from(Brightness)`:

- `AppBarTheme`: surface transparan di atas `bg`, judul `title` XL,
  tanpa bayangan; `CenterTitle` false.
- `CardTheme`: radius 20, `surfaceTone`, shadow token §3.3, margin 12,
  tanpa border.
- `FilledButtonTheme`: tinggi min 48, radius 14, teks label-large,
  warna `primary`; `onPressed == null` → tone muted.
- `OutlinedButtonTheme`/`TextButtonTheme`: radius 14, tanpa garis berlebihan.
- `InputDecorationTheme`: `filled`, warna `surfaceAlt`, radius 14,
  `contentPadding 16`, border fokus = garis `primary` 1.6 px,
  prefixIcon tone `textSecondary`.
- `ChipThemeData`: radius `full`, `surfaceAlt`, label kecil 12.
- `SnackBarThemeData`: floating, radius 12, inverseSurface.
- `DialogTheme`, `BottomSheetTheme` radius 28 atas.
- `ProgressIndicatorTheme` warna `primary`, track tipis.
- `DividerTheme` tipis `surfaceAlt`.

## 5. Komponen Baru (dari widget bawaan, tanpa package UI berat)

| Komponen | Spesifikasi ringkas |
|---|---|
| `StatCard` | header (ikon-tone + label), nilai besar tabular, sub (delta/waktu); varian loading = `ShimmerBox` |
| `TurbidityCard` | StatCard + mini gauge/line (fl_chart), warna dinamis: hijau/amber/merah berdasar ambang |
| `FeedStockCard` | bar progress berwarna + "±X hari tersisa" (estimasi dari portion) |
| `DeviceStatusBadge` | pill: dot `success`/`danger` + label Online/Offline/Provisioning |
| `PrimaryActionFeed` | tombol blok besar `accentFeed`, ikon tray pakan; saat busy → spinner inline; sukses → pop ikon ✔ |
| `EmptyState` | ilustrasi vektor kecil + judul + deskripsi + CTA (dipakai riwayat kosong, perangkat kosong) |
| `ErrorState` / `ErrorBanner` | ikon `danger`, pesan aman-tampil, tombol Coba lagi |
| `ShimmerBox` | skeleton pulse `surfaceAlt` |
| `SectionHeader` | judul + aksi link (mis. "Riwayat ›") |
| `AppScaffoldPage` | konsistensi padding/background antar halaman |
| `ConfirmDialog` | radius 28, teks tegas, tombol bahaya merah |

## 6. Blueprint Per Layar

### 6.1 Splash
Gradasi vertikal `bg→primarySoft`, logo mark (vektor sederhana feeder/
ekor ikan), fade+scale 350 ms → AuthGate. Implementasi native splash
(`flutter_native_splash`) agar transisi tanpa blank putih.

### 6.2 Auth (ganti `auth_page.dart` sepenuhnya)
- Bagian atas: logo + nama + tagline "Jadwal pakannya, air tetap jernih".
- Card form radius 24, padding 24, gap 20.
- Field email: prefix `Icons.alternate_email`, field password: prefix
  gembok + suffix mata (toggle `obscureText`).
- Validasi inline (sudah ada), tampil sebagai banner error berisi ikon
  di atas tombol — bukan `Text` kecil.
- Tombol utama 48 px, saat busy → `CircularProgressIndicator` kecil di
  dalam tombol (label diganti "Memproses").
- Footer: switch Login/Register + tautan "Lupa kata sandi?" (bahkan
  kalau backendnya menyusul, wajib tampil sebab flow tersendiri).

### 6.3 Dashboard (ganti `foundation_page.dart`, Step 12)
- Header: greeting ("Halo, …") + avatar initial + nama kolam.
- Hero card perangkat: nama + `DeviceStatusBadge`, nilai turbidity
  (angka besar + trend), stok (bar), CTA **Feed sekarang**.
- Grid 2 kolom: kartu Turbidity (grafik 24 jam) & Stok pakan.
- Section Riwayat: 3 entri terakhir → tombol "Lihat semua".
- Empty/offline: `EmptyState` + tombol "Tambah perangkat".
- Data dummy untuk shell hanya lewat `DevDataSource` terisolasi;
  tidak boleh sekali pun menulis data tiruan ke RTDB.

### 6.4 Riwayat Feed
List timeline (manual/jadwal/ack gagal), filter chips, empty state.

### 6.5 Jadwal
List kartu (waktu besar, porsi, switch aktif), FAB "Tambah" → bottom
sheet time picker, delete via swipe + confirm dialog.

### 6.6 Perangkat
Kartu perangkat (nama, badge, last-seen), aksi rename/hapus; alur
tambah = wizard provisioning (menunggu D-1/D-4).

### 6.7 Pengaturan/Akun
Theme (system/light/dark), preferensi notifikasi, email, logout,
versi app.

## 7. Checklist "Premium Quality Bar" (audit rilis UI)

- [ ] Font custom terbundel + tabular figures untuk angka sensor.
- [ ] Semua warna dari token — `grep` tidak menemukan `Color(0x` di features.
- [ ] Dark mode sinkron light (respons `Theme.of(context)`; tidak hex mentah).
- [ ] Login & pasca-login tidak lagi memakai teks placeholder.
- [ ] Trend/state lengkap: loading skeleton, empty, error + retry.
- [ ] Launcher icon + splash custom (tidak ada logo Flutter default).
- [ ] Transisi antar halaman fade-through; konfirmasi feed punya feedback.
- [ ] Target sentuh ≥ 44 px; tooltip pada ikon (sudah sebagian ada).
- [ ] Teks 100% bahasa Indonesia yang konsisten.
- [ ] Visibilitas password; error auth tampil sebagai banner.

## 8. Implementasi Bertahap (supaya tidak big-bang)

| Chunk | Isi | Syarat selesai |
|---|---|---|
| C1 ✅ | `design_tokens.dart` + rewrite `theme.dart` + font terbundel; **tanpa** ubah logika — SELESAI 2026-10-22 | analyze/test tetap hijau; layar lama tampil bagus |
| C2 ✅ | Auth screen baru (§6.2) — SELESAI 2026-10-22 | alur register/login/eror teruji (+2 test baru: toggle password, banner gagal) |
| C3 | Shell dashboard (§6.3) + komponen StatCard/EmptyState dsb | data tiruan via `DevDataSource`, tanpa menyentuh RTDB |
| C4 | Launcher icon, splash native, polish motion | checklist §7 hijau |

Dependency yang dibutuhkan: `fl_chart` (grafik), `shimmer` (skeleton),
font dibundel manual (lebih stabil daripada pengambilan runtime
`google_fonts`). Tambahan ikon: tetap `material_symbols` dulu; ilustrasi
empty state cukup 1–2 SVG sederhana.
