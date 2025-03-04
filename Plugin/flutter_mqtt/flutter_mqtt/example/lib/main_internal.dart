import 'package:flutter_mqtt/flutter_mqtt.dart';
import 'package:flutter_mqtt_example/main.dart';
import 'package:flutter_mqtt_example/src/core/flavor/flavor_config.dart';
import 'package:flutter/material.dart';

void main() {
  FlavorConfig(
    flavor: Flavor.INTERNAL,
    values: FlavorValues(
      baseURL: "http://192.168.1.120:8080/api/v1/",
      initializationSettings: InitializationSettings(
        android: AndroidInitializationSettings(
          mqttConnectionSetting: MQTTConnectionSetting(
            isRequiredSsl: false,
            hostname: "192.168.1.120",
            password: "mqtt-mobile",
            username: "mqtt-mobile",
          ),
          platformNotificationSetting: const PlatformNotificationSetting(
              channelId: 'push_notification',
              channelName: 'Push notification',
              notificationIcon: 'ic_notification',
              actions: [
                AndroidNotificationAction(
                  'id_1',
                  'Action 1',
                  icon: DrawableResourceAndroidBitmap('food'),
                  contextual: true,
                ),
                AndroidNotificationAction(
                  'id_2',
                  'Action 2',
                  titleColor: Color.fromARGB(255, 255, 0, 0),
                  icon: DrawableResourceAndroidBitmap('food'),
                ),
                AndroidNotificationAction(
                  'id_3',
                  'Action 3',
                  cancelNotification: false,
                ),
              ]),
        ),
        iOS: DarwinInitializationSettings(
          notificationCategories: [
            DarwinNotificationCategory(
              "plainCategory",
              actions: <DarwinNotificationAction>[
                DarwinNotificationAction.plain(
                  'id_1',
                  'Action 1',
                  options: {
                    DarwinNotificationActionOption.foreground,
                    DarwinNotificationActionOption.authenticationRequired
                  }
                ),
                DarwinNotificationAction.plain(
                    'id_2',
                    'Action 2',
                    options: {
                      DarwinNotificationActionOption.foreground,
                      DarwinNotificationActionOption.authenticationRequired
                    }
                ),
                DarwinNotificationAction.plain(
                    'id_3',
                    'Dismiss',
                    options: {
                      DarwinNotificationActionOption.destructive,
                    }
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );

  entrypoint();
}
