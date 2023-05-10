import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mqtt/flutter_mqtt.dart';
import 'package:flutter_mqtt_example/src/core/flavor/flavor_config.dart';
import 'package:flutter_mqtt_example/src/util/shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

@pragma('vm:entry-point')
void onReceivedBackgroundNotification(
    NotificationResponse notificationResponse) async {
  // NotificationService.onReceivedNotification(notificationResponse);
}

class NotificationService extends GetxService {
  final _plugin = FlutterMqttPlugin();

  ValueNotifier<String?> recentNotification = ValueNotifier(null);

  Future<void> initialize() async {
    _plugin.initialize(
      FlavorConfig.instance.values.initializationSettings,
      onDidReceiveNotificationResponse: _onReceivedNotification,
      onDidReceiveBackgroundNotificationResponse:
          onReceivedBackgroundNotification,
    );

    _plugin.onReceivedNotification().listen((notificationResponse) {
      _onReceivedNotification(notificationResponse);
    });
  }

  void _onReceivedNotification(NotificationResponse? details) async {
    await SharedPreference.write(
        SharedPreference.KEY_RECENT_NOTIFICATION, details?.payload);
    recentNotification.value = details?.payload;
  }

  Future<void> cancelAll() async {
    _plugin.cancelAll();
  }
}
