import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:home_widget/home_widget.dart';
import 'package:lightify/core/ui/bloc/home_widgets_config/data/models/home_widgets_dto.dart';
import 'package:lightify/core/ui/bloc/home_widgets_config/utils/home_widgets_config.dart';
import 'package:lightify/core/ui/constants/app_constants.dart';
import 'package:lightify/core/ui/extensions/core_extensions.dart';
import 'package:lightify/core/ui/utils/function_util.dart';
import 'package:lightify/core/ui/utils/mqtt_util.dart';
import 'package:lightify/pages/main/settings/home_widgets/data/models/home_widget_device_entity.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

const updateKey = "update";
const widgetsKey = "devices";

MqttServerClient? _serverClient;

@pragma('vm:entry-point')
Future<void> interactiveCallback(Uri? uri) async {
  if (uri?.host != null && uri!.host.startsWith(updateKey)) {
    final desiredRemote = uri.path.replaceAll('/', '');

    if (_serverClient == null || _serverClient!.connectionStatus?.state == MqttConnectionState.disconnected) {
      _serverClient = _createMqttClient();
      try {
        await _serverClient!.connect();
        if (_serverClient!.connectionStatus?.state == MqttConnectionState.connected) {
          _serverClient!.subscribe(AppConstants.api.MQTT_TOPIC, MqttQos.atMostOnce);
        }
      } catch (e) {
        _serverClient!.disconnect();
        _serverClient = null;
      }
    }

    await _delay();

    if (_serverClient!.connectionStatus?.state == MqttConnectionState.connected) {
      await _processWidgets(desiredRemote);
    }
  }
}

Future<void> _delay() async {
  return await Future<void>.delayed(const Duration(milliseconds: 100));
}

Future<void> updateWidgets(HomeWidgetsDTO dto) async {
  final json = dto.toJson();
  final encodedJson = jsonEncode(json);
  debugPrint('updateWidgets: $encodedJson');
  await HomeWidget.saveWidgetData<String>(widgetsKey, encodedJson);
  await HomeWidget.updateWidget(
    iOSName: HomeWidgetsConfig.iOSName,
  );
}

MqttServerClient _createMqttClient() {
  late final MqttServerClient client;
  final connMessage = MqttConnectMessage().withWillQos(MqttQos.atMostOnce).withClientIdentifier(
        FunctionUtil.generateRandomString(12),
      );
  client = MqttServerClient(AppConstants.api.MQTT_BROKER_HOST, '',
      maxConnectionAttempts: AppConstants.api.MQTT_CONNECTION_ATTEMPTS);
  client.port = AppConstants.api.MQTT_PORT;
  client.setProtocolV311();
  client.keepAlivePeriod = AppConstants.api.MQTT_KEEP_ALIVE_FREQ_SEC;
  client.connectTimeoutPeriod = 1000; // milliseconds
  client.connectionMessage = connMessage;
  return client;
}

Future<void> _processWidgets(String remote) async {
  final currentWidgets = await _getWidgetState;

  if (currentWidgets != null) {
    late HomeWidgetDeviceEntity entity;

    try {
      // find desired device in widget families
      entity = currentWidgets.smallWidget.firstWhere(
        (smallWidgetDevice) => smallWidgetDevice.deviceTopic == remote,
        orElse: () => currentWidgets.mediumWidget.firstWhere(
          (mediumWidgetDevice) => mediumWidgetDevice.deviceTopic == remote,
          orElse: () => currentWidgets.bigWidget.firstWhere(
            (bigWidgetDevice) => bigWidgetDevice.deviceTopic == remote,
          ),
        ),
      );

      // update power state to opposite
      final currentPowerState = entity.currentPowerState;
      final newPowerState = !currentPowerState;
      entity = entity.copyWith(currentPowerState: newPowerState);

      // update widgets with new device instance in all widget families where this device is
      final smallWidget = currentWidgets.smallWidget.map((e) => e.deviceTopic == entity.deviceTopic ? entity : e);
      final mediumWidget = currentWidgets.mediumWidget.map((e) => e.deviceTopic == entity.deviceTopic ? entity : e);
      final bigWidget = currentWidgets.bigWidget.map((e) => e.deviceTopic == entity.deviceTopic ? entity : e);

      // create new DTO
      final newDTO = HomeWidgetsDTO(
        smallWidget: smallWidget.toList(),
        mediumWidget: mediumWidget.toList(),
        bigWidget: bigWidget.toList(),
      );

      // send updated state to the server
      final isSend = _sendMsgToServer(entity.deviceTopic, MQTT_UTIL.power_cmd(newPowerState.intState));

      // if sent => update home screen widget families
      if (isSend) {
        updateWidgets(newDTO);
      }
    } on StateError catch (e) {
      debugPrint('Widget not found: $e');
    }
  }
}

bool _sendMsgToServer(String remote, String data) {
  if (_serverClient?.connectionStatus?.state == MqttConnectionState.connected) {
    try {
      final value = '${AppConstants.api.MQTT_PACKETS_HEADER}$data';
      final mqttPayloadBuilder = MqttClientPayloadBuilder().addString(value);
      if (mqttPayloadBuilder.payload != null) {
        _serverClient!.publishMessage(remote, MqttQos.exactlyOnce, mqttPayloadBuilder.payload!);
        return true;
      }
    } catch (e) {
      debugPrint('_sendMsgToServer error: $e');
    }
  }
  return false;
}

Future<HomeWidgetsDTO?> get _getWidgetState async {
  final currentData = await HomeWidget.getWidgetData<String?>(widgetsKey, defaultValue: null);
  if (currentData != null) {
    final decodedJson = jsonDecode(currentData) as Map<String, dynamic>;
    if (decodedJson.isNotEmpty) {
      final dto = HomeWidgetsDTO.fromJson(decodedJson);
      return dto;
    }
  }
  return null;
}
