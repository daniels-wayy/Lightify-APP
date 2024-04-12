class DeviceSettings {
  final String topic;
  final int port;
  final int currentLimit;
  final int ledCount;
  final int gmt;
  final String ip;

  const DeviceSettings({
    required this.topic,
    required this.port,
    required this.currentLimit,
    required this.ledCount,
    required this.gmt,
    required this.ip,
  });

  String toStringData() {
    return '$port,$currentLimit,$ledCount,$gmt';
  }
}
