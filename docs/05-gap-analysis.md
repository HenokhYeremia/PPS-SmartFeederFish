# 05 — Gap Analysis (Apa yang Kurang)

> Status: **AKTIF** — dibuat 2026-10-22. Perbarui tiap kali item ditutup
> (dengan bukti: test/log/screenshot), dan sinkronkan dengan STATUS.md.

## 1. Ringkasan

Proyek ini punya **fondasi yang benar tapi sempit**: auth + ownership
RTDB lolos analyze/test, namun menurut prinsip "dapat dipakai":
- Belum ada fitur pengguna nyata (dashboard/jadwal/perangkat 0%).
- UI belum punya identitas (theme default — lihat docs/04).
- Infrastruktur pengembangan (git/CI) nihil.
- RTDB hidup belum ada — menghalangi semua fitur berbasis data.

## 2. Matriks Gap (prioritas, dengan dampak)

| # | Gap | Prioritas | Dampak bila ditunda | Titik mulai |
|---|---|---|---|---|
| 1 | Bukan git repo (tidak ada riwayat/rollback) | 🔴 Tinggi — LAKUKAN SEKARANG | risiko kehilangan kode; docs baru taruh baik | `git init` + commit |
| 2 | RTDB belum diprovisikan (tidak ada `databaseURL`) | 🔴 Tinggi (D-2) | semua langkah data stream tersendat | Console → flutterfire configure |
| 3 | Rules RTDB PROPOSED belum di-deploy | 🔴 Tinggi | data tak terlindungi/terkunci | STATUS §6 Step 08 |
| 4 | Dashboard 0% & UI default → terasa jelek | 🟠 Tinggi (produk) | nilai produk belum terasa | docs/04 chunk C1–C3 |
| 5 | Dokumen "single source" belum ada untuk PRD/arsitektur/skema/UI | ✅ BAGIAN DITUTUP hari ini oleh `docs/` | inilah yang dianalisis | review docs |
| 6 | Skema RTDB & converter model belum ada | 🟠 Menengah (Step 09) | UI & firmware tidak bisa diseragimkan | docs/03 → kontrak |
| 7 | Manajemen perangkat 0% (D-1 menunggu) | 🟠 Menengah | pairing & layout rules macet | putuskan D-1 dulu |
| 8 | BLE provisioning 0% (D-4) + kontrak firmware ESP32 | 🟠 Menengah | fitur core IoT tidak jalan | Step 11 |
| 9 | Fuzzy logic tidak terdokumen (D-5) | 🟡 | pola data feed tidak bisa ditetapkan | dokumentasi keputusan |
| 10 | Notifikasi 0% (D-8) | 🟡 | pengalaman pasif | Step 14 |
| 11 | Test hanya 5 (auth). Domain/converter/repo 0 test | 🟡 Menengah | regresi tersembunyi | tambah per chunk |
| 12 | Auth lanjutan: lupa sandi, verifikasi email, hapus akun | 🟡 | ada juga user real akan kesulitan | setelah Step 12 |
| 13 | Rilis: signing debug saja, flavor dev/prod, app icon, splash | 🟡 | tidak bisa disebarkan serius | sebelum publik |
| 14 | CI (analyze+test per push) tidak ada | 🟢 | kualitas dijaga manual | setelah git |
| 15 | CHANGELOG/version policy tidak ada | 🟢 | rilis sulit ditrace | docs + tag |
| 16 | Konvensi commit/branching belum ditetapkan | 🟢 | kolaborasi jadi rancu | docs + alur git sederhana |

## 3. Gap Dokumentasi — Apa yang Ditutup Hari Ini

| Isu lama | Sekarang |
|---|---|
| Tidak ada PRD asli (STATUS §4.3 menyinggung "proposal" tetapi file absen) | ✅ docs/01-prd.md (DRAFT rekonstruksi) |
| Arsitektur hanya tersirat di komentar kode | ✅ docs/02-arsitektur.md (utang A-1..A-5) |
| Rules RTDB cuma komentar di satu file | ✅ docs/03-skema-data.md (PROPOSED, dijelaskan jalan uji) |
| Tentang UI "premium" tidak pernah ada spesifikasi | ✅ docs/04-design-system.md (token + blueprint + checklist) |
| Gap tersebar di STATUS §4 tanpa tabel padat | ✅ dokumen ini (§2) |
| README tak berlink docs | diubah bersamaan pembuatan folder |

Yang masih kurang setelah hari ini:
- [ ] Keputusan D-1..D-8 belum dijawab (docs/01 §9 & docs/03 §2 terblock).
- [ ] Dokumentasi firmware/kontrak ESP32 (command node, format upload) — dibutuhkan untuk Step 11.
- [ ] Deklarasi satuan sensor (D-6) → akan mengubah model & skema map.
- [ ] Screenshot/mock desain untuk blueprint docs/04 — dokumen saat ini masih teks; gambar menyusul.
- [ ] CHANGELOG.md + tag versi.

## 4. Gap UI Ringkas (detail di docs/04)

1. Theme default (tanpa token/type/motion) — terasa template.
2. Semua layar punya teks placeholder ("Application foundation ready").
3. Tidak ada state desain (loading/empty/error) & skeleton.
4. Tidak ada identitas: logo, launcher icon, splash, aset nol.
5. Tidak ada grafik kartu untuk fitur monitoring (fitur inti belum terlihat).

## 5. Gap Pengujian (target saat roadmap lanjut)

| Area | Sekarang | Target minimal |
|---|---|---|
| Auth message mapping | 1 test | kokoh (sudah) |
| AuthPage render | 1 test | tambah alur toggle/validasi fail |
| App boot dengan fake auth | 1 test | tetap |
| UserDatabase null-refs | 1 test | + test "uid ada → ref benar" (butuh fake db) |
| Rules RTDB | 0 | uji manual 2 akun saat Step 08 + catat di D-2 |
| Converter model↔map | 0 | wajib 4 model saat Step 09 |
| Repository stream cancel-on-logout | 0 | smoke test Step 12 |

## 6. Langkah Berikutnya (Urutan Kerja)

Sesuai roadmap STATUS.md: RTDB dulu (tanpa data, dashboard hanya mock).
Rekomendasi urutan kerja minggu depan:
1. `git init` + commit (hari ini).
2. Deploy RTDB + rules (Step 08 tuntas) → catat D-2.
3. docs/04 chunk C1 (tokens+font) — aman tanpa backend.
4. Putuskan D-1 (device id) → buka jalan Step 09/10.
5. Baru dashboard nyata (Step 12) memakai stream.

## 7. Definisi "Selesai" untuk Perbaikan Dok Ini

Inilah kontrol terhadap kebiasaan "perbaiki UI terus tanpa arah":
- Setiap chunk docs/04 menutup checklist analyze/test hijau.
- Tiap milestone menutup minimal 1 ID gap di §2 dengan bukti.
- STATUS.md selalu jadi sumber progres; dokumen ini jadi sumber "apa yang belum".
