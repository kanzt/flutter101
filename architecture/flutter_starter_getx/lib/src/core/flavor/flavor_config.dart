
import 'package:flutter_starter/src/core/flavor/string_utils.dart';

enum Flavor { DEV, PRD }

class FlavorValues {
  FlavorValues();
}

class FlavorConfig {
  final Flavor flavor;
  final String name;
  final FlavorValues values;

  static late FlavorConfig _instance;

  factory FlavorConfig({required Flavor flavor,
      required FlavorValues values}) {
    _instance = FlavorConfig._internal(
        flavor, StringUtils.enumName(flavor.toString()), values);
    return _instance;
  }

  FlavorConfig._internal(this.flavor, this.name, this.values);

  static FlavorConfig get instance {
    return _instance;
  }

  static bool isProduction() => _instance.flavor == Flavor.PRD;

  static bool isDevelopment() => _instance.flavor == Flavor.DEV;
}
