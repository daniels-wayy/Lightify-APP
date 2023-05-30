// ignore_for_file: constant_identifier_names

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:lightify/core/data/model/device.dart';

import 'devices_state.dart';

@LazySingleton()
class DevicesCubit extends Cubit<DevicesState> {
  DevicesCubit() : super(DevicesState.initialState());

  void setDevices(List<Device> devices) {
    emit(state.copyWith(availableDevices: devices));
  }
}
