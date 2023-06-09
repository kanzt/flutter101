import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_mqtt/flutter_mqtt.dart';
import 'package:flutter_mqtt_example/src/core/config/routes.dart';
import 'package:flutter_mqtt_example/src/core/flavor/flavor_config.dart';
import 'package:flutter_mqtt_example/src/util/shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

@pragma('vm:entry-point')
void onReceivedBackgroundNotification(
    NotificationResponse notificationResponse) async {
  await SharedPreference.write(
      SharedPreference.KEY_RECENT_NOTIFICATION, notificationResponse.payload);
  FlutterAppBadger.updateBadgeCount(25);
  print("Accept message : ${notificationResponse.payload}");
}

@pragma('vm:entry-point')
void onTapActionBackgroundNotification(
    NotificationResponse notificationResponse) async {
  print(
      "Accept onTapActionBackgroundNotification : ${notificationResponse.payload}");
}

class NotificationService extends GetxService {
  final _plugin = FlutterMqttPlugin();

  ValueNotifier<String?> recentNotification = ValueNotifier(null);
  ValueNotifier<String?> selectedNotification = ValueNotifier(null);

  Future<void> initialize() async {
    // TODO : ทดสอบ ฝั่ง iOS พบว่ายังทำงานไม่ถูกต้อง 09/06/2023
    final NotificationAppLaunchDetails? notificationAppLaunchDetails =
        await _plugin.getNotificationAppLaunchDetails();

    print("notificationAppLaunchDetails.didNotificationLaunchApp : ${notificationAppLaunchDetails?.didNotificationLaunchApp}");

    if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
      _onTapNotification(notificationAppLaunchDetails?.notificationResponse);
    }

    recentNotification.value =
        await SharedPreference.read(SharedPreference.KEY_RECENT_NOTIFICATION);

    _plugin.initialize(
      FlavorConfig.instance.values.initializationSettings,
      onDidReceiveNotificationResponse: _onReceivedNotification,
      onDidReceiveBackgroundNotificationResponse:
      onReceivedBackgroundNotification,
      onTapNotification: _onTapNotification,
      onTapActionBackgroundNotification: onTapActionBackgroundNotification,
    );
  }

  void _onTapNotification(NotificationResponse? details) async {
    if (details?.actionId == null) {
      selectedNotification.value = details?.payload;
      Get.toNamed(Routes.notificationDetailPage);
    } else {
      print("Tap action from : ${details?.actionId}");
    }
  }

  void _onReceivedNotification(NotificationResponse? details) async {
    await SharedPreference.write(
        SharedPreference.KEY_RECENT_NOTIFICATION, details?.payload);
    recentNotification.value = details?.payload;
    FlutterAppBadger.updateBadgeCount(50);
    print("Notification payload (Fluter) : ${details?.payload}");
  }

  Future<void> cancelAll() async {
    _plugin.cancelAll();
  }

  void getAPNSToken(InitializationSettings initializationSettings) {
    if(Platform.isIOS){
      _plugin.getAPNSToken(initializationSettings)?.listen((event) {
        SharedPreference.write(
          SharedPreference.KEY_TOKEN,
          event,
        );
      });
    }
  }
}
