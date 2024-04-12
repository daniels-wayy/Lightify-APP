// ignore_for_file: camel_case_types, non_constant_identifier_names
import 'package:flutter/rendering.dart';
import 'package:lightify/core/data/model/device_settings.dart';
import 'package:lightify/core/data/model/workflow.dart';
import 'package:lightify/core/ui/constants/app_constants.dart';
import 'package:lightify/core/ui/utils/function_util.dart';

class MQTT_UTIL {
  static String get_cmd() => AppConstants.api.MQTT_GET_KEY;
  static String get_settings_cmd() => AppConstants.api.MQTT_GET_SETTINGS_KEY;
  static String get_workflows_cmd() => AppConstants.api.MQTT_GET_WORKFLOWS_KEY;

  static String power_cmd(int state) => '${AppConstants.api.MQTT_POWER_KEY}$state';
  static String brightness_cmd(int state) => '${AppConstants.api.MQTT_BRIGHTNESS_KEY}$state';

  static String color_cmd(HSVColor state) {
    final hue = (FunctionUtil.mapHueFrom360(state.hue)).toInt();
    final sat = (state.saturation * 255).toInt();
    final val = (state.value * 255).toInt();
    return '${AppConstants.api.MQTT_COLOR_KEY}$hue,$sat,$val';
  }

  static String breath_cmd(double state) => '${AppConstants.api.MQTT_BREATH_KEY}$state';
  static String effect_cmd(int state) => '${AppConstants.api.MQTT_EFFECT_KEY}$state';
  static String effect_speed_cmd(int state) => '${AppConstants.api.MQTT_EFFECT_SPEED_KEY}$state';
  static String effect_scale_cmd(int state) => '${AppConstants.api.MQTT_EFFECT_SCALE_KEY}$state';
  static String sleep_mode_cmd() => '${AppConstants.api.MQTT_BRIGHTNESS_KEY}${AppConstants.api.SLEEP_MODE_BRIGHTNESS}';
  static String shut_down_cmd() => '${AppConstants.api.MQTT_POWER_KEY}0';

  static String upd_device_settings_cmd(DeviceSettings settings) => '${AppConstants.api.MQTT_UPDATE_SETTINGS_KEY}${settings.toStringData()}';

  static String add_workflow_cmd(Workflow workflow) => '${AppConstants.api.MQTT_ADD_WORKFLOW_KEY}${workflow.toStringData()}';
  static String update_workflow_cmd(Workflow workflow) => '${AppConstants.api.MQTT_UPDATE_WORKFLOW_KEY}${workflow.toStringData()}';
  static String delete_workflow_cmd(int workflowId) => '${AppConstants.api.MQTT_DELETE_WORKFLOW_KEY}$workflowId';

  static String update_firmware(String firmwareUrl) => '${AppConstants.api.MQTT_FIRMWARE_UPDATE_KEY}$firmwareUrl';
}
