import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:lightify/config.dart';
import 'package:lightify/core/data/model/device.dart';
import 'package:lightify/core/data/model/house.dart';
import 'package:lightify/core/domain/repo/device_repo.dart';
import 'package:lightify/core/domain/repo/network_repo.dart';
import 'package:lightify/core/ui/bloc/connectivity/connectivity_cubit.dart';
import 'package:lightify/core/ui/bloc/devices/devices_cubit.dart';
import 'package:lightify/core/ui/constants/app_constants.dart';

part 'devices_watcher_event.dart';
part 'devices_watcher_state.dart';
part 'devices_watcher_bloc.freezed.dart';

@Injectable()
class DevicesWatcherBloc extends Bloc<DevicesWatcherEvent, DevicesWatcherState> {
  final NetworkRepo _networkRepo;
  final DeviceRepo _deviceRepo;
  final ConnectivityCubit _connectivityCubit;
  final DevicesCubit _devicesCubit;

  DevicesWatcherBloc(
    this._networkRepo,
    this._deviceRepo,
    this._connectivityCubit,
    this._devicesCubit,
  ) : super(const DevicesWatcherState.initial());

  static const initialDevicesCheckTimeout = Duration(milliseconds: 275);
  static const devicesCheckTimeout = Duration(milliseconds: 75);
  static const devicesCheckRetries = 2;

  StreamSubscription? _serverUpdatesStream;
  Timer? _getTimer;

  void _clearTickers() {
    _getTimer?.cancel();
    _serverUpdatesStream?.cancel();
  }

  void _ensureConnected(Function func) {
    if (_connectivityCubit.state.connectedToNet && _networkRepo.isConnectedToServer()) {
      func();
    } else {
      add(const DevicesWatcherEvent.disconnect());
    }
  }

  void _startGetTimer(House house) {
    _getTimer?.cancel();
    _getTimer = Timer.periodic(AppConstants.api.MQTT_GET_REQUEST_FREQ, (_) => _getDevicesState(house));
  }

  void _getDevicesState(House house) => _ensureConnected(() => _deviceRepo.getDevices(house));

  @override
  Future<void> close() {
    _clearTickers();
    return super.close();
  }

  @override
  Stream<DevicesWatcherState> mapEventToState(DevicesWatcherEvent event) async* {
    yield* event.when(
      initialize: _initialize,
      fetchDevices: _fetchDevices,
      listenDevices: _listenDevices,
      disconnect: _disconnect,
      deviceUpdateReceived: _deviceUpdateReceived,
      overrideConnectivityCallbacks: _overrideConnectivityCallbacks,
      refresh: _processOnRefresh,
      checkConnectionState: _checkConnectionState,
    );
  }

  Stream<DevicesWatcherState> _initialize(House house) async* {
    yield const DevicesWatcherState.loading();

    await _networkRepo.establishConnection(
      onConnected: () => add(DevicesWatcherEvent.fetchDevices(house)),
      onDisconnected: () => add(const DevicesWatcherEvent.disconnect()),
    );
  }

  Stream<DevicesWatcherState> _fetchDevices(House house) async* {
    // cancel previous streams
    _serverUpdatesStream?.cancel();

    // recreate the stream
    final stream = _deviceRepo.serverResponseStream;

    // if no connection to server -> disconnect
    if (stream == null) {
      add(const DevicesWatcherEvent.disconnect());
    }

    var allDevicesLoaded = false;
    final devices = <Device>[];
    final expectedDevicesBuffer = List.from(house.remotes);

    _serverUpdatesStream = stream!.listen((response) {
      response.whenOrNull(deviceState: (device) {
        // if received expected device
        if (expectedDevicesBuffer.any((remote) => device.deviceInfo.topic == remote)) {
          // add device
          devices.add(device);

          // got expected device -> remove from buffer
          expectedDevicesBuffer.removeWhere((remote) => device.deviceInfo.topic == remote);

          // if buffer is cleared -> all devices were received
          if (expectedDevicesBuffer.isEmpty) {
            allDevicesLoaded = true;
          }
        }
      });
    });

    // get devices
    _startGetTimer(house);
    _getDevicesState(house);

    // wait some time for devices establish
    await Future<void>.delayed(initialDevicesCheckTimeout);

    // loop with delays to wait for all devices to load
    for (var i = 0; i < devicesCheckRetries; i++) {
      debugPrint('Check ${house.name} Devices #$i: ${devices.length}/${house.remotes.length} were received');
      // check if all devices were received
      if (allDevicesLoaded) {
        break;
      }
      await Future.delayed(devicesCheckTimeout);
    }

    // check unavailable devices remotes
    final unreachableDevices = _checkUnreachableDevices(house, devices);

    // add unavailable devices to the list
    devices.addAll(unreachableDevices);

    // loaded
    yield DevicesWatcherState.loaded(devices);

    // start listening devices
    add(DevicesWatcherEvent.listenDevices(house));
  }

