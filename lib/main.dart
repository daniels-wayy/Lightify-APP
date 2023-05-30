import 'dart:async';
import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lightify/di/di.dart';
import 'package:lightify/di/services/debug_print_service.dart';
import 'package:lightify/lightify_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  configureDependencies();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  debugPrint = getIt<DebugPrintService>().debugPrint;

  runZonedGuarded(() {
    FlutterError.onError = _recordFlutterError;
    runApp(
      const RootRestorationScope(
        restorationId: 'root',
        child: LightifyApp(),
      ),
    );
  }, _recordZoneError);
}

void _recordFlutterError(FlutterErrorDetails details) {
  debugPrint('_recordFlutterError: ${details.toString()}');
  FirebaseCrashlytics.instance.recordFlutterError(details);
}

void _recordZoneError(Object error, StackTrace? stack) {
  log('Uncaught error', error: error, stackTrace: stack);
  FirebaseCrashlytics.instance.recordFlutterError(FlutterErrorDetails(exception: error, stack: stack));
}
