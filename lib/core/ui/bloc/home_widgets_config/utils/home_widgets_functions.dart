import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:home_widget/home_widget.dart';
import 'package:lightify/core/ui/bloc/home_widgets_config/data/models/home_widgets_dto.dart';
import 'package:lightify/core/ui/bloc/home_widgets_config/utils/home_widgets_config.dart';
import 'package:lightify/core/ui/constants/app_constants.dart';
import 'package:lightify/core/ui/utils/function_util.dart';
import 'package:lightify/core/ui/utils/mqtt_util.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

const updateKey = "update";
const widgetsKey = "devices";

Future<void> updateWidgets(HomeWidgetsDTO dto) async {
  final json = dto.toJson();
  final encodedJson = jsonEncode(json);
  debugPrint('updateWidgets: $encodedJson');
  await HomeWidget.saveWidgetData<String>(widgetsKey, encodedJson);
  await HomeWidget.updateWidget(
    iOSName: HomeWidgetsConfig.iOSName,
  );
}

@pragma('vm:entry-point')
Future<void> interactiveCallback(Uri? uri) async {
  if (uri != null) {
    print('interactiveCallback: $uri / ${uri.host} / ${uri.toString()}');

    late MqttServerClient client;

    final connMessage = MqttConnectMessage().withWillQos(MqttQos.atMostOnce).withClientIdentifier(
          FunctionUtil.generateRandomString(12),
        );
    client = MqttServerClient(AppConstants.api.MQTT_BROKER_HOST, '',
        maxConnectionAttempts: AppConstants.api.MQTT_CONNECTION_ATTEMPTS);
    client.port = AppConstants.api.MQTT_PORT;

    client.setProtocolV311();
    client.keepAlivePeriod = AppConstants.api.MQTT_KEEP_ALIVE_FREQ_SEC;
    client.connectTimeoutPeriod = 3000; // milliseconds
    client.connectionMessage = connMessage;
    client.onConnected = () {
      final value = '${AppConstants.api.MQTT_PACKETS_HEADER}${MQTT_UTIL.power_cmd(0)}';
      final mqttPayloadBuilder = MqttClientPayloadBuilder().addString(value);
      if (mqttPayloadBuilder.payload != null) {
        client.publishMessage('DSLY_Bedroom_Monitor', MqttQos.exactlyOnce, mqttPayloadBuilder.payload!);
      }
    };

    try {
      await client.connect();
      await Future<void>.delayed(const Duration(milliseconds: 50));
    } on NoConnectionException catch (e) {
      debugPrint('MQTT Connection NoConnectionException! $e');
      client.disconnect();
    } on SocketException catch (e) {
      debugPrint('MQTT Connection SocketException! $e');
      client.disconnect();
    } catch (e) {
      debugPrint('MQTT Connection error! $e');
      client.disconnect();
    }

    if (client.connectionStatus?.state == MqttConnectionState.connected) {
      client.subscribe(AppConstants.api.MQTT_TOPIC, MqttQos.atMostOnce);
    }
  }
}

Future<String?> get _currentWidgetsState async {
  final value = await HomeWidget.getWidgetData<String>(widgetsKey, defaultValue: null);
  return value;
}
