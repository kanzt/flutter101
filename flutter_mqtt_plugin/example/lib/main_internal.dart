import 'package:flutter_mqtt_plugin/entity/connection_setting.dart';
import 'package:flutter_mqtt_plugin/entity/initialization_settings.dart';
import 'package:flutter_mqtt_plugin/entity/notification_settings.dart';
import 'package:flutter_mqtt_plugin_example/main.dart';
import 'package:flutter_mqtt_plugin_example/src/core/flavor/flavor_config.dart';

void main() {
  FlavorConfig(
    flavor: Flavor.INTERNAL,
    values: FlavorValues(
      baseURL: "http://172.20.10.5:8080/api/v1/",
      initializationSettings: InitializationSettings(
          connectionSetting: ConnectionSetting(
            isRequiredSsl: false,
            hostname: "172.20.10.5",
            password: "mqtt-mobile",
            username: "mqtt-mobile",
          ),
          notificationSettings: NotificationSettings(
            androidNotificationSetting: AndroidNotificationSetting(
              channelId: 'push_notification',
              channelName: 'Push notification',
              notificationIcon: 'notification_icon',
            ),
          )),
    ),
  );

  entrypoint();
}
