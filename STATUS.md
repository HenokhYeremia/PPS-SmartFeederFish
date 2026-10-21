# STATUS — Patokan Proyek Smart Fish Feeder

> Dokumen ini adalah **kantor pusat status**: patokan progres, gap, dan
> keputusan proyek. Perbarui setiap kali satu milestone selesai.
>
> Terakhir diverifikasi: **2026-10-22**
> (flutter analyze + flutter test dijalankan ulang pada tanggal ini).

## 1. Identitas & Fingerprint Proyek

| Item | Nilai | Sumber |
|---|---|---|
| Nama proyek | Smart Fish Feeder (`smart_fish_feeder`) | pubspec.yaml |
| Versi | 1.0.0+1 | pubspec.yaml |
| Flutter | 3.41.9 stable / Dart 3.11.5 | START.md |
| Firebase Project | FISH-FEEDER, `fish-feeder-ebd70` | firebase.json |
| Android appId | `com.example.smart_fish_feeder` | google-services.json |
| Platform target | Android (utama), Chrome/web pendukung | android/, chrome/ |
| Kontrol versi | git repo (branch `main`) | `git status` bersih |

## 2. Garis Dasar Kualitas (Patokan Wajib)

Semua perintah berikut harus tetap hijau sebelum dan sesudah setiap
perubahan. Jika satu saja merah, perubahan tidak boleh dianggap selesai.

```bat
cd /d "D:\PPS APP"
flutter pub get
flutter analyze   :: HARUS: No issues found
flutter test      :: HARUS: All tests passed (7 test)
```

Status terverifikasi 2026-10-17:

- [x] `flutter analyze` -> **No issues found!** (14.3 s)
- [x] `flutter test` -> **All tests passed!** (+5 test)
- [x] git repository + commit awal -> SELESAI 2026-10-22 (branch main)

Status terverifikasi 2026-10-22 (setelah chunk C1+C2 design system):

- [x] `flutter analyze` -> **No issues found!**
- [x] `flutter test` -> **All tests passed!** (+7 test)

Status terverifikasi 2026-10-22 (Step 08B — RTDB hidup + rules):

- [x] `flutter analyze` -> **No issues found!**
- [x] `flutter test` -> **All tests passed!** (+7 test)

## 3. Yang Sudah SELESAI (dengan bukti)

Tahap yang dirujuk di komentar kode: Step 02 (lingkungan),
Step 03 (fondasi aplikasi), Step 07 (auth), Step 08 (ownership RTDB).

| Wilayah | Yang ada | File |
|---|---|---|
| Entry point + Firebase Core | `main()` async, init Firebase sebelum runApp | `lib/main.dart` |
| Theme | Material 3, seed teal, light + dark | `lib/app/theme.dart` |
| Root app | MaterialApp, AuthGate sebagai gerbang login | `lib/app/app.dart` |
| Auth abstrak | Kontrak `AuthService` tanpa user hardcoded | `lib/features/auth/auth_service.dart` |
| Auth implementasi | Firebase email/password, register + login + logout | `lib/features/auth/auth_service.dart` |
| Auth UI | Form login/register, validasi wajib isi, status sukses/gagal, busy state, toggle mode | `lib/features/auth/auth_page.dart` |
| Auth gate | StreamBuilder `authStateChanges()`, tanpa state-management package | `lib/features/auth/auth_gate.dart` |
| Pesan error aman | Mapping kode Firebase -> bahasa Indonesia, tanpa token/stack trace | `lib/features/auth/auth_error_messages.dart` |
| Navigasi dasar | Halaman kedua bukti Navigator bawaan | `lib/features/foundation/foundation_page.dart` |
| Design tokens + theme "Lagoon" | Sumber tunggal warna/spacing/radius/motion, theme light & dark didesain ulang, font terbundel (chunk C1) | `lib/app/design_tokens.dart`, `lib/app/theme.dart`, `assets/fonts/` |
| Auth UI premium | Header merek, card form, ikon field, toggle password, banner status, spinner di dalam tombol (chunk C2) | `lib/features/auth/auth_page.dart` |
| Ownership RTDB | `UserDatabase` hanya referensi `/users/{uid}` dan `/users/{uid}/devices/{ref}`; null bila belum login | `lib/data/user_database.dart` |
| RTDB hidup + konfig | Region `asia-southeast1`, locked mode; `databaseURL` merekat setelah `flutterfire configure` | `lib/firebase_options.dart`, `android/app/google-services.json` |
| Security rules RTDB deployed | Ownership `users/{uid}` deploy via CLI (`firebase deploy --only database`, verifikasi "released successfully") + wiring reproducible; diuji dua akun REST (P 200/200; N 401×3; data & akun uji dihapus) | `database.rules.json`, `firebase.json`, `.firebaserc` |
| Catatan security rules | Kandidat rules lama di kode (PROPOSED); rules final kini hidup di `database.rules.json` (deployed) | `lib/data/ownership_rules_note.dart` |
| Model domain (stub) | `Device`, `TurbidityReading`, `FeedStock`, `FeedingSchedule` — sengaja opaque, tanpa asumsi satuan/protokol | `lib/domain/` |
| Pengujian | 7 test: mapping error, render AuthPage, app build dengan auth injeksi, UserDatabase null-ref, scope rules, toggle password, banner gagal submit | `test/widget_test.dart` |
| Dokumentasi cara jalan | START.md lengkap dari nol sampai bisa dipakai | `START.md` |

