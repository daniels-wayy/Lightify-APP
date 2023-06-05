import 'package:flutter/rendering.dart';

class ColorsUtil {
  static String encodeColor(Color color) {
    final valueString = (color.toString()).split('(0x')[1].split(')')[0];
    return valueString;
  }

  static Color decodeColor(String value) {
    final color = Color(int.parse(value, radix: 16));
    return color;
  }
}
