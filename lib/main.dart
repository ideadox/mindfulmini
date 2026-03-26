import 'dart:ui';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:mindfulminis/core/injection/injection.dart';
import 'package:mindfulminis/core/services/auth_service.dart';
import 'firebase_options.dart';
import 'package:mindfulminis/mindfulminis_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize the Branch SDK first
  await FlutterBranchSdk.init();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Capture Flutter framework errors
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  // Capture uncaught asynchronous errors
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Setup dependency injection
  await setupInjection();
  await sl.allReady();

  // Initialize auth service (lightweight check + auth-state listener)
  await sl<AuthService>().initialize();

  runApp(const MindfulminisApp());
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}
