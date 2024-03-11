import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@injectable
class Storage {
  final SharedPreferences sharedPreferences;

  const Storage({required this.sharedPreferences});

  Future<bool> putBool({required String key, required bool value}) async {
    return sharedPreferences.setBool(key, value);
  }

  bool? getBool({required String key}) {
    return sharedPreferences.getBool(key);
  }

  Future<bool> putString({required String key, required String value}) async {
    return sharedPreferences.setString(key, value);
  }

  String? getString({required String key}) {
    return sharedPreferences.getString(key);
  }

  Future<bool> putInt({required String key, required int value}) async {
    return sharedPreferences.setInt(key, value);
  }

  int? getInt({required String key}) {
    return sharedPreferences.getInt(key);
  }

  Future<bool> putDouble({required String key, required double value}) async {
    return sharedPreferences.setDouble(key, value);
  }

  double? getDouble({required String key}) {
    return sharedPreferences.getDouble(key);
  }

  Future<bool> putStringArray({required String key, required List<String> value}) async {
    return sharedPreferences.setStringList(key, value);
  }

  List<String>? getStringArray({required String key}) {
    return sharedPreferences.getStringList(key);
  }

  Future<bool> remove({required String key}) async {
    return sharedPreferences.remove(key);
  }
}
