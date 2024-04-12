import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lightify/core/data/model/device.dart';
import 'package:lightify/core/data/model/device_firmware_update.dart';
import 'package:lightify/core/data/model/device_settings.dart';
import 'package:lightify/core/data/model/workflow_response.dart';

part 'server_response_type.freezed.dart';

@freezed
abstract class ServerResponseType with _$ServerResponseType{
  const factory ServerResponseType.deviceState(Device device) = _DeviceState;
  const factory ServerResponseType.deviceSettings(DeviceSettings settings) = _DeviceSettings;
  const factory ServerResponseType.deviceWorkflows(WorkflowResponse workflows) = _DeviceWorkflows;
  const factory ServerResponseType.firmwareUpdateStatus(DeviceFirmwareUpdate update) = _FirmwareUpdateStatus;
  const factory ServerResponseType.unknown(String data) = _Unknown;
  const factory ServerResponseType.error(String error) = _Error;
  const factory ServerResponseType.empty() = _Empty;
}