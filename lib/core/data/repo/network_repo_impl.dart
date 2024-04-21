import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:lightify/core/domain/repo/current_device_repo.dart';
import 'package:lightify/core/domain/repo/network_repo.dart';
import 'package:lightify/core/ui/constants/app_constants.dart';
import 'package:lightify/core/ui/utils/function_util.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

@LazySingleton(as: NetworkRepo)
class NetworkRepoImpl implements NetworkRepo {
  final CurrentDeviceRepo currentDeviceRepo;

  NetworkRepoImpl({required this.currentDeviceRepo});

  late MqttServerClient client;

  @override
  Future<void> establishConnection(
      {void Function()? onConnected, void Function()? onDisconnected, void Function(String p1)? onSubscribed}) async {
    final currentDeviceInfo = await currentDeviceRepo.getCurrentDeviceInfo();
    final connMessage = MqttConnectMessage().withWillQos(MqttQos.atMostOnce).withClientIdentifier(
          currentDeviceInfo.deviceId ?? FunctionUtil.generateRandomString(12),
        );
    client = MqttServerClient(AppConstants.api.mqttHost, '',
        maxConnectionAttempts: AppConstants.api.mqttConnectionAttempts);
    client.port = AppConstants.api.mqttPort;

    client.setProtocolV311();
    client.keepAlivePeriod = AppConstants.api.MQTT_KEEP_ALIVE_FREQ_SEC;
    client.connectTimeoutPeriod = 4000; // milliseconds
    client.connectionMessage = connMessage;
    client.onDisconnected = onDisconnected;
    client.onConnected = onConnected;
    client.onSubscribed = onSubscribed;

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
      client.subscribe(AppConstants.api.appMqttTopic, MqttQos.atMostOnce);
    }
  }

  @override
  void overrideConnectivityCallbacks({
    void Function()? onConnected,
    void Function()? onDisconnected,
    void Function(String)? onSubscribed,
  }) {
    if (onDisconnected != null) {
      client.onDisconnected = onDisconnected;
    }
    if (onConnected != null) {
      client.onConnected = onConnected;
    }
    if (onSubscribed != null) {
      client.onSubscribed = onSubscribed;
    }
  }

  @override
  Stream<String?>? get serverUpdates {
    return client.updates?.map((messages) {
      if (messages.isEmpty) return null;
      try {
        final recMess = messages.first.payload as MqttPublishMessage;
        final message = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
        return message;
      } catch (_) {
        return null;
      }
    });
  }

  @override
  bool isConnectedToServer() {
    final state = client.connectionStatus?.state;
    return state != null && state == MqttConnectionState.connected;
  }

  @override
  void sendToServer(String address, String data) {
    if (isConnectedToServer()) {
      try {
        final formattedData = '${AppConstants.api.MQTT_PACKETS_HEADER}$data';
        final mqttPayloadBuilder = MqttClientPayloadBuilder().addString(formattedData);
        if (mqttPayloadBuilder.payload != null) {
          client.publishMessage(address, MqttQos.exactlyOnce, mqttPayloadBuilder.payload!);
        }
      } catch (e) {
        debugPrint('NetworkRepoImpl - sendToServer error: $e');
      }
    }
  }
}
