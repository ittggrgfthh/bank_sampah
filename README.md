# Bank Sampah

Bank Sampah adalah aplikasi mobile flutter sederhana yang digunakan untuk store sampah organik dan organik untuk mendapatkan sejumlah saldo yang dapat ditukar dengan uang.

## Usecase

- [x] Admin - Melihat laporan bulanan
- [x] Admin - Mengubah harga limbah organik dan anorganik per kg.
- [x] Admin - Mendaftarkan pengguna baru
- [x] Admin - Melihat daftar pengguna semua role "warga, staff, dan admin"
- [x] Admin - Mengubah pengguna lama
- [x] Staff - Menarik saldo “warga”
- [x] Staff - Melihat daftar pengguna yang rolenya hanya “warga”
- [x] Staff - Memasukan transaksi jumlah limbah organik dan anorganik dari warga
- [x] Warga - Melihat jumlah saldo-nya dan limbah organik dan an-organik yang sudah disimpan.
- [x] Warga - Melihat riwayat transaksinya.
- [ ] Semua - Melihat defail profil-nya
- [ ] Semua - Mengubah profil-nya.
  - [ ] Mengubah photo profile
  - [ ] Mengubah password
  - [ ] Mengubah nomor telepon
- [ ] Semua - Melihat notifikasi

---

## Users

- /users

```json
{
  "id": "user_randoms-string", // uuid v1 - time series
  "phone_number": "822-1234-1234",
  "password": "hashing...", // SALT ada di ENV
  "role": "warga || staff || admin",
  "full_name": "Kaesa Lyrih",
  "photo_url": "www.banksampah.com/photo-profile/user_random-string.jpg", // url lengkap
  "created_at": 1932913919231, // milisecondSinceEpoch
  "udpdated_at": 1932913919231, // milisecondSinceEpoch
  "last_transaction_epoch": 1932913919231,
  "point_balance": {
    "current_balance": 0, // saldo user sekarang
    "user_id": "user_randoms-string",
    "waste": {
      "inorganic": 0, // total sampah an-organik yang sudah terkumpul
      "organic": 0 // total sampah oganik yang sudah terkumpul
    }
  },
  "rt": "001",
  "rw": "009",
  "village": "Wirogomo"
}
```

## Point Balance

- /point-balances

```json
{
  "user_id": "user_randoms-string",
  "current_balance": 0,
  "waste": {
    "organic": 0,
    "inorganic": 0
  }
}
```

## Transaction

- /transactions

```json
{
  "id": "transaction_randoms-string",
  "create_at": 12131923192312931,
  "update_at": 12312312313213123,
  "user": {
    "id": "user_randoms-string-warga",
    "name": "Kaesa Lyrih",
    "photo_url": "www.banksampah.com/photo-profile/user_randoms-string-warga.jpg"
  },
  "staff": {
    "id": "user_randoms-string-staff",
    "name": "Farhan Taqi",
    "photo_url": "www.banksampah.com/photo-profile/user_randoms-string-staff.jpg"
  },
  // withdrawn_balance bisa null
  "withdrawn_balance": null,
  // store_waste bisa null
  "store_waste": {
    "earned_balance": 90000, // Rp
    "waste": {
      "organic": 40, // kg
      "inorganic": 10 // kg
    },
    "waste_price": {
      "admin": {
        "id": "user_randoms-string-warga",
        "name": "Kaesa Lyrih",
        "photo_url": "www.banksampah.com/photo-profile/user_randoms-string-warga.jpg"
      },
      "created_at": 912931923913,
      "id": "waste_price_id",
      "organic": 1000, // Rp
      "inorganic": 2000 // Rp
    },
    "waste_balance": {
      "organic": 80000, // kg
      "inorganic": 10000 // kg
    },
    "updated_at": 120310310231
  },
  // Object store_waste
  "history_update": []
}
```

- transactions/balance

```json
{
  "id": "transaction_randoms-string",
  "create_at": 12131923192312931,
  "update_at": 12312312313213123,
  "user": {
    "id": "user_randoms-string-warga",
    "name": "Kaesa Lyrih",
    "photo_url": "www.banksampah.com/photo-profile/user_randoms-string-warga.jpg"
  },
  "staff": {
    "id": "user_randoms-string-staff",
    "name": "Farhan Taqi",
    "photo_url": "www.banksampah.com/photo-profile/user_randoms-string-staff.jpg"
  },
  // withdrawn_balance bisa null
  "withdrawn_balance": {
    "balance": 6000,
    "current_balance": 2000,
    "withdrawn": 40000
  },
  // store_waste bisa null
  "store_waste": null,
  // Object store_waste
  "history_update": []
}
```

## Current Waste Price

- /waste-prices?current=true

```json
{
  "organic": 1000,
  "inorganic": 2000,
  "update_at": 1938192831939831,
  "admin": {
    "id": "user_randoms-string-admin",
    "name": "Suastino Budi",
    "photo_url": "www.banksampah.com/photo-profile/user_randoms-string-admin.jpg"
  }
}
```

## History Waste Price

- /waste-price

```json
[
  {
    "id": "waste_price_string-random",
    "organic": 1000, // Rp
    "inorganic": 2000, // Rp
    "created_at": 1938192831939831,
    "admin": {
      "id": "user_randoms-string-admin",
      "name": "Suastino Budi",
      "photo_url": "www.banksampah.com/photo-profile/user_randoms-string-admin.jpg"
    }
  },
  {
    "id": "waste_price_string-random",
    "organic": 2000,
    "inorganic": 2500,
    "created_at": 1938192831939831,
    "admin": {
      "id": "user_randoms-string-admin",
      "name": "Suastino Budi",
      "photo_url": "www.banksampah.com/photo-profile/user_randoms-string-admin.jpg"
    }
  }
]
```
