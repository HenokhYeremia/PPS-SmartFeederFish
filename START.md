# START — Cara Menjalankan Smart Fish Feeder Sampai Bisa Digunakan

Panduan menjalankan aplikasi Flutter **Smart Fish Feeder** dari nol
sampai benar-benar bisa dipakai (register, login, halaman utama).

> Status aplikasi: fondasi + Firebase Core + Firebase Auth Email/Password
> + fondasi ownership RTDB. BUKAN dashboard final. BELUM ada data sensor,
> jadwal, perintah servo, atau BLE provisioning ESP32.

## 1. Yang Dibutuhkan

Software wajib:

- Flutter SDK 3.41.9 stable, Dart 3.11.5 (terverifikasi di proyek ini).
- Android SDK (API 36 / SDK 36.1.0), Java 17, Git.
- Koneksi internet (wajib untuk login Firebase).

Perangkat (pilih satu):

- HP Android fisik (disarankan) dengan USB debugging aktif.
- Android Emulator via Android Studio (buat AVD lalu jalankan dulu).
- Chrome/Edge hanya untuk cek tampilan (fokus utama tetap Android).

Firebase Console (WAJIB, satu kali saja). Proyek sudah ada:

- Nama: FISH-FEEDER, Project ID: fish-feeder-ebd70.
- Android app: com.example.smart_fish_feeder.

Yang harus dipastikan di Firebase Console:

1. Buka project FISH-FEEDER.
2. Authentication, Sign-in method, Email/Password, Enable, Save.
   Tanpa ini register/login gagal dengan pesan
   "Login email/password belum diaktifkan di Firebase."
3. Realtime Database boleh menyusul (aplikasi belum menulis ke RTDB).

## 2. Persiapan Pertama Kali

Buka terminal di folder proyek:

```bat
cd /d "D:\PPS APP"
```

Cek Flutter:

```bat
flutter --version
flutter doctor
```

Diharapkan: Flutter 3.41.9, Dart 3.11.5, Android toolchain OK,
No issues found.

Ambil dependency:

```bat
flutter pub get
```

Dependency proyek: firebase_core ^4.15.0, firebase_auth ^6.1.0,
firebase_database ^12.1.0 (fondasi ownership saja),
cupertino_icons, flutter_lints.

Validasi (disarankan):

```bat
flutter analyze
flutter test
```

Diharapkan: No issues found, All tests passed (5 test).

## 3. Run di HP Android Fisik (Disarankan)

Siapkan HP: aktifkan Developer options, USB debugging, colok USB,
izinkan debugging di HP, pastikan HP dan laptop online.

Cek HP terdeteksi:

```bat
flutter devices
```

Harus muncul baris HP Android. Kalau tidak muncul: ganti kabel/port USB,
install driver USB HP, atau aktifkan ulang USB debugging.

Jalankan aplikasi:

```bat
cd /d "D:\PPS APP"
flutter run
```

Kalau ada banyak device:

```bat
flutter run -d android
```

Pakai aplikasi sampai bisa digunakan:

1. Register: di halaman Login ketuk "Belum punya akun? Register",
   isi email dan password minimal 6 karakter, ketuk Register.
2. Halaman utama harus tampil: "Application foundation ready",
   "UID pemilik data: ...", dan "Email: ...".
3. Logout: ketuk ikon logout kanan atas AppBar.
4. Login lagi dengan akun yang sama.

Aplikasi bisa digunakan kalau alur
register, halaman utama tampil UID, logout, login kembali
semuanya berhasil tanpa error.

## 4. Run di Android Emulator

1. Android Studio, Device Manager, buat AVD (disarankan Pixel API 34+
   dengan Google APIs), jalankan sampai home screen muncul.
2. Di terminal:

```bat
cd /d "D:\PPS APP"
flutter devices
flutter run
```

3. Lakukan alur yang sama seperti Bagian 3 (register, UID tampil,
   logout, login).

## 5. Build APK Manual

```bat
cd /d "D:\PPS APP"
flutter build apk --debug
```

Hasilnya: build\app\outputs\flutter-apk\app-debug.apk.

Copy APK ke HP, install (izinkan install unknown apps), pastikan HP online,
buka aplikasi, lakukan register dan login seperti Bagian 3.

Catatan: build memakai debug signing bawaan template. Rilis Play Store
perlu signing config sendiri (di luar panduan ini).

## 6. Troubleshooting

- devices tidak ada HP: ganti kabel, install driver, aktifkan ulang
  USB debugging.
- "Login email/password belum diaktifkan": enable provider di Console.
- "Email sudah terdaftar": pilih login, bukan register.
- "Email atau password salah": cek ketikan atau register dulu.
- "Jaringan bermasalah": pastikan HP dan laptop online.
- "Terlalu banyak percobaan": tunggu beberapa menit.
- Gradle macet pertama kali: tunggu 5-15 menit, jangan dibatalkan.
- Kotlin daemon error: jalankan flutter clean, flutter pub get,
  ulangi build atau run.

Perintah bersih-bersih:

```bat
cd /d "D:\PPS APP"
flutter clean
flutter pub get
flutter run
```

## 7. Batasan Saat Ini

- Ini fondasi auth dan ownership, bukan dashboard monitoring final.
- Belum ada turbidity, stok pakan, jadwal, perintah servo,
  BLE provisioning ESP32, dan notifikasi.
- Halaman utama hanya menampilkan UID dan email sebagai bukti login.
- Tidak ada grafik atau sensor karena memang belum diimplementasikan.

## 8. Checklist Bisa Digunakan

- flutter doctor tanpa error.
- Email/Password Auth aktif di Firebase Console.
- flutter pub get, flutter analyze, flutter test lolos.
- HP atau emulator terdeteksi di flutter devices.
- Register akun baru berhasil.
- Halaman utama menampilkan UID dan email.
- Logout kembali ke Login.
- Login kembali berhasil.

Semua centang berarti fondasi ini benar-benar bisa digunakan sebagai
titik awal fitur Smart Fish Feeder berikutnya.

