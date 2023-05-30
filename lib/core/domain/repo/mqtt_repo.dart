import 'package:mqtt_client/mqtt_client.dart';

abstract class MQTTRepo {
  Future<MqttConnectionState?> connectToMQTT({void Function()? onDisconnect});
  Stream<List<MqttReceivedMessage<MqttMessage>>>? getMQTTUpdatesStream();
  MqttConnectionState getMQTTConnectionState();
  void send(String topic, String data);
}
