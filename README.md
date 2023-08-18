# Bank Sampah

Bank Sampah adalah aplikasi mobile flutter sederhana yang digunakan untuk store sampah organik dan organik untuk mendapatkan sejumlah saldo yang dapat ditukar dengan uang.

## Usecase

- [ ] Admin - Melihat laporan bulanan
  - [ ] UI
  - [ ] Bloc
  - [ ] Usecase
  - [ ] Repository
  - [ ] Remote Data Source
- [ ] Admin - Mengubah harga limbah organik dan anorganik per kg.
  - [ ] UI
  - [ ] Bloc
  - [ ] Usecase
  - [ ] Repository
  - [ ] Remote Data Source
- [ ] Admin - Mendaftarkan pengguna baru
  - [ ] UI
  - [ ] Bloc
  - [ ] Usecase
  - [ ] Repository
  - [ ] Remote Data Source
- [ ] Admin - Melihat daftar pengguna
  - [ ] UI
  - [ ] Bloc
  - [ ] Usecase
  - [ ] Repository
  - [ ] Remote Data Source
- [ ] Admin - Mengedit pengguna
  - [ ] UI
  - [ ] Bloc
  - [ ] Usecase
  - [ ] Repository
  - [ ] Remote Data Source
- [ ] Staff - Menarik saldo “warga”
  - [ ] UI
  - [ ] Bloc
  - [ ] Usecase
  - [ ] Repository
  - [ ] Remote Data Source
- [ ] Staff - Melihat daftar pengguna dengan role “warga”
  - [ ] UI
  - [ ] Bloc
  - [ ] Usecase
  - [ ] Repository
  - [ ] Remote Data Source
- [ ] Staff - Memasukan transaksi jumlah limbah organik dan anorganik dari warga
  - [ ] UI
  - [ ] Bloc
  - [ ] Usecase
  - [ ] Repository
  - [ ] Remote Data Source
- [ ] Warga - Melihat jumlah saldo dan limbah yang sudah disimpan di bank sampah.
  - [ ] UI
  - [ ] Bloc
  - [ ] Usecase
  - [ ] Repository
  - [ ] Remote Data Source
- [ ] Semua - dapat mengedit profil masing-masing
  - [ ] UI
  - [ ] Bloc
  - [ ] Usecase
  - [ ] Repository
  - [ ] Remote Data Source

---

## Users

- /users

```json
{
  "id": "user_randoms-string",
  "phone_number": "822-1234-1234",
  "password": "hashing...",
  "role": "warga || staff || admin",
  "full_name": "Kaesa Lyrih",
  "photo_url": "photo-profile/user_random-string.jpg"
}
```

## Point Balance

- /point-balance

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

- /transaction

```json
{
  "id": "transaction_randoms-string",
  "create_at": 12131923192312931,
  "update_at": 12312312313213123,
  "user": {
    "id": "user_randoms-string-warga",
    "name": "Kaesa Lyrih",
    "photo_url": "photo-profile/user_randoms-string-warga.jpg"
  },
  "staff": {
    "id": "user_randoms-string-staff",
    "name": "Farhan Taqi",
    "photo_url": "photo-profile/user_randoms-string-staff.jpg"
  },
  "withdrawn_balance": {
    "balance": 2000000,
    "withdrawn": 1000000,
    "current_balance": 1000000
  },
  "waste": {
    "organic": 10,
    "inorganic": 20
  },
  "price": {
    "organic": 1000,
    "inorganic": 2000,
    "update_at": 1938192831939831
  },
  "history_update": [
    {
      "waste": {
        "organic": 10,
        "inorganic": 20
      },
      "update_at": 12131923192312931
    },
    {
      "waste": {
        "organic": 10,
        "inorganic": 20
      },
      "update_at": 12131923192312931
    }
  ]
}
```

## Current Waste Price

- /waste-price?current=true

```json
{
  "organic": 1000,
  "inorganic": 2000,
  "update_at": 1938192831939831,
  "admin": {
    "id": "user_randoms-string-admin",
    "name": "Suastino Budi",
    "photo_url": "photo-profile/user_randoms-string-admin.jpg"
  }
}
```

## History Waste Price

- /waste-price

```json
[
  {
    "organic": 1000,
    "inorganic": 2000,
    "update_at": 1938192831939831,
    "admin": {
      "id": "user_randoms-string-admin",
      "name": "Suastino Budi",
      "photo_url": "photo-profile/user_randoms-string-admin.jpg"
    }
  },
  {
    "organic": 2000,
    "inorganic": 2500,
    "update_at": 1938192831939831,
    "admin": {
      "id": "user_randoms-string-admin",
      "name": "Suastino Budi",
      "photo_url": "photo-profile/user_randoms-string-admin.jpg"
    }
  }
]
```
