import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:lightify/core/data/model/device.dart';
import 'package:lightify/core/data/model/firmware_update_status.dart';
import 'package:lightify/core/data/model/firmware_version.dart';
import 'package:lightify/core/domain/repo/firmware_update_repo.dart';
import 'package:lightify/core/domain/repo/network_repo.dart';
import 'package:lightify/core/ui/bloc/connectivity/connectivity_cubit.dart';
import 'package:lightify/core/ui/bloc/devices/devices_cubit.dart';

part 'firmware_update_state.dart';
part 'firmware_update_cubit.freezed.dart';

@LazySingleton()
class FirmwareUpdateCubit extends Cubit<FirmwareUpdateState> {
  final NetworkRepo _networkRepo;
  final FirmwareUpdateRepo _firmwareUpdateRepo;
  final ConnectivityCubit _connectivityCubit;
  final DevicesCubit _devicesCubit;

  FirmwareUpdateCubit(
    this._networkRepo,
    this._firmwareUpdateRepo,
    this._connectivityCubit,
    this._devicesCubit,
  ) : super(FirmwareUpdateState.initial());

  bool _isUpdating = false;

  Future<void> checkVersion() async {
    emit(state.copyWith(
      errorMessage: null,
      isGettingLatestAvailableVersion: true,
      latestAvailableVersion: const FirmwareVersion.unknown(),
    ));
    if (!isConnected()) {
      await Future<void>.delayed(const Duration(seconds: 1));
    }
    final versionResult = await _firmwareUpdateRepo.getLatestVersionNum();
    var newState = versionResult.fold(
      (l) => state.copyWith(errorMessage: l.errorMessage, isGettingLatestAvailableVersion: false),
      (r) => state.copyWith(isGettingLatestAvailableVersion: false, latestAvailableVersion: r),
    );
    if (versionResult.isRight()) {
      final devicesToUpdate = _retrieveDevicesNeedsUpdate(newState.latestAvailableVersion);
      if (devicesToUpdate.isNotEmpty) {
        newState = newState.copyWith(devicesNeedsAnUpdate: devicesToUpdate.toList());
      }
    }
    emit(newState.copyWith(isChecked: true));
  }

  Iterable<Device> _retrieveDevicesNeedsUpdate(FirmwareVersion latestAvailableVersion) {
    final currentDevices = _devicesCubit.state.availableDevices;
    return currentDevices.where((e) {
      // if has version
      if (e.deviceInfo.firmwareVersion != null && e.deviceInfo.firmwareVersion!.isVersion) {
        // if needs an update
        if (latestAvailableVersion > e.deviceInfo.firmwareVersion!) {
          return true;
        }
      }
      return false;
    });
  }

  Future<void> updateDevice(Device device) async {
    _isUpdating = true;
    await _firmwareUpdateRepo.updateDevice(
      device: device,
      onUpdate: (dev, status) {
        debugPrint('${device.deviceInfo.displayDeviceName} update status: $status');
        final statuses = Map<String, FirmwareUpdateStatus>.from(state.updateStatuses);
        statuses.update(device.deviceInfo.topic, (value) => status, ifAbsent: () => status);
        emit(state.copyWith(updateStatuses: statuses));
      },
    );
    _isUpdating = false;
  }

  Future<void> updateAll() async {
    if (_isUpdating) {
      return;
    }
    for (final device in state.onlyNotUpdatedDevices) {
      /*await*/ updateDevice(device);
      await Future<void>.delayed(const Duration(milliseconds: 200));
    }
  }

  bool isConnected() {
    return _connectivityCubit.state.connectedToNet && _networkRepo.isConnectedToServer();
  }
}
