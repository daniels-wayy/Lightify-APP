import 'package:flutter/material.dart';
import 'package:lightify/core/ui/extensions/core_extensions.dart';
import 'package:lightify/core/ui/utils/vibration_util.dart';
import 'package:lightify/core/ui/widget/common/bouncing_widget.dart';
import 'package:lightify/pages/main/settings/home_widgets/data/models/home_widget_device_entity.dart';

class HomeWidgetDeviceRow extends StatelessWidget {
  const HomeWidgetDeviceRow({
    super.key,
    required this.entity,
    this.isSelected = false,
    required this.onTap,
    required this.deviceName,
  });

  final HomeWidgetDeviceEntity entity;
  final bool isSelected;
  final void Function(HomeWidgetDeviceEntity) onTap;
  final String deviceName;

  @override
  Widget build(BuildContext context) {
    return BouncingWidget(
      bounceOnTap: true,
      minScale: 1.02,
      onTap: () {
        onTap(entity);
        VibrationUtil.vibrate();
      },
      child: Row(
        children: [
          Icon(entity.icon, color: Colors.grey, size: 32),
          const SizedBox(width: 12),
          Text(deviceName,
              style: context.textTheme.displayLarge?.copyWith(letterSpacing: -0.4, fontWeight: FontWeight.w500)),
          const Spacer(),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            child: isSelected ? const Icon(Icons.check, color: Colors.white, size: 24) : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
