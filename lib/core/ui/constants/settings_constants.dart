// ignore_for_file: non_constant_identifier_names

part of 'app_constants.dart';

class _SettingsConstants {
  const _SettingsConstants();

  List<ColorPreset> get defaultColorPresets => [
        ColorPreset(
          color: const HSVColor.fromAHSV(1.0, 46.4039408866995, 0.7929367420517862, 1.0),
          colorName: AppConstants.strings.WARM_WHITE,
          isDefault: true,
        ),
        ColorPreset(
          color: HSVColor.fromColor(const Color(0xFFFFEDDE)),
          colorName: AppConstants.strings.COLD_WHITE,
          isDefault: true,
        ),
        ColorPreset(
          color: HSVColor.fromColor(const Color.fromRGBO(174, 32, 245, 1.0)),
          colorName: AppConstants.strings.DEEP_PURPLE,
          isDefault: true,
        ),
        ColorPreset(
          color: const HSVColor.fromAHSV(1.0, 33.88235294117647, 0.9529411764705882, 0.9450980392156862),
          colorName: AppConstants.strings.DEEP_ORANGE,
          isDefault: true,
        ),
      ];

  final noFx = 0;
  final lavaFx = 1;
  final cloudsFx = 2;
  final forestFx = 3;
  final oceanFx = 4;
  final sparklesFx = 5;
  final rainboxFx = 6;
  final fireFx = 7;

  List<int> get colorFreeEffects => [
        sparklesFx,
        fireFx,
      ];

  List<EffectEntity> get effects => [
        EffectEntity(id: noFx, name: AppConstants.strings.NONE, previewColor: Colors.grey.shade100.withOpacity(0.25)),
        EffectEntity(id: lavaFx, name: AppConstants.strings.LAVA, previewColor: Colors.redAccent),
        EffectEntity(id: cloudsFx, name: AppConstants.strings.CLOUDS, previewColor: Colors.blueAccent),
        EffectEntity(id: forestFx, name: AppConstants.strings.FOREST, previewColor: Colors.green),
        EffectEntity(id: oceanFx, name: AppConstants.strings.OCEAN, previewColor: Colors.blue[700]!),
        EffectEntity(id: sparklesFx, name: AppConstants.strings.SPARKLES, previewColor: Colors.lightBlue),
        EffectEntity(id: rainboxFx, name: AppConstants.strings.RAINBOW, previewColor: Colors.purple),
        EffectEntity(id: fireFx, name: AppConstants.strings.FIRE, previewColor: Colors.red[800]!),
      ];
}
