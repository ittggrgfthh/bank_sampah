import 'package:intl/intl.dart';

class CurrencyConverter {
  static String intToIDR(int amount) {
    return NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0).format(amount);
  }
}
