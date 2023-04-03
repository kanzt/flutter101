import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mqtt_plugin_example/src/core/config/routes.dart';
import 'package:flutter_mqtt_plugin_example/src/util/notification/notification_service.dart';
import 'package:flutter_mqtt_plugin_example/src/util/shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(seconds: 3),
            () async {
          final isLogin = await SharedPreference.read(
              SharedPreference.KEY_USER_ID);
          if (isLogin != null) {
            // TODO : ทดสอบ
            final initialNotification = await NotificationService
                .checkInitialNotification();
            if (!initialNotification) {
              Get.offAllNamed(
                Routes.consumerPage,
              );
            }
          } else {
            Get.offAllNamed(
              Routes.loginPage,
            );
          }
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
