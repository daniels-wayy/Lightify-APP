import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:lightify/core/data/model/device.dart';
import 'package:lightify/core/domain/repo/device_repo.dart';
import 'package:lightify/core/domain/repo/network_repo.dart';
import 'package:lightify/core/ui/bloc/connectivity/connectivity_cubit.dart';
import 'package:lightify/core/ui/constants/app_constants.dart';

part 'devices_updater_event.dart';
part 'devices_updater_state.dart';
part 'devices_updater_bloc.freezed.dart';

@Injectable()
class DevicesUpdaterBloc extends Bloc<DevicesUpdaterEvent, DevicesUpdaterState> {
  final DeviceRepo _deviceRepo;
  final NetworkRepo _networkRepo;
  final ConnectivityCubit _connectivityCubit;

  DevicesUpdaterBloc(
    this._deviceRepo,
    this._networkRepo,
    this._connectivityCubit,
  ) : super(const DevicesUpdaterState.initial());

  Timer? _sendTimer;

  void _ensureConnected(Function func) {
    if (_connectivityCubit.state.connectedToNet && _networkRepo.isConnectedToServer()) {
      func();
      add(const DevicesUpdaterEvent.resume());
    } else {
      add(const DevicesUpdaterEvent.disconnect());
    }
  }

  @override
  Future<void> close() {
    _sendTimer?.cancel();
    return super.close();
  }

  @override
  Stream<DevicesUpdaterState> mapEventToState(DevicesUpdaterEvent event) async* {
    yield* event.when(
      changePower: _changePower,
      changeBrightness: _changeBrightness,
      changeColor: _changeColor,
      changeBreath: _changeBreath,
      changeEffect: _changeEffect,
      changeEffectSpeed: _changeEffectSpeed,
      changeEffectScale: _changeEffectScale,
      sleepDeviceGroup: _sleepDeviceGroup,
      turnOffDeviceGroup: _turnOffDeviceGroup,
      disconnect: _disconnect,
      resume: _resume,
    );
  }

  Stream<DevicesUpdaterState> _changePower(Device device, bool state) async* {
    _send([device], (p0) => _deviceRepo.changePower(p0, state));
  }

  Stream<DevicesUpdaterState> _changeBrightness(Device device, int state) async* {
    _send([device], (p0) => _deviceRepo.changeBrightness(p0, state));
  }

  Stream<DevicesUpdaterState> _changeColor(Device device, HSVColor state) async* {
    _send([device], (p0) => _deviceRepo.changeColor(p0, state));
  }

  Stream<DevicesUpdaterState> _changeBreath(Device device, double state) async* {
    _send([device], (p0) => _deviceRepo.changeBreath(p0, state));
  }

  Stream<DevicesUpdaterState> _changeEffect(Device device, int state) async* {
    _send([device], (p0) => _deviceRepo.changeEffect(p0, state));
  }

  Stream<DevicesUpdaterState> _changeEffectSpeed(Device device, int state) async* {
    _send([device], (p0) => _deviceRepo.changeEffectSpeed(p0, state));
  }

  Stream<DevicesUpdaterState> _changeEffectScale(Device device, int state) async* {
    _send([device], (p0) => _deviceRepo.changeEffectScale(p0, state));
  }

  Stream<DevicesUpdaterState> _sleepDeviceGroup(List<Device> devices) async* {
    _send(devices.where((e) => e.powered).toList(), (p0) => _deviceRepo.sleepDevice(p0));
  }

  Stream<DevicesUpdaterState> _turnOffDeviceGroup(List<Device> devices) async* {
    if (devices.every((device) => !device.powered)) {
      _send(devices, (p0) => _deviceRepo.changePower(p0, true));
    } else {
      _send(devices.where((e) => e.powered).toList(), (p0) => _deviceRepo.changePower(p0, false));
    }
  }

  Stream<DevicesUpdaterState> _disconnect() async* {
    yield const DevicesUpdaterState.disconnected();
  }

  Stream<DevicesUpdaterState> _resume() async* {
    yield const DevicesUpdaterState.initial();
  }

  void _send(List<Device> devices, void Function(Device) sendDataFunction) {
    _ensureConnected(() {
      _sendTimer?.cancel();
      _sendTimer = Timer(AppConstants.api.MQTT_SEND_REQUEST_THRESHOLD, () async {
        try {
          for (final device in devices) {
            sendDataFunction(device);
            await Future<void>.delayed(AppConstants.api.MQTT_SEND_REQUEST_THRESHOLD);
            _deviceRepo.getDeviceInfo(device);
          }
        } catch (e) {
          debugPrint('DevicesUpdatedBloc send error occured: $e');
          add(const DevicesUpdaterEvent.disconnect());
        }
      });
    });
  }
}