Definisi selesai yang tercapai untuk fondasi:
register -> halaman utama tampil UID/email -> logout -> login kembali.

## 4. GAP — Yang Belum Ada (per wilayah, prioritas)

### 4.1 Prioritas Tinggi (menghalangi fitur inti)

1. DITUTUP 2026-10-22: **Kontrol versi.** git repo aktif (branch
   `main`, riwayat commit jalan) — bukan lagi non-repo.
2. DITUTUP 2026-10-22: **Realtime Database diprovisikan.**
   Instance `fish-feeder-ebd70-default-rtdb`, region **`asia-southeast1`**
   (Jakarta/`asia-southeast2` tidak tersedia saat provisioning —
   ketetapan user: Singapura dianggap sah), mode **locked** dari awal.
   `databaseURL` kini ada di `firebase_options.dart` dan
   `firebase_url` di `google-services.json` (via `flutterfire
   configure` 1.4.1, appId Android tidak berubah).
3. DITUTUP 2026-10-22: **Security rules deployed + diuji.**
   Rules ownership `users/{uid}` live via
   `firebase deploy --only database` (wiring `database.rules.json` +
   `firebase.json` + `.firebaserc`, reproducible). Uji REST dua akun:
   positif PUT/GET subtree sendiri = 200/200; negatif baca/tulis
   subtree user lain = 401, root tanpa auth = 401; data & akun uji
   dihapus bersih. Bukti: transkrip uji Step 08B, D-2.
4. **Dashboard monitoring 0%.** Halaman utama masih placeholder
   ("Application foundation ready"). Tidak ada: tampilan kekeruhan
   (turbidity) real-time, level stok pakan, tombol feed manual,
   riwayat pemberian pakan.

### 4.2 Prioritas Menengah

5. **Jadwal pakan (CRUD) tidak ada.** Model `FeedingSchedule` stub
   sudah ada, tapi tidak ada UI, tidak ada penyimpanan, tidak ada
   eksekusi di sisi perangkat.
6. **Manajemen perangkat tidak ada.** Tidak ada pairing, daftar
   perangkat, rename, hapus, dan status online/offline. Format device
   ID masih opaque (keputusan terbuka D-1).
7. **BLE provisioning ESP32 tidak ada.** Belum ada UUID/characteristic,
   belum ada alur kirim Wi-Fi SSID/password ke perangkat,
   dependency BLE (`flutter_blue_plus` dsb.) belum ditambahkan.
8. **Notifikasi tidak ada.** Peringatan stok pakan rendah,
   kegagalan feed, dan perubahan status tidak memicu pemberitahuan.

### 4.3 Prioritas Rendah (polish & rilis)

9. **Auth belum lengkap operasional:** tidak ada lupa kata sandi
   (password reset), verifikasi email, penghapusan akun.
10. DITUTUP 2026-10-22: README.md kini menggambarkan proyek dan
    berlink ke `docs/` (PRD rekonstruksi, arsitektur, skema data,
    design system, gap analysis). Dokumen-dokumen itu masih
    DRAFT/PROPOSED/BLUEPRINT dan harus dipelihara per milestone.
11. **Lingkup pengujian tipis:** semua test berbasis auth fondasi;
    belum ada test domain, test alur login sukses (fake service),
    integrasi RTDB (emulator), jadwal.
12. **CI tidak ada** (GitHub Actions: analyze + test per push).
13. **Rilis belum disiapkan:** hanya debug signing; belum ada signing
    config rilis, flavor dev/prod, atau aplikasi iOS (keputusan Android-first).
14. **Keputusan fuzzy logic belum didokumenkan** meski disebut proposal.

## 5. Tabel Status Ringkas

| Fitur | Status |
|---|---|
| Lingkungan Flutter/Android | SELESAI |
| Firebase Core + konfigurasi Android | SELESAI |
| Auth email/password (register, login, logout) | SELESAI |
| Navigasi + theme fondasi | SELESAI |
| Design system C1 (tokens, theme, font terbundel) | SELESAI (2026-10-22) |
| Auth premium C2 | SELESAI (2026-10-22) |
| Referensi RTDB per-user | SELESAI (refs saja) |
| Realtime Database di Console + databaseURL | SELESAI (2026-10-22, `asia-southeast1`, locked) |
| Security rules RTDB | SELESAI — deployed + diuji dua akun (2026-10-22) |
| Dashboard monitoring (turbidity, stok, riwayat) | **MISSING** |
| CRUD jadwal pakan | **MISSING** |
| Manajemen perangkat | **MISSING** |
| BLE provisioning ESP32 | **MISSING** |
| Firmware/kontrak ESP32 (servo, sensor, format data) | **MISSING** |
| Fuzzy logic pakan | **BELUM DIPUTUSKAN/DIDOKUMENKAN** |
| Notifikasi | **MISSING** |
| Auth lanjutan (reset password, verifikasi email) | **MISSING** |
| Git + CI | Git SELESAI (branch main); CI **MISSING** |
| Rilis signing + flavor | **MISSING** |

