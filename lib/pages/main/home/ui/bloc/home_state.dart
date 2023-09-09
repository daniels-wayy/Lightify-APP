import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lightify/core/data/model/device.dart';

part 'home_state.freezed.dart';

@freezed
class HomeState with _$HomeState {
  const HomeState._();
  const factory HomeState.initial() = _Initial;
  const factory HomeState.connecting() = _Connecting;
  const factory HomeState.connected({required List<Device> availableDevices}) = _Connected;
  const factory HomeState.disconnected() = _Disconnected;

  List<Device> get availableDevices => maybeMap(
        connected: (state) => state.availableDevices,
        orElse: () => [],
      );
}
