import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lightify/core/data/model/device.dart';
import 'package:lightify/core/ui/extensions/core_extensions.dart';

part 'home_state.freezed.dart';

@freezed
class HomeState with _$HomeState {
  const HomeState._();
  const factory HomeState({
    @Default(false) bool connecting,
    required List<Device> availableDevices,
    String? error,
  }) = _HomeState;

  factory HomeState.initialState() => const HomeState(
        availableDevices: [],
      );

  Map<String, List<Device>> get groupedDevices {
    return availableDevices.groupBy((p0) => p0.deviceInfo.deviceGroup);
  }
}
