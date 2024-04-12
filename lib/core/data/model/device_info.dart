import 'package:lightify/core/data/model/firmware_version.dart';
import 'package:lightify/core/ui/bloc/devices/devices_cubit.dart';
import 'package:lightify/core/ui/constants/app_constants.dart';
import 'package:lightify/di/di.dart';

class DeviceInfo {
  final String deviceName;
  final String deviceGroup;
  final String topic;

  final FirmwareVersion? firmwareVersion;

  const DeviceInfo({
    required this.deviceName,
    required this.deviceGroup,
    required this.topic,
    this.firmwareVersion,
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
        topic = '',
        firmwareVersion = null;

  factory DeviceInfo.fromTopic(String topic) {
    final info = AppConstants.api.DEVICES_INFO[topic] ?? DeviceInfo.empty().copyWith(topic: topic);
    return info;
  }

  DeviceInfo copyWith({
    final String? topic,
    final String? deviceGroup,
    final String? deviceName,
    final FirmwareVersion? firmwareVersion,
  }) {
    return DeviceInfo(
      deviceName: deviceName ?? this.deviceName,
      deviceGroup: deviceGroup ?? this.deviceGroup,
      topic: topic ?? this.topic,
      firmwareVersion: firmwareVersion ?? this.firmwareVersion,
    );
  }

  @override
  String toString() {
    return 'DeviceInfo($deviceName, $deviceGroup, $topic, $firmwareVersion)';
  }
}
