import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:lightify/core/data/model/device.dart';
import 'package:lightify/core/data/model/device_info.dart';
import 'package:lightify/core/domain/repo/device_repo.dart';
import 'package:lightify/core/ui/constants/app_constants.dart';
import 'package:lightify/core/ui/extensions/core_extensions.dart';
import 'package:lightify/core/ui/utils/function_util.dart';

@LazySingleton(as: DeviceRepo)
class DeviceRepoImpl implements DeviceRepo {
  @override
  Device? parseDevice(String data) {
    try {
      final substring = data.substring(AppConstants.api.MQTT_PACKETS_HEADER.length);
      final splitted = substring.split(',');

      debugPrint('splitted: $splitted');

      if (splitted.isEmpty) return null;

      final powerState = int.tryParse(splitted[3]) == 1;
      final brightness = int.tryParse(splitted[4]) ?? 0;

      final colorHue = int.tryParse(splitted[5]) ?? 0;
      final colorSat = int.tryParse(splitted[6]) ?? 255;
      final colorVal = int.tryParse(splitted[7]) ?? 255;
      final breathFactor = double.tryParse(splitted[8]) ?? 0.0;
      final effectId = splitted.containsAt(9) ? int.tryParse(splitted[9]) ?? 0 : 0;
      final effectSpeed = splitted.containsAt(10)
          ? int.tryParse(splitted[10]) ?? AppConstants.api.EFFECT_MIN_SPEED
          : AppConstants.api.EFFECT_MIN_SPEED;
      final effectScale = splitted.containsAt(11)
          ? int.tryParse(splitted[11]) ?? AppConstants.api.EFFECT_MIN_SCALE
          : AppConstants.api.EFFECT_MIN_SCALE;

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
        deviceInfo: DeviceInfo(
          topic: splitted[0],
          deviceName: splitted[1],
          deviceGroup: splitted[2],
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
}
