// ignore_for_file: constant_identifier_names

// import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:lightify/core/data/model/device.dart';
import 'package:lightify/core/data/model/device_rename_dto.dart';
import 'package:lightify/core/data/storages/common_storage.dart';

import 'devices_state.dart';

@LazySingleton()
class DevicesCubit extends Cubit<DevicesState> {
  final CommonStorage _storage;

  DevicesCubit(this._storage) : super(DevicesState.initialState(_storage));

  void setDevices(List<Device> devices) {
    // debugPrint('DevicesCubit setDevices() - devices: ${devices.length}');
    emit(state.copyWith(availableDevices: devices));
  }

  void renameDevice(String deviceTopic, String newName) {
    var currentRenames = [...state.devicesRenames];

    final thisRenameData = DeviceRenameDTO(newName: newName, deviceTopic: deviceTopic);

    if (currentRenames.any((e) => e.deviceTopic == deviceTopic)) {
      currentRenames = currentRenames.map((e) => e.deviceTopic == deviceTopic ? thisRenameData : e).toList();
    } else {
      currentRenames.add(thisRenameData);
    }

    _storage.storeRenamesData(currentRenames);
    emit(state.copyWith(devicesRenames: currentRenames));
  }
}
