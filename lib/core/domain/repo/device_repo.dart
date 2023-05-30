import 'package:lightify/core/data/model/device.dart';

abstract class DeviceRepo {
  Device? parseDevice(String data);
}
