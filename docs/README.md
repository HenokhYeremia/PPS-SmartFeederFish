# 📚 Dokumentasi — Smart Fish Feeder

Folder ini adalah **pusat dokumentasi proyek** (produk + teknis).
Dokumen operasional tetap di root:

| Root | Peran |
|---|---|
| `../README.md` | Ringkasan proyek + patokan kualitas |
| `../START.md` | Panduan menjalankan dari nol |
| `../STATUS.md` | Status progres, roadmap, decision log |

## Daftar isi `docs/`

| File | Isi | Status |
|---|---|---|
| [01-prd.md](01-prd.md) | PRD: masalah, pengguna, fitur inti, user story, NFR | DRAFT — rekonstruksi, menunggu konfirmasi |
| [02-arsitektur.md](02-arsitektur.md) | Arsitektur saat ini + target, aturan layer, alur data | VALID untuk state kode sekarang |
| [03-skema-data.md](03-skema-data.md) | Referensi RTDB, skema usulan, security rules | PROPOSED — belum di-deploy |
| [04-design-system.md](04-design-system.md) | Audit UI saat ini + design system & blueprint layar premium | BLUEPRINT — belum diimplementasi |
| [05-gap-analysis.md](05-gap-analysis.md) | Semua yang kurang: fitur, UI, proses, test, rilis | AKTIF — perbarui tiap milestone |

## Mengapa folder ini dibuat (2026-10-22)

Sebelum tanggal ini proyek hanya punya README, START.md, dan STATUS.md.
Tidak ada PRD, tidak ada dokumentasi arsitektur, tidak ada spesifikasi
UI — semuanya hanya tersirat di komentar kode. Folder ini menutup celah
itu dengan dokumen yang dipisah per topik supaya tiap dokumen bisa
dipelihara tanpa menabrak dokumen lain.

## Konvensi

- Bahasa Indonesia; istilah teknis tetap Inggris bila baku.
- Setiap dokumen mencantumkan **status** di header. Jangan mengubah
  status tanpa bukti (hasil `flutter analyze` / `flutter test` /
  deploy / screenshot).
- Keputusan arsitektural dicatat di `../STATUS.md §7` (decision log,
  ID D-1 .. D-8) — dokumen di sini **merujuk**, tidak menduplikasi.
- Katup keamanan: dokumen dengan status DRAFT/PROPOSED/BLUEPRINT
  **tidak boleh** dijadikan alasan deploy atau rewrite tanpa verifikasi.
