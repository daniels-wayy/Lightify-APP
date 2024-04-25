// ignore_for_file: prefer_function_declarations_over_variables, constant_identifier_names

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lightify/core/ui/routes/custom_page_routes.dart';
import 'package:lightify/di/di.dart';
import 'package:lightify/pages/device_details/domain/model/device_details_page_args.dart';
import 'package:lightify/pages/device_details/ui/cubit/device_workflows_cubit.dart';
import 'package:lightify/pages/device_details/ui/device_details_page.dart';
import 'package:lightify/pages/device_settings/domain/args/device_settings_page_args.dart';
import 'package:lightify/pages/device_settings/ui/cubit/device_settings_cubit.dart';
import 'package:lightify/pages/device_settings/ui/device_settings_page.dart';
import 'package:lightify/pages/main/main/ui/bloc/main_cubit.dart';
import 'package:lightify/pages/main/main/ui/main_page.dart';
import 'package:lightify/pages/workflow_form/domain/args/workflow_form_page_args.dart';
import 'package:lightify/pages/workflow_form/ui/cubit/workflow_form_cubit.dart';
import 'package:lightify/pages/workflow_form/ui/workflow_form_page.dart';

class Routes {
  static const String MAIN = 'MainPage';
  static const String DEVICE_DETAILS = 'DeviceDetailsPage';
  static const String DEVICE_SETTINGS = 'DeviceSettingsPage';
  static const String WORKFLOW_FORM = 'WorkflowFormPage';
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
        return CrossFadeScalePageRoute(
          settings: settings,
          builder: (_) => BlocProvider(
            create: (_) => getIt<DeviceWorkflowsCubit>(
              param1: args.deviceInfo.topic,
            ),
            child: DeviceDetailsPage(args: args),
          ),
        );
      } else {
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => BlocProvider(
            create: (_) => getIt<DeviceWorkflowsCubit>(
              param1: args.deviceInfo.topic,
            ),
            child: DeviceDetailsPage(args: args),
          ),
        );
      }
    case Routes.DEVICE_SETTINGS:
      final args = settings.arguments as DeviceSettingsPageArgs;
      if (Platform.isAndroid) {
        return CrossFadeScalePageRoute(
          settings: settings,
          builder: (_) => BlocProvider(
            create: (_) => getIt<DeviceSettingsCubit>(),
            child: DeviceSettingsPage(args: args),
          ),
        );
      } else {
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => BlocProvider(
            create: (_) => getIt<DeviceSettingsCubit>(),
            child: DeviceSettingsPage(args: args),
          ),
        );
      }
    case Routes.WORKFLOW_FORM:
      final args = settings.arguments as WorkflowFormPageArgs;
      if (Platform.isAndroid) {
        return CrossFadeScalePageRoute<Object>(
          settings: settings,
          builder: (_) => BlocProvider(
            create: (_) => getIt<WorkflowFormCubit>(
              param1: args.workflow,
              param2: args.currentDevice,
            ),
            child: WorkflowFormPage(args: args),
          ),
        );
      } else {
        return MaterialPageRoute<Object>(
          settings: settings,
          builder: (_) => BlocProvider(
            create: (_) => getIt<WorkflowFormCubit>(
              param1: args.workflow,
              param2: args.currentDevice,
            ),
            child: WorkflowFormPage(args: args),
          ),
        );
      }
    default:
      throw 'Root Unknown route ${settings.name}';
  }
};
