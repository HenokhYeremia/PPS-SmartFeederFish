# 03 — Skema Data RTDB & Security Rules

> Status: **AKTIF (Step 08B tuntas 2026-10-22).**
> RTDB `fish-feeder-ebd70-default-rtdb` hidup, region **`asia-southeast1`**
> (Singapura — `asia-southeast2`/Jakarta tidak tersedia saat provisioning),
> mode **locked** sejak awal. Rules §3.1 di-deploy via CLI (`firebase deploy
> --only database`) dan **diuji dua akun REST**: positif PUT/GET subtree
> sendiri 200/200; negatif lintas-user 401, tanpa auth 401; data uji +
> akun uji dihapus bersih. Rules tingkat perangkat ($deviceId) masih
> menunggu D-1 — tidak termasuk rules yang live.
> URL: https://fish-feeder-ebd70-default-rtdb.asia-southeast1.firebasedatabase.app

## 1. Yang Sudah Ada di Kode (faktual)

- `lib/data/user_database.dart` menyediakan refs:
  `/users/{uid}`, `/users/{uid}/devices`, `/users/{uid}/devices/{ref}`
  — semuanya **hanya referensi**, tidak ada read/write.
- `ref` perangkat diperlakukan opaque (menunggu keputusan D-1).
- Kandidat rules ada komentar di `lib/data/ownership_rules_note.dart`
  (status PROPOSED).

## 2. Skema Usulan (kunci Step 09, mengikuti roadmap STATUS.md)

```json
{
  "users": {
    "$uid": {
      "meta":     { "createdAt": 0, "lastWrite": 0 },
      "devices": {
        "$deviceId": {
          "meta":      { "name": "", "createdAt": 0, "online": false, "lastSeen": 0 },
          "turbidity": { "latest": { "value": 0.0, "recordedAt": 0 },
                         "historyLimit": 20 },
          "feedStock": { "percent": 0, "grams": 0, "updatedAt": 0,
                         "lowThresholdPercent": 20 },
          "schedules": {
            "$scheduleId": { "hour": 7, "minute": 0, "enabled": true,
                             "portion": 0 }
          },
          "commands": {
            "feed": { "status": "idle|pending|done|error",
                      "issuedAt": 0, "ackAt": 0, "error": "" }
          },
          "logs": {
            "$logId": { "type": "manual|scheduled|alert", "at": 0,
                        "result": "success|error", "detail": "" }
          }
        }
      }
    }
  }
}
```

Catatan desain:

- Timestamp dalam **epoch millis** (konvensi bersama; ESP32 dapat
  memakai NTP atau server timestamp RTDB).
- `commands` disimpan sebagai node terpisah supaya firmware
  subscription sederhana dan ack-nya auditable.
- `historyLimit` membatasi entri history; firmware yang memangkas.
  App membaca `latest` + jendela history sesuai kebutuhan UI.
- Satuan (ntu/persen/gram) TIDAK diikat di skema sampai D-6 dijawab.
- `deviceId`: bila D-1 memilih UUID app-generated → device didaftarkan
  saat pairing dan rules device-level membatasi akses milik user;
  bila MAC → risiko daftar MAC terekspos di node users (tolak);
  revisi ke skema `devices/{deviceId}` top-level + mapping tiap UID.

## 3. Security Rules (kandidat)

### 3.1 Tahap fondasi (terselaras komentar kode, scope per-uid saja)

```json
{
  "rules": {
    "users": {
      "$uid": {
        ".read":  "auth != null && auth.uid == $uid",
        ".write": "auth != null && auth.uid == $uid"
      }
    }
  }
}
```

Status: **DEPLOYED & DIUJI (2026-10-22)** — file `database.rules.json`,
deploy via `firebase deploy --only database` (wiring `firebase.json`
+ `.firebaserc`; reproduceable). Hasil uji REST dua akun: P1/P2
positif 200/200, N1/N2/N3 negatif 401, cleanup bersih.

### 3.2 Tahap device-level (menunggu D-1/D-3 — belum dirancang)

Butuh: verifikasi bahwa `users/$uid/devices/$deviceId` hanya bisa
ditulis oleh pemilik, dan firmware/device mampu menulis ke subnode
sensor. Kandidat: custom claim / token device. Tidak diimplementasi
pada tahap ini.

## 4. Conversi Model ↔ Map (yang harus dibuat di Step 09)

| Model | Kode state sekarang | Perlu dibuat |
|---|---|---|
| `Device` | stub tanpa map | `toMap/fromMap` + `createdAt/online/lastSeen` |
| `TurbidityReading` | `double value` tanpa satuan (D-6) | converter + `latest/history` plumbing |
| `FeedStock` | `double amount` generik | converter + ambang rendah |
| `FeedingSchedule` | `TimeOfDay` (dari Flutter) | ganti tipe (A-2) + converter `hour/minute/enabled/portion` |

Wajib: test round-trip untuk KEEMPAT converter (sekarang: 0 test).

## 5. Kriteria Selesai Step 08 (dari STATUS.md §6) — TUNTAS 2026-10-22

1. [x] RTDB dibuat di Console + `databaseURL` muncul di
       `firebase_options.dart` (region `asia-southeast1`, locked).
2. [x] Rules §3.1 di-deploy + dua akun dipakai uji: user A bisa
       write/read `/users/A/meta/lastWrite` (200/200); user B ditolak
       (401); unauth ditolak (401).
3. [x] Dicatat di decision log (D-2) dengan tanggal & hasil.
