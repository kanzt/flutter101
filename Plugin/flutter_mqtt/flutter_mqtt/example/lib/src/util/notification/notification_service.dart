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
  // TODO : เปลี่ยนให้เป็นฟังก์ชันจัดการเมื่อได้รับ Notification ขณะอยู่ใน Terminated state
  print("onReceivedBackgroundNotification is working...");
}

class NotificationService extends GetxService {
  final _plugin = FlutterMqttPlugin();

  ValueNotifier<String?> recentNotification = ValueNotifier(null);
  ValueNotifier<String?> selectedNotification = ValueNotifier(null);

  Future<void> initialize() async {
    _plugin.initialize(
      FlavorConfig.instance.values.initializationSettings,
      onDidReceiveNotificationResponse: _onReceivedNotification,
      onOpenedNotification: _onOpenedNotification,
      onDidReceiveBackgroundNotificationResponse:
          onReceivedBackgroundNotification,
    );

    // TODO : ถ้า MethodChannel สามารถสั่งอัพเดท UI ได้จะลบบรรทัดนี้ออก
    // _plugin.onReceivedNotification().listen((notificationResponse) {
    //   _onReceivedNotification(notificationResponse);
    // });
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
