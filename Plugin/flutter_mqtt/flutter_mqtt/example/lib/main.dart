import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mqtt_example/src/core/config/routes.dart';
import 'package:flutter_mqtt_example/src/core/di.dart';
import 'package:flutter_mqtt_example/src/core/flavor/flavor_config.dart';
import 'package:flutter_mqtt_example/src/resources/theme/theme.dart';
import 'package:flutter_mqtt_example/src/util/notification/notification_service.dart';
import 'package:get/get.dart';

void entrypoint() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // DI
  await initCoreDI();

  // Get APNs token for Notification in iOS
  if(Platform.isIOS){
    Get.find<NotificationService>().getAPNSToken(
      FlavorConfig.instance.values.initializationSettings
    );
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
