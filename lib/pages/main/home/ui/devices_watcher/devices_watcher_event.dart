part of 'devices_watcher_bloc.dart';

@freezed
abstract class DevicesWatcherEvent with _$DevicesWatcherEvent {
  const factory DevicesWatcherEvent.initialize(House house) = _Initialize;
  const factory DevicesWatcherEvent.fetchDevices(House house) = _FetchDevices;
  const factory DevicesWatcherEvent.listenDevices(House house) = _ListenDevices;
  const factory DevicesWatcherEvent.deviceUpdateReceived(Device device, House house) = _DeviceUpdateReceived;
  const factory DevicesWatcherEvent.overrideConnectivityCallbacks(House house) = _OverrideConnectivityCallbacks;
  const factory DevicesWatcherEvent.refresh(House house) = _Refresh;
  const factory DevicesWatcherEvent.disconnect() = _Disconnect;
  const factory DevicesWatcherEvent.checkConnectionState() = _CheckConnectionState;
}