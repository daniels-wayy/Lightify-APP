import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:lightify/core/data/model/device.dart';
import 'package:lightify/core/data/model/firmware_update_status.dart';
import 'package:lightify/core/data/model/firmware_version.dart';
import 'package:lightify/core/data/server/request_executor/request_executor.dart';
import 'package:lightify/core/domain/failures/server_failure.dart';
import 'package:lightify/core/domain/repo/device_repo.dart';
import 'package:lightify/core/domain/repo/firmware_update_repo.dart';
import 'package:lightify/di/server_module.dart';

@Injectable(as: FirmwareUpdateRepo)
class FirmwareUpdateRepoImpl implements FirmwareUpdateRepo {
  final RequestExecutor requestExecutor;
  final String versionFilename;
  final String firmwareFilename;
  final String baseUrl;
  final DeviceRepo deviceRepo;

  const FirmwareUpdateRepoImpl({
    @OTA_UPDATE required this.requestExecutor,
    @OTA_UPDATE required this.baseUrl,
    @OTA_VERSION_FILENAME required this.versionFilename,
    @OTA_FIRMWARE_FILENAME required this.firmwareFilename,
    required this.deviceRepo,
  });

  static const deviceUpdateTimeout = Duration(minutes: 1);

  @override
  Future<Either<ServerFailure, FirmwareVersion>> getLatestVersionNum() async {
    final url = versionFilename;
    final response = await requestExecutor.get(url: url, responseType: ResponseType.plain);
    return response.fold(
      (l) => left(l),
      (r) => right(
        FirmwareVersion.fromString(r.data.toString().trim()),
      ),
    );
  }

  @override
  Future<void> updateDevice({
    required Device device,
    required void Function(Device device, FirmwareUpdateStatus updateStatus) onUpdate,
  }) async {
    final stream = deviceRepo.serverResponseStream;
    if (stream == null) {
      return onUpdate(device, const FirmwareUpdateStatus.error('Server stream is null.'));
    }

    onUpdate(device, const FirmwareUpdateStatus.waiting());

    final url = baseUrl + firmwareFilename;
    deviceRepo.updateFirmware(device.deviceInfo.topic, url);

    FirmwareUpdateStatus? status;
    final subscription = stream.listen(
      (event) => event.whenOrNull(firmwareUpdateStatus: (update) {
        if (update.topic == device.deviceInfo.topic) {
          status = update.status;
          onUpdate(device, update.status);
        }
        return null;
      }),
    );

    bool isDone = false;

    for (int i = 0; i < deviceUpdateTimeout.inSeconds; i++) {
      debugPrint('Wait for update - second: ${i + 1}');
      if (status != null) {
        if (status!.isFinished || status!.isError) {
          isDone = true;
          break;
        }
      }
      await Future<void>.delayed(const Duration(seconds: 1));
    }

    subscription.cancel();

    if (!isDone) {
      onUpdate(
        device,
        const FirmwareUpdateStatus.error(
          'Response timed out. The update might have installed. Please restart the app.',
        ),
      );
    }
  }
}
