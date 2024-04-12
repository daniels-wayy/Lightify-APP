// ignore_for_file: non_constant_identifier_names
import 'dart:convert';
import 'package:injectable/injectable.dart';
import 'package:lightify/config.dart';
import 'package:lightify/core/data/model/color_preset.dart';
import 'package:lightify/core/data/model/device_rename_dto.dart';
import 'package:lightify/core/data/storages/storage.dart';
import 'package:lightify/core/data/storages/storage_keys.dart';
import 'package:lightify/core/ui/utils/function_util.dart';

@injectable
class CommonStorage extends StorageKeys {
  final Storage storage;

  CommonStorage({required this.storage});

  final _COLOR_PRESETS_MAP_KEY = 'colorPresets';
  final _DEVICE_RENAMES_MAP_KEY = 'deviceRenames';

  Future<void> storeColorPresets(List<ColorPreset> presets) async {
    final map = <String, dynamic>{
      _COLOR_PRESETS_MAP_KEY: presets.map((e) => e.toJson()).toList(),
    };
    await storage.putString(key: colorPresetsKey, value: jsonEncode(map));
  }

  List<ColorPreset> getColorPresets() {
    List<ColorPreset>? presets;
    final cachedColorPresets = storage.getString(key: colorPresetsKey);
    if (cachedColorPresets != null && cachedColorPresets.isNotEmpty) {
      final json = jsonDecode(cachedColorPresets) as Map<String, dynamic>;
      presets = (json[_COLOR_PRESETS_MAP_KEY] as List<dynamic>)
          .map((dynamic e) => ColorPreset.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return presets ?? [];
  }

  Future<void> storeNavigationBarSetting(bool value) async {
    await storage.putBool(key: showNavigationBarKey, value: value);
  }

  bool getNavigationBarSetting() {
    return storage.getBool(key: showNavigationBarKey) ?? true;
  }

  Future<void> storeHomeSelectorBarSetting(bool value) async {
    await storage.putBool(key: showHomeSelectorKey, value: value);
  }

  bool getHomeSelectorBarSetting() {
    return storage.getBool(key: showHomeSelectorKey) ?? Config.showHomeSelectorDefault;
  }

  List<String>? getDevicesGroupOrder() {
    return storage.getStringArray(key: devicesGroupOrderKey);
  }

  Future<void> storeDevicesGroupOrder(List<String> value) async {
    await storage.putStringArray(key: devicesGroupOrderKey, value: value);
  }

  Future<void> storeRenamesData(List<DeviceRenameDTO> renames) async {
    final map = <String, dynamic>{
      _DEVICE_RENAMES_MAP_KEY: renames.map((e) => e.toJson()).toList(),
    };
    await storage.putString(key: deviceRenamesKey, value: jsonEncode(map));
  }

  List<DeviceRenameDTO> getRenamesData() {
    List<DeviceRenameDTO>? renames;
    final cachedRenames = storage.getString(key: deviceRenamesKey);
    if (cachedRenames != null && cachedRenames.isNotEmpty) {
      final json = jsonDecode(cachedRenames) as Map<String, dynamic>;
      renames = (json[_DEVICE_RENAMES_MAP_KEY] as List<dynamic>)
          .map((dynamic e) => DeviceRenameDTO.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return renames ?? [];
  }

  DateTime? getFirmwareLastCheck() {
    final data = storage.getString(key: firmwareLastCheckKey);
    if (data != null && data.isNotEmpty) {
      return DateTime.parse(data);
    }
    return null;
  }

  Future<void> storeFirmwareLastCheck() async {
    final nowDate = FunctionUtil.nowMinDate();
    await storage.putString(key: firmwareLastCheckKey, value: nowDate.toIso8601String());
  }
}
