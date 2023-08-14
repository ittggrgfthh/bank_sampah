import 'package:intl/intl.dart';

class DateTimeConverter {
  static String millisecondEpochtoString(int millisecondsSinceEpoch) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);
    return DateFormat('dd MMMM yyyy').format(dateTime);
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
}
