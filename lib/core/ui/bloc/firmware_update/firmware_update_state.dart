part of 'firmware_update_cubit.dart';

@freezed
class FirmwareUpdateState with _$FirmwareUpdateState {
  const FirmwareUpdateState._();
  const factory FirmwareUpdateState({
    @Default(false) bool isChecked,
    @Default(false) bool isGettingLatestAvailableVersion,
    @Default(FirmwareVersion.unknown()) FirmwareVersion latestAvailableVersion,
    @Default(<Device>[]) List<Device> devicesNeedsAnUpdate,
    @Default(<String, FirmwareUpdateStatus>{}) Map<String, FirmwareUpdateStatus> updateStatuses,
    String? errorMessage,
  }) = _FirmwareUpdateState;

  factory FirmwareUpdateState.initial() => const FirmwareUpdateState();

  bool get hasUpdates => devicesNeedsAnUpdate.isNotEmpty;

  bool get isAllDevicesWereUpdated {
    return devicesNeedsAnUpdate.every((e) {
      final status = updateStatuses[e.deviceInfo.topic];
      return status != null && status.isFinished;
    });
  }

  List<Device> get onlyNotUpdatedDevices => devicesNeedsAnUpdate.where((e) {
        final status = updateStatuses[e.deviceInfo.topic];
        return status == null || status.isError;
      }).toList();
}
