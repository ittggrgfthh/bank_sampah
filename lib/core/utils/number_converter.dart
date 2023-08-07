import 'package:intl/intl.dart';

class NumberConverter {
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
}
