// Import paket dbcrypt.dart yang diperlukan
import 'package:dbcrypt/dbcrypt.dart';

// Definisi kelas Hash
class HashFacade {
  /// Instance tunggal dari kelas Hash (Singleton)
  static final HashFacade _instance = HashFacade._internal(DBCrypt());

  /// Variabel instance DBCrypt yang tidak dapat diubah setelah inisialisasi
  final DBCrypt _dbCrypt;

  /// Konstruktor pribadi untuk mencegah instansiasi langsung dari luar kelas
  /// - @param dbCrypt: Instance dari kelas DBCrypt yang akan digunakan untuk hashing
  HashFacade._internal(this._dbCrypt);

  /// Factory constructor untuk mendapatkan instance tunggal dari kelas Hash
  factory HashFacade() {
    return _instance;
  }

  /// Metode untuk membuat hash
  /// - @param value: Nilai yang akan di-hash
  /// - @param rounds: Jumlah putaran untuk pembuatan salt (opsional, default: 10)
  /// - @return: String yang merupakan hasil hashing dari nilai yang diberikan
  ///
  /// Contoh:
  /// ```dart
  /// final password = 'password';
  /// final hashValue = Hash().make(password);
  /// print(hashValue); // output: $2b$10$EJYJ3yOCKH3NteKd54Jd0O7oR3Nng3zSoQxd3Nrqi1bHi7x44ANPO
  ///
  /// final hashValueRound12 = Hash().make(password, rounds: 12);
  /// print(hashValueRound12); // output: $2b$12$0n96bUatbu5h0AIFZnmI9.wPAfnAmGc.C7D8ZQLWgH7hxLkj0MM0S
  /// ```
  String make(String value, {int rounds = 10}) {
    return _dbCrypt.hashpw(value, _dbCrypt.gensaltWithRounds(rounds));
  }

  /// Metode untuk memeriksa hash
  /// - @param value: Nilai yang akan diperiksa
  /// - @param hashValue: Nilai hash yang akan dibandingkan
  /// - @return: `true` jika nilai sesuai dengan hash, `false` jika tidak
  ///
  /// Contoh:
  /// ```dart
  /// final password = 'password';
  /// final hashValue = Hash().make(password);
  /// print(Hash().check(password, hashValue)); // output: true
  /// print(Hash().check('wrong_password', hashValue)); // output: false
  /// ```
  bool check(String value, String hashValue) {
    return _dbCrypt.checkpw(value, hashValue);
  }
}
