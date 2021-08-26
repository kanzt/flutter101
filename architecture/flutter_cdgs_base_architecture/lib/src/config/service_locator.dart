import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

void setupLocator(){
  locator.registerLazySingleton(() => NavigationService());
}

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

  BuildContext get context  => navigatorKey.currentContext;

  Future<dynamic> navigateToUtil(String routeName){
    return navigatorKey.currentState.pushNamedAndRemoveUntil(routeName, (route) => false);
  }

  Future<dynamic> navigateTo(String routeName) {
    return navigatorKey.currentState.pushNamed(routeName);
  }

  Future<void> navigatePop(){
    navigatorKey.currentState.pop();
  }
}