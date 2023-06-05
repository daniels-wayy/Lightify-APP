import 'package:flutter/material.dart';
import 'package:lightify/core/data/model/device.dart';
import 'package:lightify/core/ui/animation/fade_animation.dart';
import 'package:lightify/core/ui/extensions/core_extensions.dart';
import 'package:lightify/core/ui/styles/colors/app_colors.dart';
import 'package:lightify/core/ui/utils/screen_util.dart';
import 'package:lightify/core/ui/widget/common/bouncing_widget.dart';
import 'package:lightify/pages/main/home/ui/widget/device_card.dart';

class DevicesGroup extends StatelessWidget {
  final int groupIndex;
  final String groupName;
  final List<Device> groupDevices;
  final void Function(Device, bool) onDevicePowerChanged;
  final void Function(Device, int) onDeviceBrightnessChanged;
  final void Function(Device, HSVColor) onDeviceColorChanged;
  final void Function(Device, double) onDeviceBreathChanged;
  final void Function(List<Device>) onDeviceGroupSleepMode;
  final void Function(List<Device>) onDeviceGroupTurnOff;

  const DevicesGroup({
    super.key,
    required this.groupName,
    required this.groupIndex,
    required this.groupDevices,
    required this.onDevicePowerChanged,
    required this.onDeviceBrightnessChanged,
    required this.onDeviceColorChanged,
    required this.onDeviceBreathChanged,
    required this.onDeviceGroupSleepMode,
    required this.onDeviceGroupTurnOff,
  });

  @override
  Widget build(BuildContext context) {
    if (groupDevices.isEmpty) {
      return const SizedBox.shrink();
    }
    return FadeAnimation(
      delay: Duration(milliseconds: groupIndex * 300),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                groupName,
                style: context.textTheme.titleLarge?.copyWith(
                  // fontWeight: FontWeight.w700,
                  letterSpacing: -0.55,
                ),
              ),
              const Spacer(),
              BouncingWidget(
                onTap: () => onDeviceGroupSleepMode(groupDevices),
                child: Icon(Icons.bedtime_outlined, color: AppColors.gray200, size: height(22)),
              ),
              SizedBox(width: width(12)),
              BouncingWidget(
                onTap: () => onDeviceGroupTurnOff(groupDevices),
                child: Icon(Icons.power_settings_new_outlined, color: AppColors.gray200, size: height(22)),
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
              crossAxisCount: 2,
              mainAxisSpacing: width(12),
              crossAxisSpacing: height(12),
            ),
            itemBuilder: (_, index) {
              final device = groupDevices[index];
              return DeviceCard(
                device: device,
                heroTag: device.deviceInfo.topic,
                onPowerChanged: (state) => onDevicePowerChanged(device, state),
                onBrightnessChanged: (state) => onDeviceBrightnessChanged(device, state),
                onColorChanged: (state) => onDeviceColorChanged(device, state),
                onBreathChanged: (state) => onDeviceBreathChanged(device, state),
              );
            },
          ),
          SizedBox(height: height(32)),
        ],
      ),
    );
  }
}
