import 'dart:io';

import 'package:flutter/foundation.dart';
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
  try {
    if (Platform.isIOS) {
      Get.put<NotificationService>(IOSNotificationService());
    } else if (Platform.isAndroid) {
      Get.put<NotificationService>(AndroidNotificationService());
    }
    await Get.find<NotificationService>().initialize();
  } on Exception catch (e) {
    if (kDebugMode) {
      print(e);
    }
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "Flutter MQTT Sample App",
      theme: ThemeData(
        primarySwatch: AppTheme.kAppThemeSwatch,
      ),
      initialRoute: Routes.rootPage,
      getPages: Routes.getRoute(),
    );
  }
}