  Stream<DevicesWatcherState> _listenDevices(House house) async* {
    // cancel devices fetch stream
    _serverUpdatesStream!.cancel();

    // recreate the stream
    final stream = _deviceRepo.serverResponseStream;

    // if no connection to server -> disconnect
    if (stream == null) {
      add(const DevicesWatcherEvent.disconnect());
    }

    _serverUpdatesStream = stream!.listen((response) {
      response.whenOrNull(
        deviceState: (device) => add(DevicesWatcherEvent.deviceUpdateReceived(device, house)),
        deviceSettings: _devicesCubit.setDeviceSettings,
        deviceWorkflows: _devicesCubit.setDeviceWorkflows,
      );
    });
  }

  Stream<DevicesWatcherState> _deviceUpdateReceived(Device device, House house) async* {
    // current loaded devices
    var currentDevices = [...state.devices];

    // if new device received
    if (!currentDevices.any((e) => e.deviceInfo.topic == device.deviceInfo.topic)) {
      // add to list
      currentDevices.add(device);
    }
    // if device has been already received
    else {
      // update list
      currentDevices = currentDevices.map((e) {
        if (e.deviceInfo.topic == device.deviceInfo.topic) {
          return device;
        }
        return e;
      }).toList();
    }

    _devicesCubit.setDevices(_retrieveOnlyAvailableDevices(house, currentDevices).toList());

    final unreachableDevices = _checkUnreachableDevices(house, currentDevices);
    if (unreachableDevices.isNotEmpty) {
      currentDevices.addAll(unreachableDevices);
    }

    yield DevicesWatcherState.loaded(currentDevices);
  }

  Stream<DevicesWatcherState> _overrideConnectivityCallbacks(House house) async* {
    _networkRepo.overrideConnectivityCallbacks(
      onConnected: () => add(DevicesWatcherEvent.fetchDevices(house)),
      onDisconnected: () => add(const DevicesWatcherEvent.disconnect()),
    );
    add(DevicesWatcherEvent.fetchDevices(house));
  }

  Stream<DevicesWatcherState> _processOnRefresh(House house) async* {
    _startGetTimer(house);
    _getDevicesState(house);
  }

  Stream<DevicesWatcherState> _disconnect() async* {
    yield const DevicesWatcherState.disconnected();
  }

  Stream<DevicesWatcherState> _checkConnectionState() async* {
    if (state == const DevicesWatcherState.disconnected()) {
      add(DevicesWatcherEvent.initialize(Config.primaryHouse));
    }
  }

  Iterable<Device> _checkUnreachableDevices(House house, List<Device> fetchedDevices) {
    final unreachableRemotes =
        house.remotes.where((remote) => !(fetchedDevices.any((device) => device.deviceInfo.topic == remote)));

    // map to device
    final unreachableDevices = unreachableRemotes.map((remote) => Device.unreachable(remote));
    return unreachableDevices;
  }

  Iterable<Device> _retrieveOnlyAvailableDevices(House house, List<Device> fetchedDevices) {
    return fetchedDevices.where((e) => !e.isUnreachable && house.remotes.any((x) => e.deviceInfo.topic == x));
  }
}
