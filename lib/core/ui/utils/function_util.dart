import 'dart:math';

import 'package:lightify/core/ui/constants/app_constants.dart';

class FunctionUtil {
  static double mapHueTo360(int hueVal) {
    final v = hueVal * (360 / 255);
    return min(v, 360);
  }

  static double mapHueFrom360(double hueVal) {
    final v = hueVal * (255 / 360);
    return min(v, 255);
  }

  static String generateRandomString(int len) {
    final r = Random();
    const chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => chars[r.nextInt(chars.length)]).join();
  }

  static double mapValue(double value, double min, double max) {
    return (value - min) / (max - min);
  }

  static double reverseMapValue(double value, double min, double max) {
    return value * (max - min) + min;
  }

  static int fromPercentToBrightness(int value) {
    return ((value / 100) * AppConstants.api.MQTT_DEVICE_MAX_BRIGHTNESS).round();
  }

  static int fromBrightnessToPercent(int value) {
    return ((value / AppConstants.api.MQTT_DEVICE_MAX_BRIGHTNESS) * 100).round();
  }

  static DateTime nowMinDate() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, now.hour, now.minute);
  }
}
