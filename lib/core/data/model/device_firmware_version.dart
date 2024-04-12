import 'package:lightify/core/data/model/firmware_version.dart';

class DeviceFirmwareVersion {
  final String remote;
  final FirmwareVersion version;
  const DeviceFirmwareVersion({required this.remote, required this.version});

  @override
  String toString() {
    return 'Device($remote, version: $version)';
  }
}
