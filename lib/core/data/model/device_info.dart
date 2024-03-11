import 'package:lightify/core/ui/bloc/devices/devices_cubit.dart';
import 'package:lightify/di/di.dart';

class DeviceInfo {
  final String deviceName;
  final String deviceGroup;
  final String topic;

  const DeviceInfo({
    required this.deviceName,
    required this.deviceGroup,
    required this.topic,
  });

  String get displayDeviceName {
    final renamesData = getIt<DevicesCubit>().state.devicesRenames;
    try {
      return renamesData.firstWhere((e) => e.deviceTopic == topic).newName;
    } on StateError {
      return deviceName;
    }
  }

  DeviceInfo.empty()
      : deviceName = '',
        deviceGroup = '',
        topic = '';

  DeviceInfo copyWith({
    final String? topic,
    final String? deviceGroup,
    final String? deviceName,
  }) {
    return DeviceInfo(
      deviceName: deviceName ?? this.deviceName,
      deviceGroup: deviceGroup ?? this.deviceGroup,
      topic: topic ?? this.topic,
    );
  }
}