## 6. Peta Jalan Berikutnya (dengan kriteria selesai)

Dilanjutkan dari penomoran step yang sudah ada di kode.

- **Step 08 (tuntas): RTDB hidup — TUNTAS 2026-10-22.**
  RTDB dibuat (region aktual `asia-southeast1` — Jakarta tidak
  tersedia; mode locked), `flutterfire configure` dijalankan,
  rules ownership `users/{uid}` di-deploy via CLI.
  Kriteria tercapai: nilai test `/users/{uid}/meta/lastWrite`
  dibaca&ditulis oleh pemilik (200/200), ditolak dari user lain
  (401) dan tanpa auth (401), pencatatan di decision log D-2.
- **Step 09: Skema data RTDB final.**
  Kunci struktur: `users/{uid}/devices/{deviceId}/{meta,turbidity,feedStock,schedules,logs}`.
  Selesai jika: skema terdokumen + konverter model <-> map + test.
- **Step 10: Manajemen perangkat.**
  Tambah perangkat (pasangan device ID), daftar, rename, hapus.
  Selesai jika: device tampil di UI, milik UID, terbaca lintas login.
- **Step 11: BLE provisioning + firmware kontrak.**
  Kunci UUID/service, alur kirim kredensial Wi-Fi,
  kontrak perintah servo & format upload sensor.
  Selesai jika: perangkat ESP32 terkirim data turbidity/stok nyata ke RTDB.
- **Step 12: Dashboard monitoring.**
  Kartu turbidity real-time (StreamBuilder), stok pakan + indikator
  rendah, riwayat feed. Selesai jika: data sensor live di UI,
  stream berhenti dengan aman saat logout.
- **Step 13: Jadwal + eksekusi feed.**
  CRUD jadwal, kirim perintah ke ESP32 via RTDB command node,
  feed manual, acknowledgement perangkat. Selesai jika:
  servo bergerak terkonfirmasi + log masuk RTDB.
- **Step 14: Notifikasi.**
  Pemberitahuan stok rendah, gagal feed, status perangkat
  (lokal atau FCM push — menunggu keputusan D-8).
- **Step 15: Rilis.** signing, flavor, versi, polish UI, README final.

Urutan lintas-fungsi (status):
1. **git init + commit** — SELESAI 2026-10-22 (branch `main`).
2. Step 08 — SELESAI 2026-10-22 (lihat checklist §8).

## 7. Keputusan Terbuka (Decision Log)

| ID | Keputusan | Opsi | Dampak bila ditunda |
|---|---|---|---|
| D-1 | Format device ID (MAC ESP32? UUID app-generated? kode QR?) | — | Manajemen perangkat & rules device-level tidak bisa dikunci |
| D-2 | Region & mode RTDB, lalu deploy rules | TUNTAS 2026-10-22: `asia-southeast1` (Singapura; Jakarta tidak tersedia), locked mode, rules ownership deployed + diuji dua akun REST | — |
| D-3 | Skema RTDB final (dibungkus devices atau flat?) | — | Firmware & UI mengikuti skema ini |
| D-4 | Metode provisioning (BLE only? Wi-Fi AP mode? keduanya?) | — | Dependency & UI pasangan |
| D-5 | Fuzzy logic: di ESP32 firmware atau di app? | — | Pola data & pengujian |
| D-6 | Satuan & kalibrasi sensor (turbidity NTU? stok HC-SR04 dalam %/gram?) | — | Model domain masih sengaja opaque |
| D-7 | Android-first tanpa iOS? | — | Folder ios tidak ada sekarang |
| D-8 | Mechanisme notifikasi (local only vs FCM push) | — | Step 14 |

## 8. Checklist Patokan Per Milestone

Fondasi (status saat ini — TERVERIFIKASI 2026-10-17):

- [x] flutter doctor bersih, dependency terpasang.
- [x] Register/login/logout berfungsi dengan Firebase Auth.
- [x] Halaman utama menampilkan UID + email pemilik data.
- [x] analyze + test hijau (5 test).
- [x] START.md sebagai panduan jalan.
- [x] STATUS.md (dokumen ini) sebagai patokan progres.
- [x] git commit pertama (2026-10-22, branch main).
- [x] Design system chunk C1 + C2 terverifikasi 2026-10-22
      (analyze 0 issue, 7 test; lihat docs/04-design-system.md §8).

Step 08 tuntas (TERVERIFIKASI 2026-10-22):

- [x] RTDB dibuat + databaseURL terkonfigurasi di `firebase_options.dart`.
- [x] Rules ownership `users/{uid}` di-deploy & diuji dua akun.
      Bukti: deploy "released successfully" + uji REST dua akun
      (P 200/200; N 401×3); data & akun uji dihapus bersih.

(Sisanya mengikuti peta jalan Bagian 6.)
