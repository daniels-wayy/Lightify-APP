import 'package:flutter/material.dart';
import 'package:lightify/core/data/model/device_info.dart';

class Device {
  final bool powered;
  final int brightness;
  final HSVColor color;
  final double breathFactor;
  final DeviceInfo deviceInfo;

  const Device({
    required this.powered,
    required this.brightness,
    required this.color,
    required this.breathFactor,
    required this.deviceInfo,
  });

  // HSVColor get getHSVColor => HSVColor.fromAHSV(
  //       1.0,
  //       FunctionUtil.mapHueTo360(color),
  //       1.0,
  //       1.0,
  //     );

  Color get getColor {
    return color.toColor();
  }

  bool get inBrightRange {
    if (!powered) return false;
    return ((color.saturation >= 0.0 && color.saturation <= 0.6) && color.value > 0.7) ||
        ((color.hue >= 30 && color.hue <= 110));
  }

  Device.empty()
      : powered = false,
        brightness = 0,
        breathFactor = 0.0,
        color = HSVColor.fromColor(Colors.red),
        deviceInfo = DeviceInfo.empty();

  Device copyWith({
    final bool? powered,
  }) =>
      Device(
        powered: powered ?? this.powered,
        color: color,
        brightness: brightness,
        breathFactor: breathFactor,
        deviceInfo: deviceInfo,
      );

  @override
  String toString() {
    return "Device(deviceName: ${deviceInfo.deviceName}, deviceGroup: ${deviceInfo.deviceGroup}, deviceTopic: ${deviceInfo.topic}, powered: $powered, brightness: $brightness, breathFactor: $breathFactor, color: $color)";
  }

  int get intPowerState => powered ? 1 : 0;
}
