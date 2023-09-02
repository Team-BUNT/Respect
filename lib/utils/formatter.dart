import 'package:intl/intl.dart';

class Formatter {
  static String formatNumber(int number) {
    final formatter = NumberFormat('#,###');
    return formatter.format(number);
  }
}
