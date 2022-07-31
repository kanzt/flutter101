import 'package:flutter/material.dart';

class NavigatorKeys {
  static final GlobalKey<NavigatorState> navigatorKeyMain =
      GlobalKey(debugLabel: 'navigatorKeyMain');
  static final GlobalKey<NavigatorState> bottomNavigationBarHomeKey =
      GlobalKey(debugLabel: 'bottomNavigationBarHomeKey');
  static final GlobalKey<NavigatorState> bottomNavigationBarCalendarKey =
      GlobalKey(debugLabel: 'bottomNavigationBarCalendarKey');
  static final GlobalKey<NavigatorState> bottomNavigationBarProfileKey =
      GlobalKey(debugLabel: 'bottomNavigationBarProfileKey');
}
