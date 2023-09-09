import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lightify/di/di.dart';
import 'package:lightify/di/services/debug_print_service.dart';
import 'package:lightify/lightify_app.dart';

Future<void> run() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  await Firebase.initializeApp();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  debugPrint = getIt<DebugPrintService>().debugPrint;

  FlutterError.onError = _recordFlutterError;
  PlatformDispatcher.instance.onError = _recordZoneError;

  runApp(
    const RootRestorationScope(
      restorationId: 'root',
      child: LightifyApp(),
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
