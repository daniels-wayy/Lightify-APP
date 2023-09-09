import 'dart:async';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:lightify/core/data/model/device.dart';
import 'package:lightify/core/data/model/house.dart';
import 'package:lightify/core/domain/repo/device_repo.dart';
import 'package:lightify/core/domain/repo/network_repo.dart';
import 'package:lightify/core/ui/bloc/connectivity/connectivity_cubit.dart';
import 'package:lightify/core/ui/bloc/devices/devices_cubit.dart';
import 'package:lightify/core/ui/constants/app_constants.dart';
import 'package:lightify/core/ui/extensions/core_extensions.dart';
import 'package:lightify/core/ui/utils/mqtt_util.dart';

import 'home_event.dart';
import 'home_state.dart';

@injectable
class HomeBloc extends Bloc<HomeEvent, HomeState> {
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
    _clearTickers();
    super.close();
  }

  void _clearTickers() {
    _getTimer?.cancel();
    _mqttUpdates?.cancel();
    _sendTimer?.cancel();
  }

  HomeBloc({
    required this.networkRepo,
    required this.deviceRepo,
    required this.devicesCubit,
    required this.connectivityCubit,
  }) : super(const HomeState.initial());

  void _ensureConnected(Function func) {
    if (connectivityCubit.state.connectedToNet && networkRepo.isMQTTConnected()) {
      func();
    }
  }

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    yield* event.when(
      initConnection: _processInitConnection,
      onPowerChanged: _processOnPowerChanged,
      onBrightnessChanged: _processOnBrightnessChanged,
      onColorChanged: _processOnColorChanged,
      onBreathChanged: _processOnBreathChanged,
      onEffectChanged: _processOnEffectChanged,
      onEffectSpeedChanged: _processOnEffectSpeedChanged,
      onEffectScaleChanged: _processOnEffectScaleChanged,
      onDeviceGroupSleepMode: _processOnDeviceGroupSleepMode,
      onDeviceGroupTurnOff: _processOnDeviceGroupTurnOff,
      onRefresh: _processOnRefresh,
      onReceivedMessage: _processOnReceivedMessage,
      onMQTTConnected: _processOnMQTTConnected,
      onMQTTDisconnected: _processOnMQTTDisconnected,
    );
  }

  Stream<HomeState> _processInitConnection(House house, bool connect) async* {
    debugPrint('_processInitConnection - connect: $connect');
    yield const HomeState.connecting();
    if (connect) {
      await networkRepo.initializeConnection(
        onConnected: () => add(HomeEvent.onMQTTConnected(house)),
        onDisconnected: () => add(const HomeEvent.onMQTTDisconnected()),
      );
    } else {
      networkRepo.overrideConnectivityCallbacks(
        onConnected: () => add(HomeEvent.onMQTTConnected(house)),
        onDisconnected: () => add(const HomeEvent.onMQTTDisconnected()),
      );
      add(HomeEvent.onMQTTConnected(house));
    }
  }

  Stream<HomeState> _processOnMQTTConnected(House house) async* {
    _mqttUpdates?.cancel();
    _mqttUpdates = networkRepo.getMQTTUpdatesStream()?.listen(
          (data) => add(HomeEvent.onReceivedMessage(data)),
        );
    _getDevicesState(house);
    _startGetTimer(house);
    yield const HomeState.connected(availableDevices: []);
  }

  Stream<HomeState> _processOnMQTTDisconnected() async* {
    _clearTickers();
    yield const HomeState.disconnected();
  }

  Stream<HomeState> _processOnPowerChanged(Device device, bool state) async* {
    _sendData([device], MQTT_UTIL.power_cmd(state.intState));
  }

  Stream<HomeState> _processOnBrightnessChanged(Device device, int state) async* {
    _sendData([device], MQTT_UTIL.brightness_cmd(state));
  }

  Stream<HomeState> _processOnColorChanged(Device device, HSVColor state) async* {
    _sendData([device], MQTT_UTIL.color_cmd(state));
  }

  Stream<HomeState> _processOnBreathChanged(Device device, double state) async* {
    _sendData([device], MQTT_UTIL.breath_cmd(state));
  }

  Stream<HomeState> _processOnEffectChanged(Device device, int state) async* {
    _sendData([device], MQTT_UTIL.effect_cmd(state));
  }

  Stream<HomeState> _processOnEffectSpeedChanged(Device device, double state) async* {
    _sendData([device], MQTT_UTIL.effect_speed_cmd(state.toInt()));
  }

  Stream<HomeState> _processOnEffectScaleChanged(Device device, double state) async* {
    _sendData([device], MQTT_UTIL.effect_scale_cmd(state.toInt()));
  }

  Stream<HomeState> _processOnDeviceGroupSleepMode(List<Device> devices) async* {
    _sendData(devices.where((e) => e.powered).toList(), MQTT_UTIL.sleep_mode_cmd());
  }

  Stream<HomeState> _processOnDeviceGroupTurnOff(List<Device> devices) async* {
    if (devices.every((device) => !device.powered)) {
      _sendData(devices, MQTT_UTIL.power_cmd(1));
    } else {
      _sendData(devices.where((e) => e.powered).toList(), MQTT_UTIL.shut_down_cmd());
    }
  }

  Stream<HomeState> _processOnRefresh(House house) async* {
    _startGetTimer(house);
    _getDevicesState(house);
  }

  Stream<HomeState> _processOnReceivedMessage(String? data) async* {
    if (data == null) return;
    if (data.startsWith(AppConstants.api.MQTT_PACKETS_HEADER)) {
      final device = deviceRepo.parseDevice(data);
      if (device != null) {
        debugPrint('Received device: ${device.toString()}');
        var availableDevices = [...state.availableDevices];
        if (availableDevices.any((element) => element.deviceInfo.topic == device.deviceInfo.topic)) {
          availableDevices = _getUpdatedDevices(device);
        } else {
          availableDevices.add(device);
        }
        devicesCubit.setDevices(availableDevices);
        yield HomeState.connected(availableDevices: availableDevices);
        // yield state.copyWith(availableDevices: availableDevices);
      }
    }
  }

  List<Device> _getUpdatedDevices(Device device) {
    var availableDevices = [...state.availableDevices];
    return availableDevices.map((e) {
      if (e.deviceInfo.topic == device.deviceInfo.topic) {
        return device;
      }
      return e;
    }).toList();
  }

  void _sendData(List<Device> devices, String data) {
    _ensureConnected(() {
      _sendTimer?.cancel();
      _sendTimer = Timer(AppConstants.api.MQTT_SEND_REQUEST_THRESHOLD, () async {
        for (final device in devices) {
          debugPrint('sendToDevice: ${device.deviceInfo.topic} - $data');
          networkRepo.sendToDevice(device.deviceInfo.topic, data);
          await Future<void>.delayed(AppConstants.api.MQTT_SEND_REQUEST_THRESHOLD);
          networkRepo.getDeviceState(device.deviceInfo.topic);
        }
      });
    });
  }

  void _getDevicesState(House house) => _ensureConnected(() => networkRepo.getDevicesState(house.remotes));

  void _startGetTimer(House house) {
    _getTimer?.cancel();
    _getTimer = Timer.periodic(AppConstants.api.MQTT_GET_REQUEST_FREQ, (_) => _getDevicesState(house));
  }
}
