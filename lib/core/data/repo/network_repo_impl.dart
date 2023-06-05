import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:lightify/core/data/storages/common_storage.dart';
import 'package:lightify/core/domain/repo/mqtt_repo.dart';
import 'package:lightify/core/domain/repo/network_repo.dart';
import 'package:lightify/core/ui/constants/app_constants.dart';
import 'package:lightify/core/ui/utils/mqtt_util.dart';
import 'package:mqtt_client/mqtt_client.dart';

@LazySingleton(as: NetworkRepo)
class NetworkRepoImpl implements NetworkRepo {
  final CommonStorage commonStorage;
  final MQTTRepo mqttRepo;

  NetworkRepoImpl({
    required this.commonStorage,
    required this.mqttRepo,
  });

  @override
  Future<void> initializeConnection({
    void Function()? onConnected,
    void Function()? onDisconnected,
    void Function(String)? onSubscribed,
  }) async {
    await mqttRepo.connectToMQTT(
      onConnected: onConnected,
      onDisconnected: onDisconnected,
      onSubscribed: onSubscribed,
    );
  }

  @override
  Stream<String?>? getMQTTUpdatesStream() {
    final stream = mqttRepo.getMQTTUpdatesStream();
    return stream?.map((event) {
      if (event.isEmpty) return null;
      try {
        final recMess = event.first.payload as MqttPublishMessage;
        final message = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
        return message;
      } catch (_) {
        return null;
      }
    });
  }

  @override
  Future<void> getDevicesState() async {
    for (final topic in AppConstants.api.MQTT_DEVICES_REMOTES) {
      sendToDevice(topic, MQTT_UTIL.get_cmd());
      await Future<void>.delayed(const Duration(milliseconds: 100));
    }
  }

  @override
  void getDeviceState(String deviceTopic) {
    sendToDevice(deviceTopic, MQTT_UTIL.get_cmd());
  }

  @override
  void sendToDevice(String deviceTopic, String cmd) {
    if (isMQTTConnected()) {
      debugPrint('sendToDevice: $deviceTopic - $cmd');
      mqttRepo.send(deviceTopic, cmd);
    }
  }

  @override
  bool isMQTTConnected() {
    return mqttRepo.getMQTTConnectionState() == MqttConnectionState.connected;
  }
}
