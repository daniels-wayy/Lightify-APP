import 'package:flutter/material.dart';
import 'package:lightify/core/data/model/device.dart';
import 'package:lightify/core/ui/extensions/core_extensions.dart';
import 'package:lightify/core/ui/utils/screen_util.dart';
import 'package:lightify/core/ui/widget/common/bouncing_widget.dart';
import 'package:lightify/pages/main/home/ui/widget/adaptive/adaptive_layout_type.dart';
import 'package:lightify/pages/main/home/ui/widget/device_card.dart';

class DevicesGroup extends StatelessWidget {
  final int groupIndex;
  final String groupName;
  final List<Device> groupDevices;
  final void Function(Device, bool) onDevicePowerChanged;
  final void Function(Device, int) onDeviceBrightnessChanged;
  final void Function(Device, HSVColor) onDeviceColorChanged;
  final void Function(Device, double) onDeviceBreathChanged;
  final void Function(Device, int) onDeviceEffectChanged;
  final void Function(Device, double) onDeviceEffectSpeedChanged;
  final void Function(Device, double) onDeviceEffectScaleChanged;
  final void Function(List<Device>) onDeviceGroupSleepMode;
  final void Function(List<Device>) onDeviceGroupTurnOff;
  final AdaptiveLayoutType layoutType;

  const DevicesGroup({
    super.key,
    required this.groupName,
    required this.groupIndex,
    required this.groupDevices,
    required this.onDevicePowerChanged,
    required this.onDeviceBrightnessChanged,
    required this.onDeviceColorChanged,
    required this.onDeviceBreathChanged,
    required this.onDeviceEffectChanged,
    required this.onDeviceEffectSpeedChanged,
    required this.onDeviceEffectScaleChanged,
    required this.onDeviceGroupSleepMode,
    required this.onDeviceGroupTurnOff,
    this.layoutType = AdaptiveLayoutType.regular,
  });

  @override
  Widget build(BuildContext context) {
    if (groupDevices.isEmpty) {
      return const SizedBox.shrink();
    }
    return Material(
      color: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                groupName,
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: height(24),
                  letterSpacing: -0.2,
                ),
              ),
              if (layoutType != AdaptiveLayoutType.desktop) const Spacer(),
              SizedBox(width: width(layoutType != AdaptiveLayoutType.desktop ? 8 : 12)),
              if (groupDevices.length > 1)
                BouncingWidget(
                  onTap: () => onDeviceGroupTurnOff(groupDevices),
                  child: Icon(
                    Icons.power_settings_new_outlined,
                    color: groupDevices.every((device) => !device.powered) ? Colors.green : Colors.red,
                    size: height(22),
                  ),
                ),
            ],
          ),
          SizedBox(height: height(12)),
          GridView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: groupDevices.length,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 1.35,
              mainAxisSpacing: width(12),
              crossAxisSpacing: height(12),
              crossAxisCount: layoutType.itemsCrossAxisCount,
            ),
            itemBuilder: (_, index) {
              final device = groupDevices[index];
              return DeviceCard(
                device: device,
                // heroTag: device.deviceInfo.topic,
                onPowerChanged: (state) => onDevicePowerChanged(device, state),
                onBrightnessChanged: (state) => onDeviceBrightnessChanged(device, state),
                onColorChanged: (state) => onDeviceColorChanged(device, state),
                onBreathChanged: (state) => onDeviceBreathChanged(device, state),
                onEffectChanged: (state) => onDeviceEffectChanged(device, state),
                onEffectSpeedChanged: (state) => onDeviceEffectSpeedChanged(device, state),
                onEffectScaleChanged: (state) => onDeviceEffectScaleChanged(device, state),
                brightnessIconSize: layoutType.brightnessIconSize,
                layoutType: layoutType,
              );
            },
          ),
          SizedBox(height: height(32)),
        ],
      ),
    );
  }
}
