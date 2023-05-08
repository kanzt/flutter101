import 'package:flutter_mqtt/flutter_mqtt.dart';
import 'package:flutter_mqtt_example/main.dart';
import 'package:flutter_mqtt_example/src/core/flavor/flavor_config.dart';

void main() {
  FlavorConfig(
    flavor: Flavor.INTERNAL,
    values: FlavorValues(
      baseURL: "http://172.20.10.2:8080/api/v1/",
      initializationSettings: InitializationSettings(
        android: AndroidInitializationSettings(
            mqttConnectionSetting: MQTTConnectionSetting(
              isRequiredSsl: false,
              hostname: "172.20.10.2",
              password: "mqtt-mobile",
              username: "mqtt-mobile",
            ),
            platformNotificationSetting: const PlatformNotificationSetting(
              channelId: 'push_notification',
              channelName: 'Push notification',
              notificationIcon: 'ic_notification',
            )),
      ),
    ),
  );

  entrypoint();
}
