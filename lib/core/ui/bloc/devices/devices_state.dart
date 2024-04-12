import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lightify/core/data/model/device.dart';
import 'package:collection/collection.dart';
import 'package:lightify/core/data/model/device_rename_dto.dart';
import 'package:lightify/core/data/model/device_settings.dart';
import 'package:lightify/core/data/model/workflow_response.dart';
import 'package:lightify/core/data/storages/common_storage.dart';

part 'devices_state.freezed.dart';

@freezed
class DevicesState with _$DevicesState {
  const DevicesState._();
  const factory DevicesState({
    required List<Device> availableDevices,
    required List<DeviceRenameDTO> devicesRenames,
    DeviceSettings? receivedDeviceSettings,
    WorkflowResponse? receivedDeviceWorkflows,
  }) = _DevicesState;

  factory DevicesState.initialState(CommonStorage storage) => DevicesState(
        availableDevices: [],
        devicesRenames: storage.getRenamesData(),
      );

  Device? findDeviceById(String id) {
    return availableDevices.firstWhereOrNull((e) => e.deviceInfo.topic == id);
  }

  List<Device> get devicesByRooms {
    final grouped = availableDevices.groupListsBy((device) => device.deviceInfo.deviceGroup);
    return grouped.values.expand((e) => e).toList();
  }
}
