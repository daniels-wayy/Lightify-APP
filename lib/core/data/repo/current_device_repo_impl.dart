import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:injectable/injectable.dart';
import 'package:lightify/core/data/model/current_device_info.dart';
import 'package:lightify/core/domain/repo/current_device_repo.dart';
import 'package:package_info_plus/package_info_plus.dart';

@LazySingleton(as: CurrentDeviceRepo)
class CurrentDeviceRepoImpl implements CurrentDeviceRepo {
  final PackageInfo packageInfo;

  CurrentDeviceRepoImpl(this.packageInfo) {
    getCurrentDeviceInfo();
  }

  final _deviceInfoPlugin = DeviceInfoPlugin();

  CurrentDeviceInfo? _currentDeviceInfo;

  @override
  Future<CurrentDeviceInfo> getCurrentDeviceInfo() async {
    return _currentDeviceInfo ??= await _fetchCurrentDeviceInfo();
  }

  Future<CurrentDeviceInfo> _fetchCurrentDeviceInfo() async {
    final appInfo = '${packageInfo.packageName},${packageInfo.version}(${packageInfo.buildNumber})';
    if (Platform.isIOS) {
      final iosDeviceInfo = await _deviceInfoPlugin.iosInfo;
      return CurrentDeviceInfo(
        deviceName: iosDeviceInfo.utsname.machine,
        osVersion: '${Platform.operatingSystem}-${iosDeviceInfo.systemVersion}',
        deviceId: iosDeviceInfo.identifierForVendor, // unique ID on iOS
        appInfo: appInfo,
      );
    }
    if (Platform.isAndroid) {
      final androidDeviceInfo = await _deviceInfoPlugin.androidInfo;
      return CurrentDeviceInfo(
        deviceName: androidDeviceInfo.model,
        osVersion: '${Platform.operatingSystem}-${androidDeviceInfo.version.release}',
        deviceId: androidDeviceInfo.id, // unique ID on Android
        appInfo: appInfo,
      );
    }
    throw UnimplementedError();
  }
}
