import 'package:flutter/foundation.dart';
import 'package:flutter_mqtt_plugin/entity/initialization_settings.dart';
import 'package:flutter_mqtt_plugin/flutter_mqtt_plugin.dart';
import 'package:flutter_mqtt_plugin_example/src/core/config/routes.dart';
import 'package:flutter_mqtt_plugin_example/src/util/shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

abstract class NotificationService {
  Future<void> initialize({InitializationSettings? settings});

  Future<bool?> disconnect();

  Future<bool> checkPendingNotification();

  final ValueNotifier<String?> recentNotification =
      ValueNotifier<String?>(null);
}

class IOSNotificationService implements NotificationService {
  final _plugin = FlutterMqttPlugin();

  @override
  ValueNotifier<String?> recentNotification = ValueNotifier(null);

  @override
  Future<void> initialize({InitializationSettings? settings}) async {
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
      if (kDebugMode) {
        print("Notification payload (Flutter) : $event");
      }
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
  @override
  Future<bool> checkPendingNotification() async {
    final pendingNotification = await _plugin.getPendingNotification();
    if (pendingNotification != null) {
      try {
        final notification = pendingNotification.split("|").last;
        if (kDebugMode) {
          print("checkInitialNotification : $notification");
        }
        SharedPreference.write(
            SharedPreference.KEY_RECENT_NOTIFICATION, notification);
        recentNotification.value = notification;
        return true;
      } on Exception catch (e) {
        if (kDebugMode) {
          print("checkInitialNotification : $pendingNotification");
        }
        SharedPreference.write(
            SharedPreference.KEY_RECENT_NOTIFICATION, pendingNotification);
        recentNotification.value = pendingNotification;
        return true;
      }
    }
    return false;
  }

  @override
  Future<bool?> disconnect() async {
    return true;
  }
}

class AndroidNotificationService implements NotificationService {
  final _plugin = FlutterMqttPlugin();

  @override
  ValueNotifier<String?> recentNotification = ValueNotifier(null);

  @override
  Future<void> initialize({InitializationSettings? settings}) async {
    if (settings != null) {
      _plugin.connectMQTT(settings);
    } else {
      throw Exception("Android platform required InitializationSettings");
    }

    /// Received notification in foreground
    _plugin.onReceivedNotification().listen((event) async {
      if (kDebugMode) {
        print("Notification payload (Flutter) : $event");
      }
      SharedPreference.write(SharedPreference.KEY_RECENT_NOTIFICATION, event);
      recentNotification.value = event;
    });

    /// Application business
    recentNotification.value =
        await SharedPreference.read(SharedPreference.KEY_RECENT_NOTIFICATION);
  }

  @override
  Future<bool> checkPendingNotification() {
    // TODO: implement checkPendingNotification
    return Future.value(false);
  }

  @override
  Future<bool?> disconnect() async {
    return _plugin.disconnectMQTT();
  }
}
