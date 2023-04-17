import 'package:flutter_mqtt_plugin_example/main.dart';
import 'package:flutter_mqtt_plugin_example/src/core/flavor/flavor_config.dart';

void main() {
  FlavorConfig(
    flavor: Flavor.LOCAL,
    values: FlavorValues(
      baseURL: "http://10.0.2.2:8080/api/v1/",
      hostName: '10.0.2.2',
      password: 'mqtt-mobile',
      userName: 'mqtt-mobile',
      isRequiredSSL: false,
    ),
  );

  entrypoint();
}
