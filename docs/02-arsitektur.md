# 02 — Arsitektur Aplikasi

> Status: **VALID** untuk state kode 2026-10-22 (fondasi Step 03/07/08).
> Diverifikasi dari pembacaan seluruh file `lib/` dan `test/`.

## 1. Peta Folder Saat Ini

```
lib/
  main.dart                     entry: init Firebase → runApp
  firebase_options.dart         config FlutterFire (databaseURL asia-southeast1 — Step 08B)
  app/
    app.dart                    MaterialApp + theme + AuthGate
    theme.dart                  Material 3, seed teal, light/dark  (minimal — lihat docs/04)
  features/
    auth/
      auth_user.dart            model user app-layer (uid, email)
      auth_result.dart          Result pattern: success/failure + pesan aman
      auth_error_messages.dart  mapping kode Firebase → pesan Indonesia
      auth_service.dart         abstract AuthService + FirebaseAuthService
      auth_page.dart            UI login/register (validasi wajib-isi, busy state)
      auth_gate.dart            StreamBuilder authStateChanges → page switch
    foundation/
      foundation_page.dart      placeholder pasca-login (BUKAN dashboard) + halaman kedua uji Navigator
  data/
    user_database.dart          refs /users/{uid} + /devices (opaque ref)
    ownership_rules_note.dart   catatan kandidat rules; final → database.rules.json (deployed)
  domain/
    device.dart                 Device {id, name} — stub
    turbidity.dart              TurbidityReading {value, recordedAt} — stub
    feed_stock.dart             FeedStock {amount, updatedAt} — stub
    feeding_schedule.dart       FeedingSchedule {id, timeOfDay, isEnabled} — stub
```

## 2. Layering dan Aturan Dependen

```
UI (features/*)          → hanya lewat service/repo; TIDAK menyentuh SDK Firebase langsung
Service/Data (features, data/) → satu-satunya yang menyentuh Firebase SDK
Domain (domain/)         → murni; TIDAK boleh butuh Firebase/backends
App (app/, main.dart)    → komposisi root + theme
```

| Aturan | Status hari ini |
|---|---|
| UI tidak memanggil Firebase langsung | ✅ terpenuhi (via `AuthService`) |
| Domain bebas backend | ✅ (semua stub murni) — **kecuali** `feeding_schedule.dart` mengimpor `flutter/material.dart` untuk `TimeOfDay` (lihat Utang A-2) |
| Error ditampilkan tanpa stack/secret | ✅ `AuthResult` + `friendlyAuthMessage` (punya test) |
| Tidak ada kredensial/UID hardcoded | ✅ |

## 3. Alur Utama Sekarang (Auth)

```
main.dart
  └─ Firebase.initializeApp(DefaultFirebaseOptions.currentPlatform)
      └─ SmartFishFeederApp (MaterialApp, theme light/dark system)
          └─ AuthGate (StreamBuilder authStateChanges)
              ├─ waiting     → CircularProgressIndicator
              ├─ hasData     → FoundationPage (uid/email + logout)
              └─ null        → AuthPage (login ↔ register toggle)
```

## 4. Pattern yang Dipakai (diikuti fitur berikutnya)

1. **Dependency injection lewat konstruktor opsional.**
   `Widget({super.key, AuthService? authService})` — default ke
   implementasi Firebase, test menyuntik palu. Dipakai `AuthPage`,
   `AuthGate`, `UserDatabase`. ✔ Pertahankan.
   ⚠️ Catatan: `AuthGate.build` memanggil `FirebaseAuthService()`
   di setiap rebuild — tidak mahal, tapi sebaiknya
   `late final` di State atau dibuat sekali di `app.dart`.

2. **Result object, bukan throw ke UI.** `AuthResult.success/failure`.
   Replikasi pola ini untuk repositori data (Step 09+),
   mis. `RepoResult<T>` — jangan biarkan UI menangkap exception Firebase.

3. **Tanpa package state-management.** `setState` + `StreamBuilder`
   Utang yang harus dipecahkan ketika dashboard punya BANYAK stream
   (Step 12): minimal konsolidasi satu keluarga stream per Repository,
   diputuskan di decision log (usul: decision D-9 baru).

4. **Refs, bukan CRUD, di data layer** (`UserDatabase`) — bagus;
   CRUD + converter masuk Step 09.

## 5. Arsitektur Target (Step 09–13)

```
features/dashboard|device|schedule|monitoring
     │ (UI)
     ▼
Repository per aggregate  (DEVICE, MONITORING, SCHEDULE)
     │ data/…
     ▼
UserDatabase (refs) → FirebaseDatabase → RTDB
                    ▲
ESP32  ◄── commands/feed  ·  ▲ turbidity/feedStock streams (device→RTDB)
```

- `DeviceRepository`: list/add/rename/remove device + stream meta.
- `MonitoringRepository`: `Stream<TurbidityReading/FeedStock>` per device;
  WAJIB cancel saat logout (uji smoke: logout → tidak ada error stream).
- `ScheduleRepository`: CRUD + command node `devices/{id}/commands/feed`
  (`status: idle|pending|done|error`, `issuedAt/ackAt`) — kontrak ack di Step 13.
- Router: cukup `Navigator.push` berkali-kali sekarang; jika provisioning
  BLE punya alur multi-layar + result, pertimbangkan named routes.

## 6. Utang Teknis Terdokumentasi

| ID | Isi | Kapan dibereskan |
|---|---|---|
| A-1 | `FoundationPage` placeholder nanti jadi dashboard → pindah ke `features/dashboard/` saat Step 12 | Step 12 |
| A-2 | `domain/feeding_schedule.dart` mengimpor Flutter (`TimeOfDay`) → ganti ke tipe jam netral (mis. `int minutesOfDay`) + konversi di UI | Step 09 |
| A-3 (DITUTUP 2026-10-22) | `databaseURL` kini terpasang (`asia-southeast1`) — RTDB nyata dan `firebase_options.dart` merekat | ✓ Step 08B |
| A-4 (DITUTUP 2026-10-22) | git repo aktif (branch `main`) — rollback/riwayat tersedia | ✓ |
| A-5 | Tanpa caching/offline: RTDB persistence belum disetel (menunggu D-2/D-3) | Step 12 |
