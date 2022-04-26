import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sharegospel/src/resources/consts.dart';
import 'bloc/add_share_bloc.dart';
import 'ui/home_page.dart';

class MyApp extends StatelessWidget {
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      systemNavigationBarColor: Colors.white,
    ));
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      title: APP_TITLE,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.lightBlue,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      home: BlocProvider(
        create: (BuildContext context) => AddShareBloc(),
        child: HomePage(
          analytics: analytics,
        ),
      ),
    );
  }
}
