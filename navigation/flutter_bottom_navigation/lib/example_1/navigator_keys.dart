import 'package:flutter/material.dart';

class NavigatorKeys {
  static final GlobalKey<NavigatorState> navigatorKeyMain = GlobalKey(debugLabel: 'navigatorKeyMain');
  static final GlobalKey<NavigatorState> bottomNavigationBarFirstItem =
      GlobalKey(debugLabel: 'bottomNavigationBarHomeKey');
  static final GlobalKey<NavigatorState> bottomNavigationBarSecondItem =
      GlobalKey(debugLabel: 'bottomNavigationBarCalendarKey');
  static final GlobalKey<NavigatorState> bottomNavigationBarThirdItem =
      GlobalKey(debugLabel: 'bottomNavigationBarProfileKey');
}
