import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'generated/codegen_loader.g.dart';
import 'src/app.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'dart:async';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  if (!kIsWeb) {
    await FirebaseCrashlytics.instance
        .setCrashlyticsCollectionEnabled(!kDebugMode);
  }

  runZonedGuarded(() {
    runApp(
      EasyLocalization(
        supportedLocales: [Locale('en'), Locale('pl'), Locale('ru')],
        path: 'assets/translations',
        fallbackLocale: Locale('en'),
        saveLocale: true,
        assetLoader: CodegenLoader(),
        child: MyApp(),
      ),
    );
  }, (error, stackTrace) {
    print('runZonedGuarded: Caught error in my root zone.');
    if (!kIsWeb) {
      FirebaseCrashlytics.instance.recordError(error, stackTrace);
    }
  });
}
