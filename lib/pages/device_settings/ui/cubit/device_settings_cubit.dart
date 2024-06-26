import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:lightify/core/data/model/device.dart';
import 'package:lightify/core/data/model/device_settings.dart';
import 'package:lightify/core/domain/repo/device_repo.dart';

part 'device_settings_state.dart';
part 'device_settings_cubit.freezed.dart';

@injectable
class DeviceSettingsCubit extends Cubit<DeviceSettingsState> {
  final DeviceRepo _deviceRepo;

  DeviceSettingsCubit(this._deviceRepo) : super(DeviceSettingsState.initial());

  Timer? _loadingTimer;

  @override
  Future<void> close() {
    _loadingTimer?.cancel();
    return super.close();
  }

  void fetch(String topic) {
    emit(state.copyWith(isLoading: true));
    _loadingTimer = Timer(
      const Duration(seconds: 2),
      () => emit(state.copyWith(isLoading: false)),
    );
    _deviceRepo.getDeviceSettingsInfoFor(topic);
  }

  Future<void> onReceivedData(String topic, DeviceSettings settings) async {
    if (topic == settings.topic) {
      _loadingTimer?.cancel();
      emit(state.copyWith(
        port: settings.port,
        currentLimit: settings.currentLimit,
        ledCount: settings.ledCount,
        gmt: settings.gmt,
        btnPin: settings.btnPin,
        ip: settings.ip,
        usePortal: settings.usePortal,
        useButton: settings.useButton,
        isLoading: false,
      ));
    }
  }

  void onUsePortalChanged() {
    emit(state.copyWith(usePortal: !state.usePortal));
  }

  void onUseButtonChanged() {
    emit(state.copyWith(useButton: !state.useButton));
  }

  void onSave(DeviceSettings settings) {
    _deviceRepo.updateDeviceSettings(settings);
  }

  void onReset(Device device) {
    _deviceRepo.resetDeviceSettings(device);
  }
}
