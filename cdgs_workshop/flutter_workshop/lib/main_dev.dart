
import 'package:flutter_workshop/src/core/config/flavor/flavor_config.dart';

import 'main.dart';

void main() {
  FlavorConfig(
      flavor: Flavor.DEV,
      values: FlavorValues(
        baseUrl: '',
        googleMapBaseUrl: "https://maps.googleapis.com/maps/api/directions/json?",
      ));

  mainApp();
}