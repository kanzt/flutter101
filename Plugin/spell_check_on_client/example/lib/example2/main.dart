import 'package:example/example2/page.dart';
import 'package:flutter/material.dart';

/**
 * https://medium.com/@southxzx/implement-a-simple-spell-checker-system-in-flutter-37b2bd0d63b4
 */
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const TestPage());
  }
}