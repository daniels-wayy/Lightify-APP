// ignore_for_file: non_constant_identifier_names
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:lightify/core/data/model/device.dart';
import 'package:lightify/core/data/storages/common_storage.dart';
import 'package:lightify/core/domain/repo/mqtt_repo.dart';
import 'package:lightify/core/domain/repo/network_repo.dart';
import 'package:lightify/core/ui/constants/app_constants.dart';
import 'package:lightify/core/ui/utils/mqtt_util.dart';
import 'package:mqtt_client/mqtt_client.dart';

@Injectable(as: NetworkRepo)
class NetworkRepoImpl implements NetworkRepo {
  final CommonStorage commonStorage;
  final MQTTRepo mqttRepo;

  NetworkRepoImpl({required this.commonStorage, required this.mqttRepo});

  @override
  Future<void> initializeConnection({void Function()? onConnectionLost}) async {
    try {
      final state = await mqttRepo.connectToMQTT(onDisconnect: onConnectionLost);
      if (state != MqttConnectionState.connected) {
        throw 'MQTT connection failed';
      }
    } catch (e) {
      debugPrint('MQTT connection error: $e');
      rethrow;
    }
  }

  @override
  Stream<String?>? getMQTTUpdatesStream() {
    try {
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
    } catch (e) {
      debugPrint('getMQTTUpdatesStream error: $e');
      rethrow;
    }
  }

  @override
  void getDevicesState() {
    try {
      for (final topic in AppConstants.api.MQTT_DEVICES_REMOTES) {
        mqttRepo.send(topic, MQTT_UTIL.get_cmd());
      }
    } catch (e) {
      debugPrint('getDevicesState error: $e');
      rethrow;
    }
  }

  @override
  void getDeviceState(Device device) {
    try {
      mqttRepo.send(device.deviceInfo.topic, MQTT_UTIL.get_cmd());
    } catch (e) {
      debugPrint('getDeviceState error: $e');
      rethrow;
    }
  }

  @override
  void sendToDevice(Device device, String cmd) {
    try {
      debugPrint('sendToDevice - ${device.deviceInfo.topic} - $cmd');
      mqttRepo.send(device.deviceInfo.topic, cmd);
    } catch (e) {
      debugPrint('sendToDevice error: $e');
      rethrow;
    }
  }

  @override
  bool isMQTTConnected() {
    try {
      return mqttRepo.getMQTTConnectionState() == MqttConnectionState.connected;
    } catch (e) {
      debugPrint('isMQTTConnected error: $e');
      return false;
    }
  }
}
