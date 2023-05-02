import 'package:flutter_mqtt_plugin/entity/initialization_settings.dart';
import 'package:flutter_mqtt_plugin_example/src/core/flavor/string_utils.dart';

enum Flavor { LOCAL, INTERNAL, EXTERNAL }

class FlavorValues {
  final String baseURL;
  final InitializationSettings initializationSettings;

  FlavorValues({
    required this.baseURL,
    required this.initializationSettings,
  });
}

class FlavorConfig {
  final Flavor flavor;
  final String name;
  final FlavorValues values;

  static late FlavorConfig _instance;

  factory FlavorConfig({required Flavor flavor, required FlavorValues values}) {
    _instance = FlavorConfig._internal(
        flavor, StringUtils.enumName(flavor.toString()), values);
    return _instance;
  }

  FlavorConfig._internal(this.flavor, this.name, this.values);

  static FlavorConfig get instance {
    return _instance;
  }

  static bool isLocal() => _instance.flavor == Flavor.LOCAL;

  static bool isInternal() => _instance.flavor == Flavor.INTERNAL;

  static bool isExternal() => _instance.flavor == Flavor.EXTERNAL;
}
