import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:lightify/core/domain/repo/current_device_repo.dart';
import 'package:lightify/core/domain/repo/mqtt_repo.dart';
import 'package:lightify/core/ui/constants/app_constants.dart';
import 'package:lightify/core/ui/utils/function_util.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

@LazySingleton(as: MQTTRepo)
class MQTTRepoImpl implements MQTTRepo {
  final CurrentDeviceRepo currentDeviceRepo;

  MQTTRepoImpl(this.currentDeviceRepo);

  late MqttServerClient client;

  @override
  Future<void> connectToMQTT({
    void Function()? onConnected,
    void Function()? onDisconnected,
    void Function(String)? onSubscribed,
  }) async {
    final currentDeviceInfo = await currentDeviceRepo.getCurrentDeviceInfo();
    final connMessage = MqttConnectMessage().withWillQos(MqttQos.atMostOnce).withClientIdentifier(
          currentDeviceInfo.deviceId ?? FunctionUtil.generateRandomString(12),
        );
    client = MqttServerClient(AppConstants.api.MQTT_BROKER_HOST, '',
        maxConnectionAttempts: AppConstants.api.MQTT_CONNECTION_ATTEMPTS);
    client.port = AppConstants.api.MQTT_PORT;

    client.setProtocolV311();
    client.keepAlivePeriod = AppConstants.api.MQTT_KEEP_ALIVE_FREQ_SEC;
    client.connectTimeoutPeriod = 3000; // milliseconds
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
      client.subscribe(AppConstants.api.MQTT_TOPIC, MqttQos.atMostOnce);
    }
  }

  @override
  Stream<List<MqttReceivedMessage<MqttMessage>>>? getMQTTUpdatesStream() => client.updates;

  @override
  MqttConnectionState getMQTTConnectionState() => client.connectionStatus?.state ?? MqttConnectionState.disconnected;

  @override
  void send(String topic, String data) {
    final value = '${AppConstants.api.MQTT_PACKETS_HEADER}$data';
    final mqttPayloadBuilder = MqttClientPayloadBuilder().addString(value);
    if (mqttPayloadBuilder.payload != null) {
      client.publishMessage(topic, MqttQos.exactlyOnce, mqttPayloadBuilder.payload!);
    }
  }
}
