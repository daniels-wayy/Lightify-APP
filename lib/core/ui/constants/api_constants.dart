// ignore_for_file: non_constant_identifier_names

part of 'app_constants.dart';

class _ApiConstants {
  const _ApiConstants();

  final MQTT_BROKER_HOST = 'broker.mqttdashboard.com';
  final MQTT_TOPIC = 'DSLY_App';
  final MQTT_PORT = 1883;
  // final MQTT_CLIENT_ID = 'DSLYAPPID';
  final MQTT_CONNECTION_ATTEMPTS = 3;

  final List<String> MQTT_DEVICES_REMOTES = const [
    'DSLY_Livingroom_TV',
    'DSLY_Kitchen_Workspace',
    'DSLY_Bedroom_Closet',
    'DSLY_Bedroom_Bed',
  ];

  final MQTT_PACKETS_HEADER = 'DSLY:';

  final MQTT_GET_KEY = "GET";
  final MQTT_POWER_KEY = 'PWR';
  final MQTT_BRIGHTNESS_KEY = 'BRI';
  final MQTT_COLOR_KEY = 'CLR';
  final MQTT_BREATH_KEY = 'BRE';

  final SLEEP_MODE_BRIGHTNESS = 5;
  final MQTT_DEVICE_MAX_BRIGHTNESS = 255;
  final MQTT_SEND_REQUEST_THRESHOLD = const Duration(milliseconds: 200);
  final MQTT_GET_REQUEST_FREQ = const Duration(seconds: 30);
  final MQTT_KEEP_ALIVE_FREQ_SEC = 25;
}
