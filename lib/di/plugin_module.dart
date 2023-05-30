import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:injectable/injectable.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

@module
abstract class PluginModule {
  @preResolve
  Future<SharedPreferences> get prefs async => await SharedPreferences.getInstance();

  @LazySingleton()
  Connectivity provideConnectivity() => Connectivity();

  @preResolve
  Future<PackageInfo> get packageInfo => PackageInfo.fromPlatform();
}
