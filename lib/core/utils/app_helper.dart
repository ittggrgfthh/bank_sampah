import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class AppHelper {
  static String v1UUIDWithoutDashes() {
    const uuid = Uuid();
    final v1 = uuid.v1();
    // final v1WithoutDashes = v1.replaceAll('-', '');
    // return v1WithoutDashes;
    return v1;
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

  static String formatToThousands(String text) {
    final formatter = NumberFormat("#,##0", "id_ID");
    final parsedValue = int.tryParse(text) ?? 0;
    return formatter.format(parsedValue);
  }

  static String formatToThousandsInt(int number) {
    final formatter = NumberFormat("#,##0", "id_ID");
    return formatter.format(number);
  }

  static int parseToInteger(String formattedText) {
    return int.parse(formattedText.replaceAll(RegExp(r'[^0-9]'), ''));
  }

  static String intToIDR(int amount) {
    return NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0).format(amount);
  }

  static String millisecondEpochtoString(int millisecondsSinceEpoch) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);
    return DateFormat('dd MMMM yyyy').format(dateTime);
  }

  static String millisecondEpochtoDay(int millisecondsSinceEpoch) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);
    return DateFormat('EEEE').format(dateTime);
  }

  static String timeAgoFromMillisecond(int millisecondsSinceEpoch) {
    DateTime itemDateTime = DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);
    DateTime now = DateTime.now();
    Duration difference = now.difference(itemDateTime);

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds} detik yang lalu';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} menit yang lalu';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} jam yang lalu';
    } else if (difference.inDays < 30) {
      return '${difference.inDays} hari yang lalu';
    } else if (difference.inDays < 365) {
      int months = (difference.inDays / 30).floor();
      return '$months bulan yang lalu';
    } else {
      int years = (difference.inDays / 365).floor();
      return '$years tahun yang lalu';
    }
  }

  static bool isWithin30Minutes(int millisecondsSinceEpoch) {
    DateTime now = DateTime.now();
    int nowInMillisecondsSinceEpoch = now.millisecondsSinceEpoch;
    int differenceMillisecondsEpoch = nowInMillisecondsSinceEpoch - millisecondsSinceEpoch;

    return (differenceMillisecondsEpoch / (1000 * 60)) < 30;
  }

  static bool isWithin5Minutes(int millisecondsSinceEpoch) {
    DateTime now = DateTime.now();
    int nowInMillisecondsSinceEpoch = now.millisecondsSinceEpoch;
    int differenceMillisecondsEpoch = nowInMillisecondsSinceEpoch - millisecondsSinceEpoch;

    return (differenceMillisecondsEpoch / (1000 * 60)) < 5;
  }
}
