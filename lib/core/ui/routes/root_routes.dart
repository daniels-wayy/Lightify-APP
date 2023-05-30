// ignore_for_file: prefer_function_declarations_over_variables, constant_identifier_names

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lightify/core/ui/routes/custom_page_routes.dart';
import 'package:lightify/di/di.dart';
import 'package:lightify/pages/device_details/domain/model/device_details_page_args.dart';
import 'package:lightify/pages/device_details/ui/device_details_page.dart';
import 'package:lightify/pages/main/main/ui/bloc/main_cubit.dart';
import 'package:lightify/pages/main/main/ui/main_page.dart';

class Routes {
  static const String MAIN = 'MainPage';
  static const String DEVICE_DETAILS = 'DeviceDetailsPage';
}

final RouteFactory rootRouteFactory = (RouteSettings settings) {
  switch (settings.name) {
    case Routes.MAIN:
      return MaterialPageRoute<void>(
        settings: settings,
        builder: (_) => BlocProvider(
          create: (_) => getIt<MainCubit>(),
          child: const MainPage(),
        ),
      );
    case Routes.DEVICE_DETAILS:
      final args = settings.arguments as DeviceDetailsPageArgs;
      if (Platform.isAndroid) {
        return CustomPageRoutes.fadablePageRoute(
          settings: settings,
          child: DeviceDetailsPage(args: args),
        );
      } else {
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => DeviceDetailsPage(args: args),
        );
      }
    default:
      throw 'Root Unknown route ${settings.name}';
  }
};
