import 'package:flutter/widgets.dart';
import 'package:lightify/core/data/model/device.dart';
import 'package:lightify/core/data/model/device_settings.dart';
import 'package:lightify/core/data/model/house.dart';
import 'package:lightify/core/data/model/server_response_type.dart';
import 'package:lightify/core/data/model/workflow.dart';

abstract class DeviceRepo {
  Stream<ServerResponseType>? get serverResponseStream;

  Future<void> getDevices(House house);
  void getDeviceInfo(Device device);
  void getDeviceSettingsInfoFor(String topic);
  void getDeviceWorkflowsInfoFor(String topic);

  void changePower(Device device, bool state);
  void changeBrightness(Device device, int state);
  void changeColor(Device device, HSVColor state);
  void changeBreath(Device device, double state);
  void changeEffect(Device device, int state);
  void changeEffectSpeed(Device device, int state);
  void changeEffectScale(Device device, int state);
  void sleepDevice(Device device);

  void updateDeviceSettings(DeviceSettings settings);
  void addDeviceWorkflow(String topic, Workflow workflow);
  void updateDeviceWorkflow(String topic, Workflow workflow);
  void deleteDeviceWorkflow(String topic, Workflow workflow);

  void updateFirmware(String topic, String url);
}
