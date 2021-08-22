import 'package:flutter/material.dart';
import 'package:flutter_architecture/src/config/app_route.dart';
import 'package:flutter_architecture/src/config/service_locator.dart';
import 'package:flutter_architecture/src/pages/login/login_page.dart';

class App extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: locator<NavigationService>().navigatorKey,
      routes: appRoute.route,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}