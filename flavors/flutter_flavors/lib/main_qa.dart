import 'package:flutter/material.dart';
import 'package:flutter_flavors/main.dart';
import 'package:flutter_flavors/src/config/flavor_config.dart';

void main() {
  FlavorConfig(flavor: Flavor.QA,
      color: Colors.deepPurpleAccent,
      values: FlavorValues(
          baseUrl: "https://raw.githubusercontent.com/JHBitencourt/ready_to_go/master/lib/json/person_qa.json"
      )
  );

  runApp(MyApp());
}