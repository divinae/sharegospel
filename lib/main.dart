import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sharegospel/src/resources/consts.dart';
import 'package:sharegospel/src/ui/data/personal_shares.dart';
import 'package:sharegospel/src/utils/logger.dart';
import 'generated/codegen_loader.g.dart';
import 'src/app.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'dart:async';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await EasyLocalization.ensureInitialized();
  await Hive.initFlutter();

  await Hive.openBox(USER_DATA_BOX_KEY);
  Hive.registerAdapter(PersonalSharesAdapter());
  await Hive.openBox<PersonalShares>(SHARES_BOX_KEY);

  if (!kIsWeb) {
    await FirebaseCrashlytics.instance
        .setCrashlyticsCollectionEnabled(!kDebugMode);
  }

  runZonedGuarded(
    () {
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
    },
    (error, stackTrace) {
      logger.e(
          "runZonedGuarded: Caught error in my root zone.", error, stackTrace);
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(error, stackTrace);
      }
    },
  );
}
