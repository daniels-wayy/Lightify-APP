import 'package:flutter/material.dart';
import 'package:lightify/core/data/model/device_info.dart';
import 'package:lightify/core/ui/bloc/firmware_update/firmware_update_cubit.dart';
import 'package:lightify/core/ui/constants/app_constants.dart';
import 'package:lightify/core/ui/styles/colors/app_colors.dart';
import 'package:lightify/di/di.dart';

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
    return Device.empty().copyWith(
      color: HSVColor.fromColor(Colors.grey.shade300),
      deviceInfo: AppConstants.api.DEVICES_INFO[remote]?.copyWith(
            deviceGroup: AppConstants.strings.UNAVAILABLE,
          ) ??
          DeviceInfo.empty().copyWith(topic: remote, deviceGroup: AppConstants.strings.UNAVAILABLE),
    );
  }

  bool get isUnreachable => deviceInfo.deviceGroup == AppConstants.strings.UNAVAILABLE;

  bool get effectRunning => effectId > 0;

  Color get getCardColor {
    if (!powered) {
      return AppColors.gray200;
    }
    if (effectRunning && !AppConstants.settings.colorFreeEffects.any((fx) => fx == effectId)) {
      try {
        final effectColor = AppConstants.settings.effects.firstWhere((e) => e.id == effectId).previewColor;
        return effectColor;
      } on StateError {
        return getColor;
      }
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

  bool get needsUpdate {
    final toUpdate = getIt<FirmwareUpdateCubit>().state.latestAvailableVersion;
    if (toUpdate.isVersion && (deviceInfo.firmwareVersion != null && deviceInfo.firmwareVersion!.isVersion)) {
      return toUpdate > deviceInfo.firmwareVersion!;
    }
    return false;
  }
}
