import 'package:intl/intl.dart';

class Utils {
  static String millisecondEpochtoString(int millisecondsSinceEpoch) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);
    return DateFormat('yyyy-MM-dd').format(dateTime);
  }

  static String timeAgoFromMillisecond(int millisecondsSinceEpoch) {
    DateTime itemDateTime = DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);
    DateTime now = DateTime.now();
    Duration difference = now.difference(itemDateTime);

    if (difference.inSeconds < 60) {
      return 'diperbarui ${difference.inSeconds} detik yang lalu';
    } else if (difference.inMinutes < 60) {
      return 'diperbarui ${difference.inMinutes} menit yang lalu';
    } else if (difference.inHours < 24) {
      return 'diperbarui ${difference.inHours} jam yang lalu';
    } else if (difference.inDays < 30) {
      return 'diperbarui ${difference.inDays} hari yang lalu';
    } else if (difference.inDays < 365) {
      int months = (difference.inDays / 30).floor();
      return 'diperbarui $months bulan yang lalu';
    } else {
      int years = (difference.inDays / 365).floor();
      return 'diperbarui $years tahun yang lalu';
    }
  }
}
