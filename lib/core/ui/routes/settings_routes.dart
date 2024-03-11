// ignore_for_file: prefer_function_declarations_over_variables, constant_identifier_names

import 'package:flutter/material.dart';
import 'package:lightify/pages/main/settings/home_widgets/ui/home_widgets_page.dart';
import 'package:lightify/pages/main/settings/settings/ui/settings_page.dart';

class SettingsRoutes {
  static const String SETTINGS = 'SettingsPage';
  static const String HOME_WIDGETS_PAGE = 'HomeWidgetsPage';
}

final RouteFactory settingsRouteFactory = (RouteSettings settings) {
  switch (settings.name) {
    case SettingsRoutes.SETTINGS:
      return MaterialPageRoute<void>(
        settings: settings,
        builder: (_) => const SettingsPage(),
      );
    case SettingsRoutes.HOME_WIDGETS_PAGE:
      return MaterialPageRoute<void>(
        settings: settings,
        builder: (_) => const HomeWidgetsPage(),
      );
    default:
      throw 'Settings Unknown route ${settings.name}';
  }
};
