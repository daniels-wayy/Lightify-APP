import 'package:flutter/rendering.dart';
import 'package:lightify/core/data/model/device_info.dart';

class DeviceDetailsPageArgs {
  final DeviceInfo deviceInfo;
  final void Function(bool)? onPowerChanged;
  final void Function(int)? onBrightnessChanged;
  final void Function(HSVColor)? onColorChanged;
  final void Function(double)? onBreathChanged;
  final void Function(int) onEffectChanged;
  final void Function(double) onEffectSpeedChanged;
  final void Function(double) onEffectScaleChanged;

  const DeviceDetailsPageArgs({
    required this.deviceInfo,
    required this.onPowerChanged,
    required this.onBrightnessChanged,
    required this.onColorChanged,
    required this.onBreathChanged,
    required this.onEffectChanged,
    required this.onEffectSpeedChanged,
    required this.onEffectScaleChanged,
  });
}
