import 'package:flutter/material.dart';
import 'package:flutter101/src/pages/pages.dart';
// import 'package:flutter101/src/pages/pages.dart' show LoginPage; /// import เฉพาะ LoginPage


class AppRoute{
  static const homeRoute = "home";
  static const loginRoute = "login";
  static const managementRoute = "management";

  final _route = <String,WidgetBuilder> {
    homeRoute: (context) => HomePage(),
    loginRoute: (context) => LoginPage(),
    managementRoute: (context) => ManagementPage(),
  };
  get route => _route;
}