// ignore_for_file: prefer_function_declarations_over_variables, constant_identifier_names

import 'package:flutter/material.dart';
import 'package:lightify/pages/main/settings/ui/settings_page.dart';

class SettingsRoutes {
  static const String SETTINGS = 'SettingsPage';
}

final RouteFactory settingsRouteFactory = (RouteSettings settings) {
  switch (settings.name) {
    case SettingsRoutes.SETTINGS:
      return MaterialPageRoute<void>(
        settings: settings,
        builder: (_) => const SettingsPage(),
      );
    default:
      throw 'Settings Unknown route ${settings.name}';
  }
};
