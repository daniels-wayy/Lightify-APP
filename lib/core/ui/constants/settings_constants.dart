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

  List<EffectEntity> get effects => [
        EffectEntity(id: 0, name: AppConstants.strings.NONE, previewColor: AppColors.gray200),
        EffectEntity(id: 1, name: AppConstants.strings.LAVA, previewColor: Colors.redAccent),
        EffectEntity(id: 2, name: AppConstants.strings.CLOUDS, previewColor: Colors.blueAccent),
        EffectEntity(id: 3, name: AppConstants.strings.FOREST, previewColor: Colors.green),
        EffectEntity(id: 4, name: AppConstants.strings.OCEAN, previewColor: Colors.blue[700]!),
      ];

  //(255, 100, 18)
  //(174, 32, 245)
  //(10, 247, 144)
}
