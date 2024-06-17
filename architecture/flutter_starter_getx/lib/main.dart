import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_starter/src/core/config/routes.dart';
import 'package:flutter_starter/src/core/di.dart';
import 'package:flutter_starter/src/resource/color/color_assets.dart';
import 'package:flutter_starter/src/resource/language/localizations_delegate.dart';
import 'package:flutter_starter/src/resource/theme/theme.dart';
import 'package:flutter_starter/src/util/notificattion/fcm_service.dart';

import 'package:get/get.dart';

void App() async {
  unawaited(runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    // await Firebase.initializeApp();
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // DI
    await initCoreDI();
    runApp(MyApp());
    // FCM
    // await PushNotificationService().setupInteractedMessage();
  }, (exception, stackTrace)  {

  }));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      localizationsDelegates: [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('th', 'TH'),
      ],
      locale: const Locale('th', 'TH'),
      localeResolutionCallback: (locale, supportedLocales) {
        return supportedLocales.first;
      },
      theme: ThemeData(
        primarySwatch: AppTheme.kAppThemeSwatch,
        scaffoldBackgroundColor: ColorAssets.whiteSmoke2,
      ),
      initialRoute: Routes.rootPage,
      getPages: Routes.getRoute(),
    );
  }
}
