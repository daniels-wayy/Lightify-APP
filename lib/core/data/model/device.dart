import 'package:flutter/material.dart';
import 'package:lightify/core/data/model/device_info.dart';
import 'package:lightify/core/ui/constants/app_constants.dart';
import 'package:lightify/core/ui/styles/colors/app_colors.dart';

class Device {
  final bool powered;
  final int brightness;
  final HSVColor color;
  final double breathFactor;
  final DeviceInfo deviceInfo;

  final int effectId;
  final int effectSpeed;
  final int effectScale;

  const Device({
    required this.powered,
    required this.brightness,
    required this.color,
    required this.breathFactor,
    required this.deviceInfo,
    required this.effectId,
    required this.effectSpeed,
    required this.effectScale,
  });

  bool get effectRunning => effectId > 0;

  Color get getCardColor {
    if (!powered) {
      return AppColors.gray200;
    }
    if (effectRunning) {
      final effectColor = AppConstants.settings.effects.firstWhere((e) => e.id == effectId).previewColor;
      return effectColor;
    }
    return getColor;
  }

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
        deviceInfo = DeviceInfo.empty(),
        effectId = 0,
        effectSpeed = AppConstants.api.EFFECT_MIN_SPEED,
        effectScale = AppConstants.api.EFFECT_MIN_SCALE;

  Device copyWith({
    final bool? powered,
  }) =>
      Device(
        powered: powered ?? this.powered,
        color: color,
        brightness: brightness,
        breathFactor: breathFactor,
        deviceInfo: deviceInfo,
        effectId: effectId,
        effectSpeed: effectSpeed,
        effectScale: effectScale,
      );

  @override
  String toString() {
    return "Device(deviceName: ${deviceInfo.deviceName}, deviceGroup: ${deviceInfo.deviceGroup}, deviceTopic: ${deviceInfo.topic}, powered: $powered, brightness: $brightness, breathFactor: $breathFactor, color: $color, effectId: $effectId)";
  }

  int get intPowerState => powered ? 1 : 0;
}
