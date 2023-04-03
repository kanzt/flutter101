import 'package:flutter/cupertino.dart';
import 'package:flutter_mqtt_plugin/flutter_mqtt_plugin.dart';
import 'package:flutter_mqtt_plugin_example/src/core/config/routes.dart';
import 'package:flutter_mqtt_plugin_example/src/util/shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

class NotificationService {
  static final _plugin = FlutterMqttPlugin();
  static final recentNotification = ValueNotifier<String?>(null);
  static final recentOpenNotification = ValueNotifier<String?>(null);

  static Future<void> initialized() async {
    _plugin.getToken().listen((event) {
      SharedPreference.write(
        SharedPreference.KEY_TOKEN,
        event,
      );
    });

    _plugin.onReceivedNotification().listen((event) {
      print("Notification payload (Flutter) : ${event}");
      recentNotification.value = event;
    });

    _plugin.onOpenedNotification().listen((event) {
      recentOpenNotification.value = event;
      Get.toNamed(Routes.notificationDetailPage);
    });
  }

  static Future<bool> checkInitialNotification() async {
    final initialNotification = await _plugin.initialNotification();
    if (initialNotification != null) {
      try {
        final notification = initialNotification.split("|").last;
        print("checkInitialNotification : $notification");
        recentNotification.value = notification;
        return true;
      } on Exception catch (e) {
        print("checkInitialNotification : $initialNotification");
        recentNotification.value = initialNotification;
        return true;
      }
    }
    return false;
  }
}
