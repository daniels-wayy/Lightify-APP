import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:lightify/core/data/model/device.dart';
import 'package:lightify/core/data/model/device_info.dart';
import 'package:lightify/core/data/model/house.dart';
import 'package:lightify/core/domain/repo/device_repo.dart';
import 'package:lightify/core/domain/repo/network_repo.dart';
import 'package:lightify/core/ui/constants/app_constants.dart';
import 'package:lightify/core/ui/extensions/core_extensions.dart';
import 'package:lightify/core/ui/utils/function_util.dart';
import 'package:lightify/core/ui/utils/mqtt_util.dart';

@LazySingleton(as: DeviceRepo)
class DeviceRepoImpl implements DeviceRepo {
  final NetworkRepo _networkRepo;

  const DeviceRepoImpl(this._networkRepo);

  @override
  Stream<Device?>? get devicesStream {
    return _networkRepo.serverUpdates?.map((data) {
      if (data == null || data.isEmpty) return null;
      try {
        if (data.startsWith(AppConstants.api.MQTT_PACKETS_HEADER)) {
          final device = DeviceRepoImpl.parseDevice(data);
          if (device != null) {
            return device;
          }
        }
        return null;
      } catch (_) {
        return null;
      }
    });
  }

  @override
  Future<void> getDevices(House house) async {
    for (final topic in house.remotes) {
      _networkRepo.sendToServer(topic, MQTT_UTIL.get_cmd());
      await Future<void>.delayed(const Duration(milliseconds: 50));
    }
  }

  @override
  void getDeviceInfo(Device device) {
    _networkRepo.sendToServer(device.deviceInfo.topic, MQTT_UTIL.get_cmd());
  }

  @override
  void changePower(Device device, bool state) {
    _networkRepo.sendToServer(device.deviceInfo.topic, MQTT_UTIL.power_cmd(state.intState));
  }

  @override
  void changeBrightness(Device device, int state) {
    _networkRepo.sendToServer(device.deviceInfo.topic, MQTT_UTIL.brightness_cmd(state));
  }

  @override
  void changeColor(Device device, HSVColor state) {
    _networkRepo.sendToServer(device.deviceInfo.topic, MQTT_UTIL.color_cmd(state));
  }

  @override
  void changeBreath(Device device, double state) {
    _networkRepo.sendToServer(device.deviceInfo.topic, MQTT_UTIL.breath_cmd(state));
  }

  @override
  void changeEffect(Device device, int state) {
    _networkRepo.sendToServer(device.deviceInfo.topic, MQTT_UTIL.effect_cmd(state));
  }

  @override
  void changeEffectSpeed(Device device, int state) {
    _networkRepo.sendToServer(device.deviceInfo.topic, MQTT_UTIL.effect_speed_cmd(state));
  }

  @override
  void changeEffectScale(Device device, int state) {
    _networkRepo.sendToServer(device.deviceInfo.topic, MQTT_UTIL.effect_scale_cmd(state));
  }

  @override
  void sleepDevice(Device device) {
    _networkRepo.sendToServer(device.deviceInfo.topic, MQTT_UTIL.sleep_mode_cmd());
  }

  static Device? parseDevice(String data) {
    try {
      final substring = data.substring(AppConstants.api.MQTT_PACKETS_HEADER.length);
      final splitted = substring.split(',');
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
      return null;
    }
  }
}
