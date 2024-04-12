import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:lightify/core/data/model/device.dart';
import 'package:lightify/core/data/model/device_settings.dart';
import 'package:lightify/core/data/model/house.dart';
import 'package:lightify/core/data/model/server_response_type.dart';
import 'package:lightify/core/data/model/workflow.dart';
import 'package:lightify/core/domain/repo/device_repo.dart';
import 'package:lightify/core/domain/repo/network_repo.dart';
import 'package:lightify/core/domain/repo/parsing_repo.dart';
import 'package:lightify/core/ui/constants/app_constants.dart';
import 'package:lightify/core/ui/extensions/core_extensions.dart';
import 'package:lightify/core/ui/utils/mqtt_util.dart';

@Injectable(as: DeviceRepo)
class DeviceRepoImpl implements DeviceRepo {
  final NetworkRepo _networkRepo;
  final ParsingRepo _parsingRepo;

  const DeviceRepoImpl(this._networkRepo, this._parsingRepo);

  @override
  Stream<ServerResponseType>? get serverResponseStream {
    return _networkRepo.serverUpdates?.map((data) {
      if (data == null || data.isEmpty) return const ServerResponseType.empty();
      try {
        if (data.startsWith(AppConstants.api.MQTT_PACKETS_HEADER)) {

          final formattedData = data.replaceAll(AppConstants.api.MQTT_PACKETS_HEADER, '');

          // Device state
          if (formattedData.startsWith(AppConstants.api.MQTT_DEVICE_GET_HEADER)) {
            final device =
                _parsingRepo.parseDevice(formattedData.replaceAll(AppConstants.api.MQTT_DEVICE_GET_HEADER, ''));
            if (device != null) {
              return ServerResponseType.deviceState(device);
            }
          }

          // Device settings
          if (formattedData.startsWith(AppConstants.api.MQTT_DEVICE_GET_SETTINGS_HEADER)) {
            final settings = _parsingRepo
                .parseDeviceSettings(formattedData.replaceAll(AppConstants.api.MQTT_DEVICE_GET_SETTINGS_HEADER, ''));
            if (settings != null) {
              return ServerResponseType.deviceSettings(settings);
            }
          }

          // Device workflows
          if (formattedData.startsWith(AppConstants.api.MQTT_DEVICE_GET_WORKFLOWS_HEADER)) {
            final workflows = _parsingRepo
                .parseDeviceWorkflows(formattedData.replaceAll(AppConstants.api.MQTT_DEVICE_GET_WORKFLOWS_HEADER, ''));
            if (workflows != null) {
              return ServerResponseType.deviceWorkflows(workflows);
            }
          }

          // Device firmware update status
          if (formattedData.startsWith(AppConstants.api.MQTT_DEVICE_GET_FIRMWARE_STATUS_HEADER)) {
            final status = _parsingRepo.parseDeviceFirmwareUpdateStatus(
                formattedData.replaceAll(AppConstants.api.MQTT_DEVICE_GET_FIRMWARE_STATUS_HEADER, ''));
            if (status != null) {
              return ServerResponseType.firmwareUpdateStatus(status);
            }
          }
        }

        return ServerResponseType.unknown(data);
      } catch (e) {
        return ServerResponseType.error(e.toString());
      }
    });
  }

  @override
  Future<void> getDevices(House house) async {
    for (final topic in house.remotes) {
      _networkRepo.sendToServer(topic, MQTT_UTIL.get_cmd());
      await Future<void>.delayed(const Duration(milliseconds: 25));
    }
  }

  @override
  void getDeviceInfo(Device device) {
    _networkRepo.sendToServer(device.deviceInfo.topic, MQTT_UTIL.get_cmd());
  }

  @override
  void getDeviceSettingsInfoFor(String topic) {
    _networkRepo.sendToServer(topic, MQTT_UTIL.get_settings_cmd());
  }

  @override
  void getDeviceWorkflowsInfoFor(String topic) {
    _networkRepo.sendToServer(topic, MQTT_UTIL.get_workflows_cmd());
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

  @override
  void updateDeviceSettings(DeviceSettings settings) {
    _networkRepo.sendToServer(settings.topic, MQTT_UTIL.upd_device_settings_cmd(settings));
  }

  @override
  void addDeviceWorkflow(String topic, Workflow workflow) {
    _networkRepo.sendToServer(topic, MQTT_UTIL.add_workflow_cmd(workflow));
  }

  @override
  void updateDeviceWorkflow(String topic, Workflow workflow) {
    _networkRepo.sendToServer(topic, MQTT_UTIL.update_workflow_cmd(workflow));
  }

  @override
  void deleteDeviceWorkflow(String topic, Workflow workflow) {
    _networkRepo.sendToServer(topic, MQTT_UTIL.delete_workflow_cmd(workflow.id));
  }

  @override
  void updateFirmware(String topic, String url) {
    _networkRepo.sendToServer(topic, MQTT_UTIL.update_firmware(url));
  }
}
