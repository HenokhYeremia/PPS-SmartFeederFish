# RUN-WEB — Jalankan Aplikasi di Chrome/Edge (Web) tanpa Emulator

> Panduan menjalankan **Smart Fish Feeder di browser laptop** — tanpa
> virtual device / AVD Android sama sekali.
>
> Status: **PANDUAN OPERASIONAL** dibuat 2026-10-22. Ditulis dari kondisi
> repo yang **diverifikasi langsung** (lihat §2); langkah di §4–§6 belum
> pernah dieksekusi di repo ini, jadi tandai hasilnya di checklist §8
> setelah dijalankan.

## 1. Tujuan

Jalankan aplikasi feeder yang sama (kode `lib/` yang sama) langsung di
Chrome lokal Anda:

- Tidak perlu AVD/emulator Android, tidak perlu memasang APK.
- Hot reload tetap jalan (`r` / `R`) — cara kerjanya sama persis
  seperti saat berjalan di Android.
- Memakai Firebase live yang sama: **Auth** (register/login) dan
  **RTDB** `fish-feeder-ebd70-default-rtdb` dengan rules ownership yang
  sudah di-deploy & diuji di Step 08B — sehingga `/users/{uid}` aktif
  dengan proteksi yang sama persis seperti di Android.

## 2. Kondisi pre-check (faktual, terverifikasi 2026-10-22)

| Item | Status | Bukti |
|---|---|---|
| Flutter web toolchain | AKTIF (default SDK 3.41.9) | `flutter config` — `--[no-]enable-web (defaults to on)` |
| Chrome di laptop | TERDETEKSI — Chrome 155.0.8059.86 | `flutter devices` → `Chrome (web) • chrome • web-javascript` |
| Edge di laptop | TERDETEKSI — Edge 155.0.4283.62 | `flutter devices` → `Edge (web) • edge` |
| Platform web di project utama | **BELUM ADA** — folder `web/` tidak ada di root | daftar direktori root |
| Blok `web` di `lib/firebase_options.dart` | **BELUM ADA** — `kIsWeb` akan melempar `UnsupportedError` saat boot di web | dibaca langsung (baris 19–24) |
| Firebase Auth + RTDB live | SIAP (`asia-southeast1`, rules ownership locked) | Step 08B, D-2 |
| Folder `chrome/` | **PROJECT FLUTTER TEMPLATE KOSONG** (130 file, default counter, tanpa Firebase) — bukan aplikasi feeder | `chrome/pubspec.yaml` name `chrome`, dibaca langsung |

⚠️ **Penting soal folder `chrome/`:** itu `flutter create` kosong yang
ter-track git dari commit awal. Aplikasi feeder TIDAK ada di sana.
Semua perintah di panduan ini dijalankan dari **root** `D:\PPS APP`,
bukan dari dalam folder `chrome/`. (Keputusan merapikan/menghapus
folder itu terpisah — jangan dilakukan di dalam panduan ini.)

## 3. Prasyarat

1. Terminal di project root:
   ```bat
   cd /d "D:\PPS APP"
   ```
2. Flutter SDK jalan: `flutter doctor` tanpa merah pada `[√] Flutter`.
3. Chrome (sudah ✓ per §2) — atau Edge juga tervalidasi sebagai target.

## 4. Langkah A — tambahkan platform web ke project utama

```bat
flutter config --enable-web
flutter create --platforms web .
```

Apa yang terjadi:

- Baris pertama idempoten (web memang default aktif; hanya pengaman).
- Baris kedua menambah folder `web/` (index.html, manifest,
  bootstrap) **di project utama saja**. `android/`, `lib/`, `test/`,
  pubspec **tidak diubah isinya**. Biasanya `.metadata` ikut berubah
  kecil — normal.
- **Tidak ada dependency baru** → `flutter pub get` tidak wajib,
  tapi menjalankannya sekali tidak merugikan apa pun.

Cek: `dir /b web` memuat `index.html`.

## 5. Langkah B — konfigurasi FlutterFire untuk web

CLI `flutterfire` sudah pernah dipasang (Step 08B, v1.4.1):

```bat
$env:Path += ';C:\Users\Lenovo\AppData\Local\Pub\Cache\bin'
flutterfire configure --project fish-feeder-ebd70 --platforms android,web
```

Catatan penting:

- **Pakai `android,web` (dua-duanya), bukan `web` saja.** Pelajaran
  Step 08B: file `firebase_options.dart` ditulis ulang UTUH per
  regenerate; regenerasi hanya-web berisiko membuang blok android.
- **Efek samping yang diketahui dan ini normal:** perintah ini
  mendaftarkan **satu app web baru** di Firebase project
  (`appId berpola 1:737854019568:web:...`, nama ~nama-project).
  Ini tidak menyentuh Android app yang terdaftar
  (`8a0494d4...`) dan tidak mengubah `applicationId`.
- Bila muncul prompt "firebase_options.dart already exists ... (y/n)"
  → jawab `y` (seperti yang sudah kita alami di Step 08B).

Output yang diharapkan: `Firebase configure done ...`. Blok `android`
di `firebase_options.dart` harus tetap ada setelah regenerate; bila
muncul prompt pemilihan app, pastikan app Android tetap terpilih dan
ikutkan app web yang baru (default bila hanya satu).

