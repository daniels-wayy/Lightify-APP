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

  factory Device.unreachable(String remote) {
    var deviceName = remote;
    deviceName = deviceName.replaceAll('${AppConstants.api.COMMUNICATION_HEADER}_', '');
    deviceName = deviceName.replaceAll('${AppConstants.api.COMMUNICATION_HEADER2}_', '');
    return Device.empty().copyWith(
      color: HSVColor.fromColor(Colors.grey.shade300),
      deviceInfo: DeviceInfo(
        deviceName: deviceName,
        deviceGroup: AppConstants.strings.UNAVAILABLE,
        topic: remote,
      ),
    );
  }

  bool get isUnreachable => deviceInfo.deviceGroup == AppConstants.strings.UNAVAILABLE;

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
    final int? brightness,
    final HSVColor? color,
    final DeviceInfo? deviceInfo,
  }) =>
      Device(
        powered: powered ?? this.powered,
        color: color ?? this.color,
        brightness: brightness ?? this.brightness,
        breathFactor: breathFactor,
        deviceInfo: deviceInfo ?? this.deviceInfo,
        effectId: effectId,
        effectSpeed: effectSpeed,
        effectScale: effectScale,
      );

  @override
  String toString() {
    return "Device(deviceName: ${deviceInfo.deviceName}, deviceGroup: ${deviceInfo.deviceGroup}, deviceTopic: ${deviceInfo.topic}, powered: $powered, brightness: $brightness, breathFactor: $breathFactor, color: $color, effectId: $effectId)";
  }

  int get intPowerState => powered ? 1 : 0;

  double get brightnessFactor => brightness / AppConstants.api.MQTT_DEVICE_MAX_BRIGHTNESS;
}
