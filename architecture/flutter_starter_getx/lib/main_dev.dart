
import 'package:flutter_starter/main.dart';
import 'package:flutter_starter/src/core/flavor/flavor_config.dart';

void main(){
  FlavorConfig(
    flavor: Flavor.DEV,
    values: FlavorValues(
    ),
  );

  App();
}