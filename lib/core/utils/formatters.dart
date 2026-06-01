// lib/core/utils/formatters.dart

import 'package:intl/intl.dart';

class Formatters {
  Formatters._();

  /// Formats raw numeric values into standard Kenyan Shilling currency format
  /// Example: 2500.5 -> KES 2,500.50
  static String formatCurrency(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'en_KE',
      symbol: 'KES ',
      decimalDigits: 2,
    );
    return formatter.format(amount);
  }

  /// Converts a raw PostgreSQL telemetry string or DateTime object into a highly readable string format
  /// Example: 2026-05-26 -> May 26, 2026
  static String formatDate(dynamic date) {
    if (date == null) return 'N/A';

    try {
      DateTime parsedDate;
      if (date is String) {
        parsedDate = DateTime.parse(date);
      } else if (date is DateTime) {
        parsedDate = date;
      } else {
        return 'N/A';
      }

      return DateFormat.yMMMMd().format(parsedDate);
    } catch (_) {
      return 'N/A';
    }
  }

  /// Appends standard cubic meter annotations to raw water volume readings
  /// Example: 45.231 -> 45.23 m³
  static String formatWaterVolume(double volume) {
    return '${volume.toStringAsFixed(2)} m³';
  }
}