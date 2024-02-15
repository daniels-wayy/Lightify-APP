part of 'devices_watcher_bloc.dart';

@freezed
class DevicesWatcherState with _$DevicesWatcherState {
  const DevicesWatcherState._();
  const factory DevicesWatcherState.initial() = _Initial;
  const factory DevicesWatcherState.loading() = _Loading;
  const factory DevicesWatcherState.loaded(List<Device> devices) = _Loaded;
  const factory DevicesWatcherState.disconnected() = _Disconnected;

  List<Device> get devices {
    return maybeWhen(
      loaded: (devices) => devices,
      orElse: () => [],
    );
  }

  List<Device> get availableDevices {
    return maybeWhen(
      loaded: (devices) => devices.where((e) => !e.isUnreachable).toList(),
      orElse: () => [],
    );
  }

  bool get isLoaded {
    return maybeWhen(
      loaded: (_) => true,
      orElse: () => false,
    );
  }
}
