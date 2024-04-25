import 'dart:developer';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:home_widget/home_widget.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:lightify/core/ui/bloc/home_widgets_config/utils/home_widgets_config.dart';
import 'package:lightify/di/di.dart';
import 'package:lightify/di/services/debug_print_service.dart';
import 'package:lightify/lightify_app.dart';
import 'package:path_provider/path_provider.dart';

Future<void> run() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  await Firebase.initializeApp();

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb ? HydratedStorage.webStorageDirectory : await getApplicationDocumentsDirectory(),
  );

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  debugPrint = getIt<DebugPrintService>().debugPrint;

  FlutterError.onError = _recordFlutterError;
  PlatformDispatcher.instance.onError = _recordZoneError;

  await HomeWidget.setAppGroupId(HomeWidgetsConfig.appGroupId);

  runApp(
    DevicePreview(
      enabled: /*!kReleaseMode*/ false,
      builder: (context) => const RootRestorationScope(
        restorationId: 'root',
        child: LightifyApp(),
      ),
    ),
  );
}

void _recordFlutterError(FlutterErrorDetails details) {
  debugPrint('_recordFlutterError: ${details.toString()}');
  FirebaseCrashlytics.instance.recordFlutterError(details);
}

bool _recordZoneError(Object error, StackTrace? stack) {
  log('Uncaught error', error: error, stackTrace: stack);
  FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
  return true;
}
