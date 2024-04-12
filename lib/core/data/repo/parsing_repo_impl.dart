import 'package:flutter/rendering.dart';
import 'package:injectable/injectable.dart';
import 'package:lightify/core/data/model/device.dart';
import 'package:lightify/core/data/model/device_firmware_update.dart';
import 'package:lightify/core/data/model/device_info.dart';
import 'package:lightify/core/data/model/device_settings.dart';
import 'package:lightify/core/data/model/firmware_update_status.dart';
import 'package:lightify/core/data/model/firmware_version.dart';
import 'package:lightify/core/data/model/workflow.dart';
import 'package:lightify/core/data/model/workflow_response.dart';
import 'package:lightify/core/domain/repo/parsing_repo.dart';
import 'package:lightify/core/ui/constants/app_constants.dart';
import 'package:lightify/core/ui/extensions/core_extensions.dart';
import 'package:lightify/core/ui/utils/function_util.dart';

@Injectable(as: ParsingRepo)
class ParsingRepoImpl implements ParsingRepo {
  const ParsingRepoImpl();

  @override
  Device? parseDevice(String data) {
    try {
      final splitted = data.split(',');
      if (splitted.isEmpty) return null;

      final powerState = int.tryParse(splitted[1]) == 1;
      final brightness = int.tryParse(splitted[2]) ?? 0;

      final colorHue = int.tryParse(splitted[3]) ?? 0;
      final colorSat = int.tryParse(splitted[4]) ?? 255;
      final colorVal = int.tryParse(splitted[5]) ?? 255;
      final breathFactor = /*double.tryParse(splitted[8]) ?? 0.0*/ 0.0;
      final effectId = splitted.containsAt(6) ? int.tryParse(splitted[6]) ?? 0 : 0;
      final effectSpeed = splitted.containsAt(7)
          ? int.tryParse(splitted[7]) ?? AppConstants.api.EFFECT_MIN_SPEED
          : AppConstants.api.EFFECT_MIN_SPEED;
      final effectScale = splitted.containsAt(8)
          ? int.tryParse(splitted[8]) ?? AppConstants.api.EFFECT_MIN_SCALE
          : AppConstants.api.EFFECT_MIN_SCALE;
      final firmwareVersionString = splitted.containsAt(9) ? splitted[9] : '';

      final hsv = HSVColor.fromAHSV(
        1.0,
        FunctionUtil.mapHueTo360(colorHue),
        colorSat / 255,
        colorVal / 255,
      );

      return Device(
        powered: powerState,
        brightness: brightness,
        color: hsv,
        breathFactor: breathFactor,
        deviceInfo: DeviceInfo.fromTopic(splitted[0]).copyWith(
          firmwareVersion: FirmwareVersion.fromString(firmwareVersionString),
        ),
        effectId: effectId,
        effectSpeed: effectSpeed,
        effectScale: effectScale,
      );
    } catch (e) {
      debugPrint('parseDevice error: $e');
      return null;
    }
  }

  @override
  DeviceSettings? parseDeviceSettings(String data) {
    try {
      final splitted = data.split(',');
      if (splitted.isEmpty) return null;

      final topic = splitted[0];
      final port = int.tryParse(splitted[1]) ?? 0;
      final currentLimit = int.tryParse(splitted[2]) ?? 0;
      final ledCount = int.tryParse(splitted[3]) ?? 0;
      final gmt = int.tryParse(splitted[4]) ?? 0;

      final ip1 = int.tryParse(splitted[5]) ?? 0;
      final ip2 = int.tryParse(splitted[6]) ?? 0;
      final ip3 = int.tryParse(splitted[7]) ?? 0;
      final ip4 = int.tryParse(splitted[8]) ?? 0;
      final ip = '$ip1.$ip2.$ip3.$ip4';

      return DeviceSettings(
        topic: topic,
        port: port,
        currentLimit: currentLimit,
        ledCount: ledCount,
        gmt: gmt,
        ip: ip,
      );
    } catch (e) {
      debugPrint('parseDeviceSettings error: $e');
      return null;
    }
  }

  @override
  WorkflowResponse? parseDeviceWorkflows(String data) {
    final split = data.split('/');
    if (split.isEmpty) return null;

    try {
      final topic = split[0];

      // no workflows set
      if (split.length == 1) {
        return WorkflowResponse(topic: topic, items: []);
      }

      final items = <Workflow>[];

      final workflows = split[1].split(';');

      for (final workflowItem in workflows) {
        final workflow = workflowItem.split(',');
        try {
          final id = int.tryParse(workflow[0]);
          if (id == null) {
            continue;
          }
          final isEnabled = (int.parse(workflow[1])).boolState;
          final isPowerOn = (int.parse(workflow[2])).boolState;
          final day = int.parse(workflow[3]);
          final hour = int.parse(workflow[4]);
          final minute = int.parse(workflow[5]);
          final duration = int.parse(workflow[6]);
          final brightness = int.parse(workflow[7]);

          items.add(Workflow(
            id: id,
            isEnabled: isEnabled,
            isPowerOn: isPowerOn,
            day: day,
            hour: hour,
            minute: minute,
            duration: Duration(minutes: duration),
            brightness: brightness,
          ));
        } catch (e) {
          debugPrint('workflowParser error: $e');
          continue;
        }
      }

      return WorkflowResponse(topic: topic, items: items);
    } catch (e) {
      debugPrint('parseDeviceWorkflows error: $e');
      return null;
    }
  }

  @override
  DeviceFirmwareUpdate? parseDeviceFirmwareUpdateStatus(String data) {
    try {
      final splitted = data.split(',');
      if (splitted.isEmpty) return null;

      final topic = splitted[0];
      final statusKey = splitted[1];

      if (statusKey == AppConstants.api.UPD_STARTED_KEY) {
        return DeviceFirmwareUpdate(topic: topic, status: const FirmwareUpdateStatus.started());
      }

      if (statusKey == AppConstants.api.UPD_PROGRESS_KEY) {
        final progress = int.parse(splitted[2]);
        return DeviceFirmwareUpdate(topic: topic, status: FirmwareUpdateStatus.progress(progress));
      }

      if (statusKey == AppConstants.api.UPD_FINISHED_KEY) {
        return DeviceFirmwareUpdate(topic: topic, status: const FirmwareUpdateStatus.finished());
      }

      if (statusKey == AppConstants.api.UPD_ERROR_KEY) {
        final errorMsg = splitted[2];
        return DeviceFirmwareUpdate(topic: topic, status: FirmwareUpdateStatus.error(errorMsg));
      }

      return null;
    } catch (e) {
      debugPrint('parseDeviceFirmwareUpdateStatus error: $e');
      return null;
    }
  }
}
