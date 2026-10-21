# Smart Fish Feeder (smart_fish_feeder)

Aplikasi Flutter untuk pakan ikan pintar: monitoring kekeruhan air
(turbidity), stok pakan, jadwal pemberian pakan, dan perintah perangkat
ESP32 — dibangun bertahap dengan Firebase (Core, Auth, Realtime Database).

## Status saat ini

Fondasi saja: environment terverifikasi, Firebase Core, Auth
email/password (register/login/logout), dan referensi RTDB per-user.
Step 08B (2026-10-22): RTDB `asia-southeast1` hidup (locked), rules
ownership deployed via CLI dan diuji dua akun.
BELUM ada dashboard, data sensor, jadwal, servo, BLE, atau notifikasi.

Detail lengkap, gap, roadmap, dan keputusan terbuka:
**[STATUS.md](STATUS.md) — patokan progres proyek.**

## Cara menjalankan

Dari nol sampai aplikasi bisa dipakai: **[START.md](START.md)**.
Tanpa emulator — langsung di Chrome/Edge laptop: **[RUN-WEB.md](RUN-WEB.md)**.

## Dokumentasi formal

Folder `docs/` (dibuat 2026-10-22) menyimpan dokumentasi proyek:

- [PRD](docs/01-prd.md) — kebutuhan produk (DRAFT rekonstruksi).
- [Arsitektur](docs/02-arsitektur.md) — layering, alur auth, utang teknis.
- [Skema data RTDB](docs/03-skema-data.md) — skema usulan + security rules (PROPOSED).
- [Design system](docs/04-design-system.md) — audit UI + blueprint UI premium (BLUEPRINT).
- [Gap analysis](docs/05-gap-analysis.md) — semua yang kurang, berprioritas.

## Patokan kualitas (wajib hijau)

```bat
flutter pub get
flutter analyze   # No issues found
flutter test      # All tests passed (7 test)
```

## Struktur

```
lib/
  main.dart                  entry point + Firebase init
  app/                       root app + design tokens + theme "Lagoon"
  features/auth/             AuthService (Firebase) + UI login/register
  features/foundation/       halaman placeholder pasca-login
  data/                      UserDatabase (refs /users/{uid}) + catatan rules
  domain/                    model stub: Device, Turbidity, FeedStock, Schedule
docs/                       PRD, arsitektur, skema data, design system, gap analysis
```
