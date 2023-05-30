import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lightify/core/ui/utils/colors_util.dart';

part 'color_preset.g.dart';

@JsonSerializable()
class ColorPreset {
  @JsonKey(toJson: _colorToJson, fromJson: _colorFromJson)
  final HSVColor color;
  final String colorName;

  @JsonKey(includeFromJson: false, includeToJson: false)
  final bool isDefault;

  const ColorPreset({required this.color, required this.colorName, this.isDefault = false});

  ColorPreset.empty()
      : color = HSVColor.fromColor(Colors.red),
        isDefault = false,
        colorName = '';

  factory ColorPreset.fromJson(Map<String, dynamic> json) => _$ColorPresetFromJson(json);

  Map<String, dynamic> toJson() => _$ColorPresetToJson(this);

  Color get getRawColor => color.toColor();
}

dynamic _colorToJson(HSVColor? color) {
  final json = <String, dynamic>{};
  if (color != null) {
    json['color'] = ColorsUtil.encodeColor(color.toColor());
  }
  return json;
}

dynamic _colorFromJson(Map<String, dynamic> json) {
  final val = json['color'] as String?;
  if (val != null) {
    return HSVColor.fromColor(ColorsUtil.decodeColor(val));
  }
}
