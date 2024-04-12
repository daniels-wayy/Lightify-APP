import 'package:dartz/dartz.dart';
import 'package:lightify/core/data/model/device.dart';
import 'package:lightify/core/data/model/firmware_update_status.dart';
import 'package:lightify/core/data/model/firmware_version.dart';
import 'package:lightify/core/domain/failures/server_failure.dart';

abstract class FirmwareUpdateRepo {
  Future<Either<ServerFailure, FirmwareVersion>> getLatestVersionNum();
  Future<void> updateDevice({
    required Device device,
    required void Function(Device device, FirmwareUpdateStatus updateStatus) onUpdate,
  });
}
