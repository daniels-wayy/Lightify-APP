abstract class NetworkRepo {
  Future<void> initializeConnection({
    void Function()? onConnected,
    void Function()? onDisconnected,
    void Function(String)? onSubscribed,
  });

  Stream<String?>? getMQTTUpdatesStream();
  Future<void> getDevicesState();
  void getDeviceState(String deviceTopic);
  void sendToDevice(String deviceTopic, String cmd);
  bool isMQTTConnected();
}
