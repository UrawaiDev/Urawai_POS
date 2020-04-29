import 'package:intl/intl.dart';

class Formatter {
  static String currencyFormat(double price) {
    final _formatCurrency = NumberFormat.currency(
      symbol: 'Rp.',
      locale: 'en_US',
      decimalDigits: 0,
    );
    return _formatCurrency.format(price);
  }

  static String dateFormat(DateTime date) {
    if (date == null) return '-';

    return DateFormat("d-M-y").add_Hm().format(date);
  }
}
