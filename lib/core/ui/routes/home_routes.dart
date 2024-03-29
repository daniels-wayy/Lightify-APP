// ignore_for_file: prefer_function_declarations_over_variables, constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lightify/di/di.dart';
import 'package:lightify/pages/main/home/ui/devices_updater/devices_updater_bloc.dart';
import 'package:lightify/pages/main/home/ui/home_page.dart';

class HomeRoutes {
  static const String HOME = 'HomePage';
}

final RouteFactory homeRouteFactory = (RouteSettings settings) {
  switch (settings.name) {
    case HomeRoutes.HOME:
      return MaterialPageRoute<void>(
        settings: settings,
        builder: (_) => MultiBlocProvider(
          providers: [
            // BlocProvider(create: (_) => getIt<DevicesWatcherBloc>()),
            BlocProvider(create: (_) => getIt<DevicesUpdaterBloc>()),
          ],
          child: const HomePage(),
        ),
      );
    default:
      throw 'Home Unknown route ${settings.name}';
  }
};
