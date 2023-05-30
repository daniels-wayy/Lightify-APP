import 'package:lightify/core/data/model/current_device_info.dart';

abstract class CurrentDeviceRepo {
  Future<CurrentDeviceInfo> getCurrentDeviceInfo();
}
