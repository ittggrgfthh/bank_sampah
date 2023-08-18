import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:uuid/uuid.dart';

class AppHelper {
  static String v4UUIDWithoutDashes() {
    const uuid = Uuid();
    final v4 = uuid.v4();
    final v4WithoutDashes = v4.replaceAll('-', '');
    return v4WithoutDashes;
  }

  static String hashPassword(String password) {
    final salt = dotenv.env['SALT'] ?? ''; // Mengambil salt dari environment variable
    const codec = utf8;
    final key = utf8.encode(salt);
    final bytes = codec.encode(password);

    final hmacSha256 = Hmac(sha256, key); // Gunakan algoritma yang sesuai
    final digest = hmacSha256.convert(bytes);

    return digest.toString();
  }
}
