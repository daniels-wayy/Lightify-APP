import 'package:flutter/widgets.dart';
import 'package:lightify/core/data/model/device.dart';
import 'package:lightify/core/data/model/house.dart';

abstract class DeviceRepo {
  Stream<Device?>? get devicesStream;

  Future<void> getDevices(House house);
  void getDeviceInfo(Device device);

  void changePower(Device device, bool state);
  void changeBrightness(Device device, int state);
  void changeColor(Device device, HSVColor state);
  void changeBreath(Device device, double state);
  void changeEffect(Device device, int state);
  void changeEffectSpeed(Device device, int state);
  void changeEffectScale(Device device, int state);
  void sleepDevice(Device device);
}
