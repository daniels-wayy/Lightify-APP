import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lightify/core/ui/bloc/devices/devices_cubit.dart';
import 'package:lightify/core/ui/bloc/devices/devices_state.dart';
import 'package:lightify/core/ui/utils/screen_util.dart';
import 'package:lightify/pages/main/settings/home_widgets/data/models/home_widget_device_entity.dart';
import 'package:lightify/pages/main/settings/home_widgets/ui/widgets/home_widget_variants/home_widget_medium_widget.dart';
import 'package:lightify/pages/main/settings/home_widgets/ui/widgets/page_widgets/home_widget_device_row_widget.dart';

class MediumWidgetPage extends StatelessWidget {
  const MediumWidgetPage({
    super.key,
    required this.selectedDevices,
    required this.onTap,
  });

  final List<HomeWidgetDeviceEntity> selectedDevices;
  final void Function(HomeWidgetDeviceEntity) onTap;

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(horizontal: width(18), vertical: height(12)).copyWith(
        bottom: height(128),
      ),
      children: [
        SizedBox(height: height(24)),
        const Align(alignment: Alignment.center, child: HomeWidgetMedium()),
        SizedBox(height: height(48)),
        BlocBuilder<DevicesCubit, DevicesState>(builder: (context, devicesState) {
          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final item = devicesState.devicesByRooms[index];
              final isSelected = selectedDevices.any((device) => device.deviceTopic == item.deviceInfo.topic);
              return HomeWidgetDeviceRow(
                entity: HomeWidgetDeviceEntity.fromDevice(item),
                isSelected: isSelected,
                onTap: onTap,
                deviceName: item.deviceInfo.displayDeviceName,
              );
            },
            separatorBuilder: (_, __) => SizedBox(height: height(22)),
            itemCount: devicesState.devicesByRooms.length,
            padding: EdgeInsets.symmetric(horizontal: width(12)),
          );
        }),
      ],
    );
  }
}
