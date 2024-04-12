import 'package:lightify/core/data/model/firmware_update_status.dart';

class DeviceFirmwareUpdate {
  final String topic;
  final FirmwareUpdateStatus status;
  const DeviceFirmwareUpdate({required this.topic, required this.status});
}
