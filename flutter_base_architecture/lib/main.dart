import 'package:flutter/material.dart';
import 'package:flutter_architecture/src/app.dart';
import 'package:flutter_architecture/src/config/hive_config.dart';
import 'package:flutter_architecture/src/config/service_locator.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  setupLocator();
  await Hive.initFlutter();
  registerAdapter();
  await openBoxes();
  runApp(App());
}
