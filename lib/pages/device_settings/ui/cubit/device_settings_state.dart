part of 'device_settings_cubit.dart';

@freezed
abstract class DeviceSettingsState with _$DeviceSettingsState {
  const factory DeviceSettingsState({
    @Default(false) bool isLoading,
    @Default(0) int port,
    @Default(0) int currentLimit,
    @Default(0) int ledCount,
    @Default(0) int gmt,
    @Default(0) int btnPin,
    @Default('') String ip,
    @Default(false) bool usePortal,
    @Default(false) bool useButton,
    String? isError,
  }) = _DeviceSettingsState;

  factory DeviceSettingsState.initial() => const DeviceSettingsState();
}
