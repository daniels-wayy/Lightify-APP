import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lightify/core/data/model/color_preset.dart';
import 'package:lightify/core/data/model/device_info.dart';
import 'package:lightify/core/data/model/effect_entity.dart';
import 'package:lightify/core/ui/utils/screen_util.dart';

part 'api_constants.dart';
part 'widget_constants.dart';
part 'app_strings.dart';
part 'settings_constants.dart';

class AppConstants {
  const AppConstants._();

  static final api = _ApiConstants();
  static const widget = _WidgetConstants();
  static const strings = _StringsConstants();
  static const settings = _SettingsConstants();
}
