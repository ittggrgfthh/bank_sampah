# Bank Sampah

Bank Sampah adalah aplikasi mobile flutter sederhana yang digunakan untuk store sampah organik dan organik untuk mendapatkan sejumlah saldo yang dapat ditukar dengan uang.

## Usecase

Basic Feature

- User Module (SoftDelete)
- Waste Module (SoftDelete)
- Transaction Module

Base Role Feature

semua

- login
- mengubah profile-nya sendiri
- mendapatkan notifikasi

warga

- create trasaction (punya-nya sendiri)
- read transaction (punya-nya sendiri)
- update transaction (punya-nya sendiri)
  - tidak dapat update jika sudah divalidasi admin
- delete transaction (punya-nya sendiri)
  - tidak dapat update jika sudah divalidasi admin

admin

- create user
- read user
- update user
- delete user

- create waste
- read waste
- update waste
- delete waste

- read history waste

- create trasaction (punya-nya sendiri dan warga)
- read transaction (punya-nya sendiri dan warga)
- update transaction (punya-nya sendiri dan warga)
  - tidak dapat update jika sudah divalidasi admin
- delete transaction (punya-nya sendiri dan warga)
  - tidak dapat update jika sudah divalidasi admin

---
