import 'package:lightify/core/ui/extensions/core_extensions.dart';

class DeviceSettings {
  final String topic;
  final int port;
  final int currentLimit;
  final int ledCount;
  final int gmt;
  final String ip;
  final bool usePortal;

  const DeviceSettings({
    required this.topic,
    required this.port,
    required this.currentLimit,
    required this.ledCount,
    required this.gmt,
    required this.ip,
    required this.usePortal,
  });

  String toStringData() {
    return '$port,$currentLimit,$ledCount,$gmt,${usePortal.intState}';
  }
}
