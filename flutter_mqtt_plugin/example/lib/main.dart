import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mqtt_plugin_example/src/core/config/routes.dart';
import 'package:flutter_mqtt_plugin_example/src/core/di.dart';
import 'package:flutter_mqtt_plugin_example/src/resources/theme/theme.dart';
import 'package:flutter_mqtt_plugin_example/src/util/notification/notification_service.dart';
import 'package:get/get.dart';

void entrypoint() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // DI
  await initCoreDI();

  // Push notification
  await NotificationService.initialized();

  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        primarySwatch: AppTheme.kAppThemeSwatch,
      ),
      initialRoute: Routes.rootPage,
      getPages: Routes.getRoute(),
    );
  }
}
