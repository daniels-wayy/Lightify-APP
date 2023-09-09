import 'package:mqtt_client/mqtt_client.dart';

abstract class MQTTRepo {
  Future<void> connectToMQTT({
    void Function()? onConnected,
    void Function()? onDisconnected,
    void Function(String)? onSubscribed,
  });
  void overrideConnectivityCallbacks({
    void Function()? onConnected,
    void Function()? onDisconnected,
    void Function(String)? onSubscribed,
  });
  Stream<List<MqttReceivedMessage<MqttMessage>>>? getMQTTUpdatesStream();
  MqttConnectionState getMQTTConnectionState();
  void send(String topic, String data);
}
