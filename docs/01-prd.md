# 01 — Product Requirements Document (PRD)

> Status: **DRAFT** — direkonstruksi 2026-10-22 dari isi kode, START.md,
> dan STATUS.md, karena dokumen PRD asli tidak pernah dibuat.
> Semua bagian berlabel **ASUMSI** wajib dikonfirmasi pemilik proyek
> sebelum dipakai sebagai patokan pengembangan.

## 1. Ringkasan Produk

**Smart Fish Feeder** adalah aplikasi pendamping perangkat pakan ikan
otomatis berbasis ESP32. Aplikasi mengelola:

1. **Monitoring kekeruhan air** (turbidity) secara real-time.
2. **Monitoring stok pakan** (sensor level, HC-SR04 disebut di STATUS.md).
3. **Jadwal pemberian pakan** dengan porsi, plus **feed manual**.
4. **Notifikasi** kondisi kritis (stok rendah, gagal feed, perangkat
   offline).
5. **Manajemen + provisioning perangkat** (BLE kirim kredensial Wi-Fi).

Nilai inti: pemilik kolam tidak perlu ingat jadwal, tidak overfeed,
dan tahu kualitas air & stok tanpa mendekati kolam.

## 2. Masalah yang Diselesaikan

| Masalah | Dampak | Solusi di produk |
|---|---|---|
| Pakan manual rawan lupa / tidak konsisten | Ikan kurang/kelebihan makan | Jadwal + eksekusi servo di ESP32 + ack |
| Overfeed karena serba manual | Kualitas air turun, pemborosan | Porsi per jadwal + log riwayat |
| Stok pakan habis tanpa tanda | Kolam sempat tidak diberi makan | Indikator stok + notifikasi ambang rendah |
| Kekerusahan air tidak terpantau | Penyakit ikan terlambat terdeteksi | Grafik turbidity real-time + ambang |

## 3. Pengguna (Persona)

- **Pemilik kolam rumah** (utama): 1 akun, 1–3 perangkat per kolam;
  pakai ponsel Android; membuka aplikasi sesaat beberapa kali sehari.
- **ASUMSI — Perawat/anggota keluarga**: pembaca saja, belum ada
  sharing akun di v1 (lihat Out of Scope).

## 4. Fitur Inti dan Traceability

| ID | Fitur | Sign-off di Step (STATUS.md §6) | State kode hari ini |
|---|---|---|---|
| F1 | Autentikasi & kepemilikan data per UID | Step 07–08 | ✅ fondasi selesai (`lib/features/auth/`, `lib/data/user_database.dart`) |
| F2 | Manajemen perangkat (pairing, rename, hapus, status) | Step 10 | ❌ hanya model stub `Device` |
| F3 | Monitoring turbidity + stok (real-time) | Step 12 | ❌ model stub `TurbidityReading`, `FeedStock` |
| F4 | Jadwal CRUD + feed manual + eksekusi ESP32/servo + ack | Step 13 | ❌ model stub `FeedingSchedule` |
| F5 | Notifikasi stok rendah / gagal feed / offline | Step 14 | ❌ |
| F6 | Provisioning BLE (kirim SSID/password ke ESP32) | Step 11 | ❌ |

## 5. User Story (dengan kriteria terima)

**US-1 — Daftar & masuk (F1)**
Saya bisa register/login dengan email-password, dan data saya terisolasi
per UID.
- Given akun belum ada → register berhasil → saya diarahkan ke dashboard.
- Given login sukses → data RTDB yang terlihat hanya milik UID saya.

**US-2 — Tambah perangkat (F2, F6)**
Saya menambahkan feeder baru lewat alur pairing; perangkat muncul di
daftar dengan status online/offline.
- Selesai hanya jika device identity diputuskan (D-1) dan metode
  provisioning diputuskan (D-4).

**US-3 — Pantau kolam (F3)**
Saya melihat kartu kekeruhan dan stok sekarang + perkiraan stok menipis.
- Data tampil < 2 detik setelah app terbuka saat online.
- Ketika stream tertutup (logout), tidak ada listener memori bocor.

**US-4 — Jadwal & feed manual (F4)**
Saya membuat/mengubah/menghapus jadwal waktunya, dan menekan
"Feed sekarang" untuk porsi manual.
- Selesai jika servo bergerak terkonfirmasi ack perangkat + masuk log.

**US-5 — Diberi tahu (F5)**
Saya menerima peringatan stok rendah dan kegagalan feed.
- Mekanisme lokal vs FCM harus diputuskan (D-8).

## 6. Persyaratan Non-Fungsional

| Area | Persyaratan |
|---|---|
| Keamanan | Ownership strict per UID; rules RTDB tidak mengizinkan lintas user; pesan error tanpa token/stack (sudah berlaku di auth) |
| Reliabilitas | Device harus bisa beroperasi offline sesuai jadwal tersimpan; app tampil data terakhir + waktu |
| Real-time | Update monitoring tanpa polling manual (RTDB stream) |
| Bahasa | UI bahasa Indonesia |
| Aksesibilitas | Kontras AA, target sentuh ≥ 44 px, label tooltip ikon |
| Lisensi | Font/ikon yang dipakai bebas distribusi |

## 7. Metrik Sukses (ASUMSI — disederhanakan v1)

- Alur F1 bebas error pada perangkat Android fisik + emulator Chrome.
- Jadwal terjadwal dieksekusi ≥ 95% dalam uji 1 minggu dengan perangkat.
- Tidak ada kejadian "stok habis tanpa peringatan" selama uji.

## 8. Out of Scope (v1)

- iOS (D-7; Android-first — folder `ios/` tidak ada).
- Sharing kolam ke multi-user, role, undangan.
- Kamera/video kolam, computer vision, integrasi marketplace pakan.
- Penjadwalan non-harian (mingguan) — bisa menyusul setelah Step 13.

## 9. Asumsi Terbuka (wajib dikonfirmasi)

1. Device identity (D-1), region & mode RTDB (D-2), skema final (D-3),
   metode provisioning (D-4), lokasi fuzzy logic (D-5), satuan & kalibrasi
   sensor (D-6), Android-only (D-7), mekanisme notifikasi (D-8) —
   lihat STATUS.md §7.
2. Satu kolam per perangkat; satu perangkat milik tepat satu UID.
3. Tulis riwayat dibatasi (retensi) — belum diputuskan.
