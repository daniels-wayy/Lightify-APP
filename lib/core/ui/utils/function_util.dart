import 'dart:math';

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
}
