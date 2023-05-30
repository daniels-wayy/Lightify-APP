class CurrentDeviceInfo {
  final String deviceName;
  final String osVersion;
  final String appInfo;
  final String? deviceId;

  CurrentDeviceInfo({
    required this.deviceName,
    required this.osVersion,
    required this.appInfo,
    required this.deviceId,
  });

  @override
  String toString() {
    return '"$deviceName", $osVersion, $appInfo; $deviceId;';
  }
}
