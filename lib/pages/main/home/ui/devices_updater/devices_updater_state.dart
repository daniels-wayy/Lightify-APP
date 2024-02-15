part of 'devices_updater_bloc.dart';

@freezed
class DevicesUpdaterState with _$DevicesUpdaterState {
  const DevicesUpdaterState._();
  const factory DevicesUpdaterState.initial() = _Initial;
  const factory DevicesUpdaterState.disconnected() = _Disconnected;

  bool get isDisconnected {
    return maybeWhen(
      disconnected: () => true,
      orElse: () => false,
    );
  }
}
