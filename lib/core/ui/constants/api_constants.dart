// ignore_for_file: non_constant_identifier_names

part of 'app_constants.dart';

class _ApiConstants {
  _ApiConstants();

  final mqttPort = 1883;
  final mqttHost = 'broker.mqttdashboard.com';
  final appMqttTopic = 'DSLY_App';
  final mqttConnectionAttempts = 3;

  static const dsPacketHeader = 'DSLY';
  static const dnPacketHeader = 'DNLY';

  static const debugDeviceRemote = '${dsPacketHeader}_Debug_Lightify'; // debug
  static const kitchenWorkspaceRemote = '${dsPacketHeader}_Kitchen_Workspace';
  static const livingRoomTVRemote = '${dsPacketHeader}_Livingroom_TV';
  static const livingRoomPianoRemote = '${dsPacketHeader}_Livingroom_Piano';
  static const officePCMonitorRemote = '${dsPacketHeader}_Office_Monitor';
  static const officeDeskRemote = '${dsPacketHeader}_Office_Desk';
  static const officeMacMonitorRemote = '${dsPacketHeader}_Office_Mac_Monitor';
  static const bedroomBedLowersideRemote = '${dsPacketHeader}_Bedroom_Bed_Lowerside';
  static const bedroomBedUppersideRemote = '${dsPacketHeader}_Bedroom_Bed_Upperside';
  static const bedroomClosetRemote = '${dsPacketHeader}_Bedroom_Closet';
  static const dnKitchenCeiling = '${dnPacketHeader}_Kitchen_Ceiling';

  // D&V
  final dsRemotes = [
    kitchenWorkspaceRemote,
    livingRoomTVRemote,
    bedroomBedLowersideRemote,
    officePCMonitorRemote,
    officeDeskRemote,
    officeMacMonitorRemote,
    bedroomBedUppersideRemote,
    livingRoomPianoRemote,
    bedroomClosetRemote,
    if (!kReleaseMode) debugDeviceRemote,
  ];

  // Nick
  final dnRemotes = const [
    dnKitchenCeiling,
  ];

  final devicesInfo = const <String, DeviceInfo>{
    // DS
    kitchenWorkspaceRemote: DeviceInfo(
      topic: kitchenWorkspaceRemote,
      deviceName: 'Workspace',
      deviceGroup: 'Kitchen',
      icon: Icons.restaurant,
    ),
    livingRoomTVRemote: DeviceInfo(
      topic: livingRoomTVRemote,
      deviceName: 'TV',
      deviceGroup: 'Living Room',
      icon: Icons.tv,
    ),
    bedroomBedLowersideRemote: DeviceInfo(
      topic: bedroomBedLowersideRemote,
      deviceName: 'Bed Lowerside',
      deviceGroup: 'Bedroom',
      icon: Icons.bed_outlined,
    ),
    bedroomBedUppersideRemote: DeviceInfo(
      topic: bedroomBedUppersideRemote,
      deviceName: 'Bed Upperside',
      deviceGroup: 'Bedroom',
      icon: Icons.bedroom_parent_outlined,
    ),
    officePCMonitorRemote: DeviceInfo(
      topic: officePCMonitorRemote,
      deviceName: 'PC Monitor',
      deviceGroup: 'Office',
      icon: Icons.monitor_rounded,
    ),
    officeDeskRemote: DeviceInfo(
      topic: officeDeskRemote,
      deviceName: 'Desk',
      deviceGroup: 'Office',
      icon: Icons.desk,
    ),
    livingRoomPianoRemote: DeviceInfo(
      topic: livingRoomPianoRemote,
      deviceName: 'Piano',
      deviceGroup: 'Living Room',
      icon: Icons.piano,
    ),
    bedroomClosetRemote: DeviceInfo(
      topic: bedroomClosetRemote,
      deviceName: 'Closet',
      deviceGroup: 'Bedroom',
      icon: Icons.beach_access,
    ),
    officeMacMonitorRemote: DeviceInfo(
      topic: officeMacMonitorRemote,
      deviceName: 'Mac Monitor',
      deviceGroup: 'Office',
      icon: Icons.laptop_mac,
    ),
    debugDeviceRemote: DeviceInfo(
      topic: debugDeviceRemote,
      deviceName: 'Debug',
      deviceGroup: 'Debug Room',
    ),

    // DN
    dnKitchenCeiling: DeviceInfo(
      topic: dnKitchenCeiling,
      deviceName: 'Ceiling',
      deviceGroup: 'Kitchen',
      icon: Icons.restaurant,
    ),
  };

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
  final MQTT_RESET_SETTINGS_KEY = 'STGRT';

  // Workflows
  final MQTT_ADD_WORKFLOW_KEY = 'WFLDD';
  final MQTT_UPDATE_WORKFLOW_KEY = 'WFLPD';
  final MQTT_DELETE_WORKFLOW_KEY = 'WFLEL';
  final MQTT_CLEAR_WORKFLOWS_KEY = 'WFLCL';
  final MAX_WORKFLOWS_COUNT = 10;

  final MQTT_FIRMWARE_UPDATE_KEY = 'FWRPD';
  final UPD_STARTED_KEY = 'ST';
  final UPD_PROGRESS_KEY = 'PG';
  final UPD_FINISHED_KEY = 'FD';
  final UPD_ERROR_KEY = 'ER';

  final SLEEP_MODE_BRIGHTNESS = 5;
  final MQTT_DEVICE_MAX_BRIGHTNESS = 255;
  final MQTT_SEND_REQUEST_THRESHOLD = const Duration(milliseconds: 120);
  final MQTT_GET_REQUEST_FREQ = const Duration(seconds: 30);
  final MQTT_KEEP_ALIVE_FREQ_SEC = 25;

  final EFFECT_MIN_SPEED = 10;
  final EFFECT_MAX_SPEED = 100;

  final EFFECT_MIN_SCALE = 0;
  final EFFECT_MAX_SCALE = 255;
}
