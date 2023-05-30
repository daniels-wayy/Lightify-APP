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
}
