abstract class NetworkRepo {
  Stream<String?>? get serverUpdates;
  Future<void> establishConnection(
      {void Function()? onConnected, void Function()? onDisconnected, void Function(String)? onSubscribed});
  void overrideConnectivityCallbacks(
      {void Function()? onConnected, void Function()? onDisconnected, void Function(String)? onSubscribed});
  void sendToServer(String address, String data);
  bool isConnectedToServer();
}
