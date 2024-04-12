import 'package:freezed_annotation/freezed_annotation.dart';

part 'firmware_update_status.freezed.dart';

@freezed
abstract class FirmwareUpdateStatus with _$FirmwareUpdateStatus {
  const FirmwareUpdateStatus._();
  const factory FirmwareUpdateStatus.waiting() = _Waiting;
  const factory FirmwareUpdateStatus.started() = _Started;
  const factory FirmwareUpdateStatus.progress(int percent) = _Progress;
  const factory FirmwareUpdateStatus.finished() = _Finished;
  const factory FirmwareUpdateStatus.error(String message) = _Error;

  bool get isFinished => maybeWhen(
        finished: () => true,
        orElse: () => false,
      );

  bool get isError => maybeWhen(
        error: (_) => true,
        orElse: () => false,
      );
}
