import 'package:flutter/foundation.dart';
import 'package:flutter_mqtt/flutter_mqtt.dart';
import 'package:flutter_mqtt_example/src/core/flavor/flavor_config.dart';
import 'package:flutter_mqtt_example/src/util/shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

@pragma('vm:entry-point')
void onReceivedNotification(NotificationResponse notificationResponse) {
  Get.find<NotificationService>().recentNotification.value = notificationResponse.payload;
}

class NotificationService {
  final _plugin = FlutterMqttPlugin();

  ValueNotifier<String?> recentNotification = ValueNotifier(null);

  Future<void> initialize() async {
    recentNotification.value =
        await SharedPreference.read(SharedPreference.KEY_RECENT_NOTIFICATION);

    _plugin.initialize(
      FlavorConfig.instance.values.initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        recentNotification.value = details.payload;
      },
      onDidReceiveBackgroundNotificationResponse: onReceivedNotification,
    );
  }

  Future<void> cancelAll() async {
    _plugin.cancelAll();
  }
}
