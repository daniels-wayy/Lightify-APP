import 'package:flutter/services.dart';

class VibrationUtil {
  static Future<void> vibrate() async {
    await HapticFeedback.lightImpact();
  }
}
