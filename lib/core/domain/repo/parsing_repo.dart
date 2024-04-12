import 'package:lightify/core/data/model/device.dart';
import 'package:lightify/core/data/model/device_firmware_update.dart';
import 'package:lightify/core/data/model/device_settings.dart';
import 'package:lightify/core/data/model/workflow_response.dart';

abstract class ParsingRepo {
  Device? parseDevice(String data);
  DeviceSettings? parseDeviceSettings(String data);
  WorkflowResponse? parseDeviceWorkflows(String data);
  DeviceFirmwareUpdate? parseDeviceFirmwareUpdateStatus(String data);
}
