class DeviceInfo {
  final String deviceName;
  final String deviceGroup;
  final String topic;

  const DeviceInfo({
    required this.deviceName,
    required this.deviceGroup,
    required this.topic,
  });

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
