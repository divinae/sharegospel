import 'package:flutter/material.dart';
import 'src/app.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'dart:async';

void main() {
  // Pass all uncaught errors from the framework to Crashlytics.
  FlutterError.onError = Crashlytics.instance.recordFlutterError;

  runZoned(() {
    runApp(MyApp());
  }, onError: Crashlytics.instance.recordError);
}
