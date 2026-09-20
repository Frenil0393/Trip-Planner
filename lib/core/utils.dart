import 'package:intl/intl.dart';

class AppUtils {
  static String formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  static String formatDepartureDate(DateTime date) {
    return DateFormat('EEE, MMM d, yyyy').format(date);
  }

  static String formatDateWithWeekday(DateTime date) {
    return DateFormat('EEEE, d MMMM yyyy').format(date);
  }

  static String formatTime(DateTime time) {
    return DateFormat('hh:mm a').format(time);
  }

  /// Formats currency amounts according to Indian Rupee (INR ₹) standards.
  /// (e.g. ₹2,500, ₹45,000, ₹1,20,000, or 'Free Entry' if <= 0).
  static String formatCurrency(num? amount) {
    if (amount == null || amount <= 0) {
      return 'Free Entry';
    }
    final format = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 0,
    );
    return format.format(amount);
  }

  /// Checks if the current time falls between start and end times on the same day.
  /// For this prototype, we'll just check if the hours are close, or simulate it.
  static bool isCurrentActivity(DateTime startTime, DateTime endTime) {
    final now = DateTime.now();
    // In a real app we'd compare dates. Here we just compare time to make the prototype work.
    // We'll normalize to today's date for easy matching.
    final normalizedStart = DateTime(now.year, now.month, now.day, startTime.hour, startTime.minute);
    final normalizedEnd = DateTime(now.year, now.month, now.day, endTime.hour, endTime.minute);
    
    return now.isAfter(normalizedStart) && now.isBefore(normalizedEnd);
  }
}
