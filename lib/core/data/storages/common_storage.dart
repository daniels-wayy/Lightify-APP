// ignore_for_file: non_constant_identifier_names
import 'dart:convert';
import 'package:injectable/injectable.dart';
import 'package:lightify/core/data/model/color_preset.dart';
import 'package:lightify/core/data/storages/storage.dart';
import 'package:lightify/core/data/storages/storage_keys.dart';

@injectable
class CommonStorage extends StorageKeys {
  final Storage storage;

  CommonStorage({required this.storage});

  final _COLOR_PRESETS_MAP_KEY = 'colorPresets';

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
}
