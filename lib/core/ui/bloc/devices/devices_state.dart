import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lightify/core/data/model/device.dart';
import 'package:collection/collection.dart';

part 'devices_state.freezed.dart';

@freezed
class DevicesState with _$DevicesState {
  const DevicesState._();
  const factory DevicesState({
    required List<Device> availableDevices,
  }) = _DevicesState;

  factory DevicesState.initialState() => const DevicesState(
        availableDevices: [],
      );

  Device? findDeviceById(String id) {
    return availableDevices.firstWhereOrNull((e) => e.deviceInfo.topic == id);
  }
}
