import 'package:flutter/cupertino.dart';
import 'package:flutter_mqtt_plugin/flutter_mqtt_plugin.dart';
import 'package:flutter_mqtt_plugin_example/src/core/config/routes.dart';
import 'package:flutter_mqtt_plugin_example/src/util/shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

abstract class NotificationService {
  Future<void> initialize();
  Future<bool> checkPendingNotification();
  final recentNotification = ValueNotifier<String?>(null);
}

class IOSNotificationService implements NotificationService {
  final _plugin = FlutterMqttPlugin();

  @override
  ValueNotifier<String?> get recentNotification => ValueNotifier<String?>(null);

  @override
  Future<void> initialize() async {
    recentNotification.value =
        await SharedPreference.read(SharedPreference.KEY_RECENT_NOTIFICATION);

    /// Get Notification token
    _plugin.getToken().listen((event) {
      SharedPreference.write(
        SharedPreference.KEY_TOKEN,
        event,
      );
    });

    /// Received notification in foreground
    _plugin.onReceivedNotification().listen((event) {
      print("Notification payload (Flutter) : $event");
      SharedPreference.write(SharedPreference.KEY_RECENT_NOTIFICATION, event);
      recentNotification.value = event;
    });

    _plugin.onOpenedNotification().listen((event) {
      if (Get.currentRoute != Routes.rootPage) {
        Get.toNamed(Routes.notificationDetailPage);
      } else {
        Get.offAllNamed(Routes.consumerNoAnimPage);
        Get.toNamed(Routes.notificationDetailPage);
      }
    });
  }

  /// Received notification in background & terminated
  /// We need to check it manually in ApplicationLifecycleController@onResumed
  Future<bool> checkPendingNotification() async {
    final pendingNotification = await _plugin.getPendingNotification();
    if (pendingNotification != null) {
      try {
        final notification = pendingNotification.split("|").last;
        print("checkInitialNotification : $notification");
        SharedPreference.write(
            SharedPreference.KEY_RECENT_NOTIFICATION, notification);
        recentNotification.value = notification;
        return true;
      } on Exception catch (e) {
        print("checkInitialNotification : $pendingNotification");
        SharedPreference.write(
            SharedPreference.KEY_RECENT_NOTIFICATION, pendingNotification);
        recentNotification.value = pendingNotification;
        return true;
      }
    }
    return false;
  }
}

class AndroidNotificationService implements NotificationService {
  final _plugin = FlutterMqttPlugin();

  @override
  ValueNotifier<String?> get recentNotification => ValueNotifier<String?>(null);

  @override
  Future<void> initialize() async {
    recentNotification.value =
        await SharedPreference.read(SharedPreference.KEY_RECENT_NOTIFICATION);

    /// Received notification in foreground
    _plugin.onReceivedNotification().listen((event) {
      print("Notification payload (Flutter) : $event");
      SharedPreference.write(SharedPreference.KEY_RECENT_NOTIFICATION, event);
      recentNotification.value = event;
    });
  }
}