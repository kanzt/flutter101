import 'package:flutter/material.dart';
import 'package:flutter_flavors/main.dart';
import 'package:flutter_flavors/src/config/flavor_config.dart';

void main() {
  FlavorConfig(flavor: Flavor.DEV,
      color: Colors.green,
      values: FlavorValues(baseUrl: "")
  );

  runApp(MyApp());
}