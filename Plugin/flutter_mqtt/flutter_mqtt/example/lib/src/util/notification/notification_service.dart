import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
      SharedPreference.KEY_RECENT_NOTIFICATION, notificationResponse?.payload);
  FlutterAppBadger.updateBadgeCount(50);
  print("Accept message : ${notificationResponse.payload}");
}

class NotificationService extends GetxService {
  final _plugin = FlutterMqttPlugin();

  ValueNotifier<String?> recentNotification = ValueNotifier(null);
  ValueNotifier<String?> selectedNotification = ValueNotifier(null);

  Future<void> initialize() async {
    final NotificationAppLaunchDetails? notificationAppLaunchDetails =
        await _plugin.getNotificationAppLaunchDetails();

    if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
      _onOpenedNotification(notificationAppLaunchDetails?.notificationResponse);
    }

    recentNotification.value =
        await SharedPreference.read(SharedPreference.KEY_RECENT_NOTIFICATION);

    _plugin.initialize(
      FlavorConfig.instance.values.initializationSettings,
      onDidReceiveNotificationResponse: _onReceivedNotification,
      onOpenedNotification: _onOpenedNotification,
      onDidReceiveBackgroundNotificationResponse:
          onReceivedBackgroundNotification,
    );

  }

  void _onOpenedNotification(NotificationResponse? details) async {
    selectedNotification.value = details?.payload;
    Get.toNamed(Routes.notificationDetailPage);
  }

  void _onReceivedNotification(NotificationResponse? details) async {
    await SharedPreference.write(
        SharedPreference.KEY_RECENT_NOTIFICATION, details?.payload);
    recentNotification.value = details?.payload;
    FlutterAppBadger.updateBadgeCount(50);
  }

  Future<void> cancelAll() async {
    _plugin.cancelAll();
  }
}
