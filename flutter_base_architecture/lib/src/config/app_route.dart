import 'package:flutter/material.dart';
import 'package:flutter_architecture/src/pages/pages.dart';

class AppRoute {
  static const homeRoute = "home";
  static const loginRoute = "login";
  static const managementRoute = "management";
  static const listPage = "ListPage";

  get route => _route;

  final _route = <String, WidgetBuilder> {
    homeRoute: (context) => HomePage(),
    loginRoute: (context) => LoginPage(),
    managementRoute: (context) => ManagementPage(),
    listPage: (context) => ListPage()
  };
}

final appRoute = AppRoute();