## 6. Langkah C — verifikasi sebelum jalan

1. `lib/firebase_options.dart`:
   - Ada `static const FirebaseOptions web = ...`.
   - **Kedua blok** (`android` dan `web`) memuat
     `databaseURL: 'https://fish-feeder-ebd70-default-rtdb.asia-southeast1.firebasedatabase.app'`.
   - Blok `android` masih appId `1:737854019568:android:8a0494d4acdf845879af35`.
2. `git diff` harus membaca kecil: `web/` (baru),
   `firebase_options.dart` (+blok web), `firebase.json` (+appId web di
   konfig dart), dan `.metadata`.
3. **Quality gate — WAJIB sekuensial (pelajaran crash OOM di Step 08C, jangan paralel):**

   ```bat
   flutter analyze
   flutter test
   ```

   Harus: `No issues found!` dan `All tests passed! (+7)`.

## 7. Langkah D — jalankan di Chrome

```bat
flutter run -d chrome
```

- Build pertama membangun web toolchain — **sabar, bisa belasan
  detik–menit pertama kali**; Chrome akan terbuka sendiri karena
  device id `chrome`.
- Hot keys: `r` hot reload, `R` hot restart, `q` quit.
- Pemilihan port (bila konflik):
  ```bat
  flutter run -d chrome --web-port 8080
  ```
- Pakai Edge alih-alih Chrome: `flutter run -d edge`.
- Browser LAIN (Firefox/Brave, dsb.):
  ```bat
  flutter run -d web-server --web-port 8080
  ```
  lalu buka manual http://localhost:8080 di browser kesukaan Anda.

Ekspektasi saat app berjalan:

1. AuthPage "Lagoon" (chunk C2) tampil di browser.
2. Register/login sukses = Firebase Auth live dengan akun RIIL Anda.
3. Pasca-login = FoundationPage menampilkan **uid + email pemilik data
   nyata** — jalur `/users/{uid}` yang dipakai app dilindungi rules
   ownership yang live (Step 08B).

## 8. Checklist hasil eksekusi (isi ketika panduan ini dijalankan)

- [ ] `flutter create --platforms web .` → folder `web/` ada.
- [ ] `flutterfire configure --project fish-feeder-ebd70 --platforms android,web`
      → app web terdaftar, app Android tidak berubah.
- [ ] `firebase_options.dart` punya blok `web` + `databaseURL` keduanya
      (android & web).
- [ ] `flutter analyze` → No issues found!
- [ ] `flutter test` → All tests passed! (+7)
- [ ] `flutter run -d chrome` → app tampil; register/login jalan;
      uid ditampilkan pasca-login.
- [ ] (Opsional dicatat di STATUS.md bila status "web pendukung"
      naik dari blueprint ke verified.)

## 9. Jebakan umum & solusi

| Gejala | Penyebab | Solusi |
|---|---|---|
| "This application is not configured to build on the web" | `web/` hilang di project utama | Ulang Langkah A (`flutter create --platforms web .`) |
| Red-screen `DefaultFirebaseOptions have not been configured for web` | Blok `web` belum ada di `firebase_options.dart` | Ulang Langkah B dengan `--platforms android,web` |
| `databaseURL` hilang di salah satu blok | Regenerasi web-only menulis ulang file utuh | Ulang Langkah B dengan DUA platform, cek §6.1 |
| Auth gagal saat dijalankan dari domain bukan `localhost` | Firebase Auth membatasi authorized domain | localhost sudah otomatis di-authorize; bila pakai IP LAN/`web-server`, daftarkan domain di Console → Authentication → Settings → Authorized domains |
| `flutterfire` tidak dikenal | PATH belum memuat bin pub | `$env:Path += ';C:\Users\Lenovo\AppData\Local\Pub\Cache\bin'` (satu sesi) |
| Crash OOM / `VirtualAlloc failed 1455` saat analyze/test | Tekanan memori/paging file (pernah terjadi di Step 08C) | Jangan paralel flutter command; tutup app berat; ulangi |
| App yang tampil adalah "counter app" default | Anda menjalankan dari dalam folder `chrome/` (template) | `cd` kembali ke root `D:\PPS APP` |
| Warning CRLF saat commit | Git `core.autocrlf` di Windows | Normal, abaikan |

## 10. Yang di luar jangkauan panduan ini

- **Firebase Hosting** (deploy `build/web` ke internet/URL publik):
  jangan di-init sekarang — keputusan milestone terpisah.
- Merapikan/menghapus folder template `chrome/` (130 file ter-track):
  butuh keputusan pemilik proyek — item open, tidak diutak-atik
  di sini.
- Step 09 (skema + converter), chunk C3 (dashboard), BLE, servo —
  semuanya tetap di luar panduan run (roadmap STATUS.md §6).

## 11. Referensi internal

- `START.md` — panduan jalan dari nol (Android & fondasi).
- `STATUS.md` — patokan progres; §1 menyebut "Chrome/web pendukung"
  (harus diganti dari "pendukung" ke "siap dipakai" setelah checklist
  §8 di atas penuh).
- `docs/02-arsitektur.md` §2 — prinsip: UI → service → Firebase SDK.
- `docs/03-skema-data.md` — rules live yang diwarisi app di web.
