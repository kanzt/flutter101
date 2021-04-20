import 'package:flutter/material.dart';
import 'package:flutter101/src/pages/home/home_page.dart';
import 'package:flutter101/src/pages/login/login_page.dart';

class AppRoute{
  static const homeRoute = "home";
  static const loginRoute = "login";

  final _route = <String,WidgetBuilder> {
    homeRoute: (context) => HomePage(),
    loginRoute: (context) => LoginPage()
  };
  get route => _route;
}