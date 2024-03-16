import 'package:flutter/material.dart';
import 'package:flutter_adaptive_ui/flutter_adaptive_ui.dart';
import 'package:lightify/core/data/model/device.dart';
import 'package:lightify/pages/main/home/ui/widget/adaptive/default_home_body.dart';
import 'package:lightify/pages/main/home/ui/widget/adaptive/desktop_home_body.dart';
import 'package:lightify/pages/main/home/ui/widget/adaptive/tablet_home_body.dart';

class AdaptiveHomeBody extends StatelessWidget {
  final Map<String, List<Device>> groupedDevices;
  final void Function(Device, bool) onDevicePowerChanged;
  final void Function(Device, int) onDeviceBrightnessChanged;
  final void Function(Device, HSVColor) onDeviceColorChanged;
  final void Function(Device, double) onDeviceBreathChanged;
  final void Function(Device, int) onDeviceEffectChanged;
  final void Function(Device, double) onDeviceEffectSpeedChanged;
  final void Function(Device, double) onDeviceEffectScaleChanged;
  final void Function(List<Device>) onDeviceGroupSleepMode;
  final void Function(List<Device>) onDeviceGroupTurnOff;
  final Future Function() onRefresh;
  final void Function(Map<String, List<Device>>, int, int) onReorder;

  const AdaptiveHomeBody({
    super.key,
    required this.groupedDevices,
    required this.onDevicePowerChanged,
    required this.onDeviceBrightnessChanged,
    required this.onDeviceColorChanged,
    required this.onDeviceBreathChanged,
    required this.onDeviceEffectChanged,
    required this.onDeviceEffectSpeedChanged,
    required this.onDeviceEffectScaleChanged,
    required this.onDeviceGroupSleepMode,
    required this.onDeviceGroupTurnOff,
    required this.onRefresh,
    required this.onReorder,
  });

  @override
  Widget build(BuildContext context) {
    return AdaptiveBuilder(
      defaultBuilder: (context, _) => DefaultHomeBody(
        groupedDevices: groupedDevices,
        onRefresh: onRefresh,
        onReorder: onReorder,
        onDevicePowerChanged: onDevicePowerChanged,
        onDeviceBrightnessChanged: onDeviceBrightnessChanged,
        onDeviceColorChanged: onDeviceColorChanged,
        onDeviceBreathChanged: onDeviceBreathChanged,
        onDeviceEffectChanged: onDeviceEffectChanged,
        onDeviceEffectSpeedChanged: onDeviceEffectSpeedChanged,
        onDeviceEffectScaleChanged: onDeviceEffectScaleChanged,
        onDeviceGroupSleepMode: onDeviceGroupSleepMode,
        onDeviceGroupTurnOff: onDeviceGroupTurnOff,
      ),
      layoutDelegate: AdaptiveLayoutDelegateWithMinimallScreenType(
        tablet: (context, _) => TabletHomeBody(
          groupedDevices: groupedDevices,
          onRefresh: onRefresh,
          onReorder: onReorder,
          onDevicePowerChanged: onDevicePowerChanged,
          onDeviceBrightnessChanged: onDeviceBrightnessChanged,
          onDeviceColorChanged: onDeviceColorChanged,
          onDeviceBreathChanged: onDeviceBreathChanged,
          onDeviceEffectChanged: onDeviceEffectChanged,
          onDeviceEffectSpeedChanged: onDeviceEffectSpeedChanged,
          onDeviceEffectScaleChanged: onDeviceEffectScaleChanged,
          onDeviceGroupSleepMode: onDeviceGroupSleepMode,
          onDeviceGroupTurnOff: onDeviceGroupTurnOff,
        ),
        desktop: (context, _) => DesktopHomeBody(
          groupedDevices: groupedDevices,
          onRefresh: onRefresh,
          onReorder: onReorder,
          onDevicePowerChanged: onDevicePowerChanged,
          onDeviceBrightnessChanged: onDeviceBrightnessChanged,
          onDeviceColorChanged: onDeviceColorChanged,
          onDeviceBreathChanged: onDeviceBreathChanged,
          onDeviceEffectChanged: onDeviceEffectChanged,
          onDeviceEffectSpeedChanged: onDeviceEffectSpeedChanged,
          onDeviceEffectScaleChanged: onDeviceEffectScaleChanged,
          onDeviceGroupSleepMode: onDeviceGroupSleepMode,
          onDeviceGroupTurnOff: onDeviceGroupTurnOff,
        ),
      ),
    );
  }
}
