import 'package:flutter_mqtt_plugin_example/main.dart';
import 'package:flutter_mqtt_plugin_example/src/core/flavor/flavor_config.dart';

void main() {
  FlavorConfig(
    flavor: Flavor.INTERNAL,
    values: FlavorValues(
      baseURL: "http://192.168.1.38:8080/api/v1/",
      userName: "mqtt-mobile",
      password: "mqtt-mobile",
      isRequiredSSL: false,
      hostName: "192.168.1.38",
    ),
  );

  entrypoint();
}
