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
  Future<MqttConnectionState?> connectToMQTT({void Function()? onDisconnect}) async {
    try {
      final currentDeviceInfo = await currentDeviceRepo.getCurrentDeviceInfo();
      final connMess = MqttConnectMessage().withWillQos(MqttQos.atMostOnce).withClientIdentifier(
            currentDeviceInfo.deviceId ?? FunctionUtil.generateRandomString(12),
          );
      client = MqttServerClient(AppConstants.api.MQTT_BROKER_HOST, '',
          maxConnectionAttempts: AppConstants.api.MQTT_CONNECTION_ATTEMPTS);
      client.port = AppConstants.api.MQTT_PORT;
      client.logging(on: false);
      client.keepAlivePeriod = 30;
      client.connectionMessage = connMess;
      client.onDisconnected = onDisconnect;

      await client.connect();
      if (client.connectionStatus?.state == MqttConnectionState.connected) {
        client.subscribe(AppConstants.api.MQTT_TOPIC, MqttQos.exactlyOnce);
      } else if (client.connectionStatus?.state == MqttConnectionState.disconnected ||
          client.connectionStatus?.state == MqttConnectionState.disconnecting) {
        _disconnect();
      }
      return client.connectionStatus?.state;
    } catch (e) {
      _disconnect();
      rethrow;
    }
  }

  @override
  Stream<List<MqttReceivedMessage<MqttMessage>>>? getMQTTUpdatesStream() {
    return client.updates;
  }

  @override
  MqttConnectionState getMQTTConnectionState() => client.connectionStatus?.state ?? MqttConnectionState.disconnected;

  @override
  void send(String topic, String data) {
    final value = '${AppConstants.api.MQTT_PACKETS_HEADER}$data';
    final mqttPayloadBuilder = MqttClientPayloadBuilder().addString(value);
    client.publishMessage(topic, MqttQos.exactlyOnce, mqttPayloadBuilder.payload!);
  }

  void _disconnect() => client.disconnect();
}
