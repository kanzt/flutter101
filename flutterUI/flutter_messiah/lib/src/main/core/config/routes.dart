import 'package:flutter_messiah/src/main/presentation/login/login_page.dart';
import 'package:flutter_messiah/src/main/presentation/main/main_page.dart';
import 'package:flutter_messiah/src/main/presentation/splash/splash_page.dart';
import 'package:get/get.dart';

class Routes {
  static const rootPage = "/splashPage";
  static const mainPage = "/mainPage";
  static const loginPage = "/loginPage";

  static List<GetPage> getRoute() {
    final int duration = 175;
    return [
      GetPage(
        name: rootPage,
        page: () => const SplashPage(),
        transition: Transition.fadeIn,
      ),
      GetPage(
        name: loginPage,
        page: () => LoginPage(),
        transition: Transition.fadeIn,
      ),
      GetPage(
        name: mainPage,
        page: () => const MainPage(),
        transition: Transition.fadeIn,
      ),
    ];
  }
}
