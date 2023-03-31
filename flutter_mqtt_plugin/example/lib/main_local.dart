import 'package:flutter_mqtt_plugin_example/main.dart';
import 'package:flutter_mqtt_plugin_example/src/core/flavor/flavor_config.dart';

void main() {
  FlavorConfig(
    flavor: Flavor.LOCAL,
    values: FlavorValues(
      baseURL: "http://localhost:8080/api/v1/",
    ),
  );

  entrypoint();
}
