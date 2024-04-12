// ignore_for_file: non_constant_identifier_names

part of 'app_constants.dart';

class _ApiConstants {
  const _ApiConstants();

  final MQTT_BROKER_HOST = 'broker.mqttdashboard.com';
  final COMMUNICATION_HEADER = 'DSLY';
  final COMMUNICATION_HEADER2 = 'DNLY';
  final MQTT_TOPIC = 'DSLY_App';
  final MQTT_PORT = 1883;
  // final MQTT_CLIENT_ID = 'DSLYAPPID';
  final MQTT_CONNECTION_ATTEMPTS = 3;

  // D&V
  final List<String> DS_MQTT_DEVICES_REMOTES = const [
    'DSLY_Kitchen_Workspace',
    'DSLY_Livingroom_TV',
    'DSLY_Bedroom_Bed_Lowerside',
    'DSLY_Office_Monitor',
    'DSLY_Office_Desk',
    'DSLY_Bedroom_Bed_Upperside',
    'DSLY_Livingroom_Piano',
    'DSLY_Bedroom_Closet',
    if (!kReleaseMode) 'DSLY_Debug_Lightify',
  ];

  final Map<String, DeviceInfo> DEVICES_INFO = const {
    // DS
    'DSLY_Kitchen_Workspace':
        DeviceInfo(topic: 'DSLY_Kitchen_Workspace', deviceName: 'Workspace', deviceGroup: 'Kitchen'),
    'DSLY_Livingroom_TV': DeviceInfo(topic: 'DSLY_Livingroom_TV', deviceName: 'TV', deviceGroup: 'Living Room'),
    'DSLY_Bedroom_Bed_Lowerside':
        DeviceInfo(topic: 'DSLY_Bedroom_Bed_Lowerside', deviceName: 'Bed Lowerside', deviceGroup: 'Bedroom'),
    'DSLY_Bedroom_Bed_Upperside':
        DeviceInfo(topic: 'DSLY_Bedroom_Bed_Upperside', deviceName: 'Bed Upperside', deviceGroup: 'Bedroom'),
    'DSLY_Office_Monitor': DeviceInfo(topic: 'DSLY_Office_Monitor', deviceName: 'Monitor', deviceGroup: 'Office'),
    'DSLY_Office_Desk': DeviceInfo(topic: 'DSLY_Office_Desk', deviceName: 'Desk', deviceGroup: 'Office'),
    'DSLY_Livingroom_Piano':
        DeviceInfo(topic: 'DSLY_Livingroom_Piano', deviceName: 'Piano', deviceGroup: 'Living Room'),
    'DSLY_Bedroom_Closet': DeviceInfo(topic: 'DSLY_Bedroom_Closet', deviceName: 'Closet', deviceGroup: 'Bedroom'),
    'DSLY_Debug_Lightify': DeviceInfo(topic: 'DSLY_Debug_Lightify', deviceName: 'Debug', deviceGroup: 'Debug Room'),

    // DN
    'DNLY_Kitchen_Ceiling': DeviceInfo(topic: 'DNLY_Kitchen_Ceiling', deviceName: 'Ceiling', deviceGroup: 'Kitchen'),
  };

  // Nick
  final List<String> DN_MQTT_DEVICES_REMOTES = const [
    'DNLY_Kitchen_Ceiling',
  ];

  final MQTT_PACKETS_HEADER = 'DSLY:';
  final MQTT_DEVICE_GET_HEADER = 'DEV';
  final MQTT_DEVICE_GET_SETTINGS_HEADER = 'STGS';
  final MQTT_DEVICE_GET_WORKFLOWS_HEADER = 'WFLS';
  final MQTT_DEVICE_GET_FIRMWARE_STATUS_HEADER = 'FWST';

  final MQTT_GET_KEY = "GET";
  final MQTT_GET_SETTINGS_KEY = "STGGT";
  final MQTT_GET_WORKFLOWS_KEY = "WFLGT";

  final MQTT_POWER_KEY = 'PWR';
  final MQTT_BRIGHTNESS_KEY = 'BRI';
  final MQTT_COLOR_KEY = 'CLR';
  final MQTT_BREATH_KEY = 'BRE';
  final MQTT_EFFECT_KEY = 'EFF';
  final MQTT_EFFECT_SPEED_KEY = 'SPD';
  final MQTT_EFFECT_SCALE_KEY = 'SCL';
  final MQTT_UPDATE_SETTINGS_KEY = 'STGPD';

  // Workflows
  final MQTT_ADD_WORKFLOW_KEY = 'WFLDD';
  final MQTT_UPDATE_WORKFLOW_KEY = 'WFLPD';
  final MQTT_DELETE_WORKFLOW_KEY = 'WFLEL';
  final MAX_WORKFLOWS_COUNT = 10;

  final MQTT_FIRMWARE_UPDATE_KEY = 'FWRPD';
  final UPD_STARTED_KEY = 'ST';
  final UPD_PROGRESS_KEY = 'PG';
  final UPD_FINISHED_KEY = 'FD';
  final UPD_ERROR_KEY = 'ER';

  final SLEEP_MODE_BRIGHTNESS = 5;
  final MQTT_DEVICE_MAX_BRIGHTNESS = 255;
  final MQTT_SEND_REQUEST_THRESHOLD = const Duration(milliseconds: 150);
  final MQTT_GET_REQUEST_FREQ = const Duration(seconds: 30);
  final MQTT_KEEP_ALIVE_FREQ_SEC = 25;

  final EFFECT_MIN_SPEED = 1;
  final EFFECT_MAX_SPEED = 40;

  final EFFECT_MIN_SCALE = 0;
  final EFFECT_MAX_SCALE = 255;
}
