import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:lightify/core/data/model/device.dart';
import 'package:lightify/core/ui/bloc/devices/devices_cubit.dart';
import 'package:lightify/core/ui/bloc/devices/devices_state.dart';
import 'package:lightify/core/ui/extensions/core_extensions.dart';
import 'package:lightify/core/ui/utils/screen_util.dart';

class ApplyFor extends StatelessWidget {
  const ApplyFor({
    super.key,
    required this.selectedDevices,
    required this.onApplyFor,
    required this.currentDevice,
  });

  final Device currentDevice;
  final List<Device> selectedDevices;
  final void Function(Device) onApplyFor;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.grey.shade300.withOpacity(0.04),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: height(18)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: width(18)),
            child: Text('Apply for:', style: context.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
          ),
          SizedBox(height: height(14)),
          BlocBuilder<DevicesCubit, DevicesState>(
            builder: (context, devicesState) {
              final availableDevices = devicesState.devicesByRooms;
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemCount: availableDevices.length,
                itemBuilder: (context, index) {
                  final device = availableDevices[index];
                  final isSelected = selectedDevices.any((e) => e.deviceInfo.topic == device.deviceInfo.topic);
                  return InkWell(
                    onTap: device.deviceInfo.topic == currentDevice.deviceInfo.topic ? null : () => onApplyFor(device),
                    splashColor: Colors.grey.shade400.withOpacity(0.1),
                    highlightColor: Colors.transparent,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: height(12), horizontal: width(18)),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              device.deviceInfo.deviceName,
                              style: context.textTheme.displayMedium
                                  ?.copyWith(color: isSelected ? Colors.white : Colors.grey.shade300.withOpacity(0.8)),
                            ),
                          ),
                          AnimatedScale(
                            scale: isSelected ? 1.0 : 0.0,
                            duration: const Duration(milliseconds: 200),
                            child: Icon(
                              PlatformIcons(context).checkMark,
                              size: height(18),
                              color: device.deviceInfo.topic == currentDevice.deviceInfo.topic
                                  ? Colors.grey.shade400.withOpacity(0.4)
                                  : Colors.grey.shade400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
