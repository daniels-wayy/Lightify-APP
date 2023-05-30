import 'dart:async';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:lightify/core/data/model/device.dart';
import 'package:lightify/core/domain/repo/device_repo.dart';
import 'package:lightify/core/domain/repo/network_repo.dart';
import 'package:lightify/core/ui/bloc/connectivity/connectivity_cubit.dart';
import 'package:lightify/core/ui/bloc/devices/devices_cubit.dart';
import 'package:lightify/core/ui/constants/app_constants.dart';
import 'package:lightify/core/ui/extensions/core_extensions.dart';
import 'package:lightify/core/ui/utils/mqtt_util.dart';

import 'home_state.dart';

@injectable
class HomeCubit extends Cubit<HomeState> {
  final NetworkRepo networkRepo;
  final DeviceRepo deviceRepo;
  final DevicesCubit devicesCubit;
  final ConnectivityCubit connectivityCubit;

  // Receive data sub
  StreamSubscription? _mqttUpdates;

  // Timers
  Timer? _getTimer;
  Timer? _sendTimer;

  @override
  Future<void> close() async {
    _getTimer?.cancel();
    _mqttUpdates?.cancel();
    _sendTimer?.cancel();
    super.close();
  }

  HomeCubit({
    required this.networkRepo,
    required this.deviceRepo,
    required this.devicesCubit,
    required this.connectivityCubit,
  }) : super(HomeState.initialState());

  void _ensureConnected(Function func) {
    if (!connectivityCubit.state.connectedToNet || !networkRepo.isMQTTConnected()) return;
    func();
  }

  Future<void> init() async {
    emit(state.copyWith(connecting: true, error: null));
    try {
      await networkRepo.initializeConnection(onConnectionLost: () {
        debugPrint('MQTT disconnected!');
      });
      _mqttUpdates = networkRepo.getMQTTUpdatesStream()?.listen(_onReceived);
      _getDevicesState();
      _startGetTimer();
      emit(state.copyWith(connecting: false));
    } catch (e) {
      emit(state.copyWith(connecting: false, error: e.toString()));
    }
  }

  void _getDevicesState() => _ensureConnected(() => networkRepo.getDevicesState());

  void _startGetTimer() {
    _getTimer?.cancel();
    _getTimer = Timer.periodic(AppConstants.api.MQTT_GET_REQUEST_FREQ, (_) => _getDevicesState());
  }

  void _onReceived(String? data) {
    if (data == null) return;
    if (data.startsWith(AppConstants.api.MQTT_PACKETS_HEADER)) {
      final device = deviceRepo.parseDevice(data);
      if (device != null) {
        debugPrint('Received device: ${device.toString()}');
        _setDevices(device);
      }
    }
  }

  void _setDevices(Device device) {
    var availableDevices = [...state.availableDevices];
    if (availableDevices.any((element) => element.deviceInfo.topic == device.deviceInfo.topic)) {
      availableDevices = _getUpdatedDevices(device);
    } else {
      availableDevices.add(device);
    }
    devicesCubit.setDevices(availableDevices);
    emit(state.copyWith(availableDevices: availableDevices));
  }

  void onPowerChanged(Device device, bool state) => _sendData(
        [device],
        MQTT_UTIL.power_cmd(state.intState),
      );

  void onBrightnessChanged(Device device, int state) => _sendData(
        [device],
        MQTT_UTIL.brightness_cmd(state),
      );

  void onColorChanged(Device device, HSVColor state) => _sendData(
        [device],
        MQTT_UTIL.color_cmd(state),
      );

  void onBreathChanged(Device device, double state) => _sendData(
        [device],
        MQTT_UTIL.breath_cmd(state),
      );

  void onDeviceGroupSleepMode(List<Device> devices) => _sendData(
        devices.where((e) => e.powered).toList(),
        MQTT_UTIL.sleep_mode_cmd(),
      );

  void onDeviceGroupTurnOff(List<Device> devices) => _sendData(
        devices.where((e) => e.powered).toList(),
        MQTT_UTIL.shut_down_cmd(),
      );

  List<Device> _getUpdatedDevices(Device device) {
    var availableDevices = [...state.availableDevices];
    return availableDevices.map((e) {
      if (e.deviceInfo.topic == device.deviceInfo.topic) {
        return device;
      }
      return e;
    }).toList();
  }

  Future<void> onRefresh() async {
    _startGetTimer();
    _getDevicesState();
    await Future<void>.delayed(const Duration(seconds: 1));
  }

  void _sendData(List<Device> devices, String data) {
    _ensureConnected(() {
      _sendTimer?.cancel();
      _sendTimer = Timer(AppConstants.api.MQTT_SEND_REQUEST_THRESHOLD, () {
        _startGetTimer();
        for (final device in devices) {
          networkRepo.sendToDevice(device, data);
          networkRepo.getDeviceState(device);
        }
      });
    });
  }
}
