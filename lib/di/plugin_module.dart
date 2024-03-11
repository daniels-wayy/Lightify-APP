import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:injectable/injectable.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

@module
abstract class PluginModule {
  @preResolve
  Future<SharedPreferences> get prefs async => await SharedPreferences.getInstance();

  @LazySingleton()
  Connectivity provideConnectivity() => Connectivity();

  @LazySingleton()
  DeviceInfoPlugin provideDeviceInfo() => DeviceInfoPlugin();

  @preResolve
  Future<PackageInfo> get packageInfo async => await PackageInfo.fromPlatform();
}
