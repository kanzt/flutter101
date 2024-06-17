import 'package:flutter_starter/src/presentation/error/error_no_connection_page.dart';
import 'package:flutter_starter/src/presentation/error/error_page.dart';
import 'package:flutter_starter/src/presentation/splash/splash_page.dart';
import 'package:get/get.dart';

class Routes {
  static const rootPage = "/splashPage";
  static const errorPage = "/errorPage";
  static const errorNoConnectionPage = "/errorNoConnectionPage";

  static List<GetPage> getRoute() {
    final int duration = 175;
    return [
      GetPage(
        name: rootPage,
        page: () => const SplashPage(),
        transition: Transition.fadeIn,
      ),
      GetPage(
        name: errorPage,
        page: () => ErrorPage(),
        transition: Transition.noTransition,
      ),
      GetPage(
        name: errorNoConnectionPage,
        page: () => ErrorNoConnectionPage(),
        transition: Transition.noTransition,
      ),
    ];
  }
}
