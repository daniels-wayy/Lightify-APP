import 'package:lightify/core/data/model/device.dart';

abstract class NetworkRepo {
  Future<void> initializeConnection({void Function()? onConnectionLost});
  Stream<String?>? getMQTTUpdatesStream();
  void getDevicesState();
  void getDeviceState(Device device);
  void sendToDevice(Device device, String cmd);
  bool isMQTTConnected();
}
