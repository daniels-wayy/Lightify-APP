class DateTimeUtil {
  static DateTime nowAbsoluteDate() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, now.hour, now.minute);
  }
}
