import 'package:flutter_mqtt_example/src/presentation/consumer/consumer_page.dart';
import 'package:flutter_mqtt_example/src/presentation/login/login_page.dart';
import 'package:flutter_mqtt_example/src/presentation/notificationdetail/notification_detail_page.dart';
import 'package:flutter_mqtt_example/src/presentation/splash/splash_page.dart';
import 'package:get/get.dart';

class Routes {
  static const rootPage = "/splashPage";
  static const loginPage = "/loginPage";
  static const consumerPage = "/consumerPage";
  static const consumerNoAnimPage = "/consumerNoAnimPage";
  static const notificationDetailPage = "/notificationDetailPage";

  static List<GetPage> getRoute() {
    return [
      GetPage(
        name: rootPage,
        page: () => const SplashPage(),
      ),
      GetPage(
        name: loginPage,
        page: () => LoginPage(),
      ),
      GetPage(
        name: consumerPage,
        page: () => ConsumerPage(),
      ),
      GetPage(
        name: consumerNoAnimPage,
        page: () => ConsumerPage(),
        transition: Transition.noTransition
      ),
      GetPage(
        name: notificationDetailPage,
        page: () => const NotificationDetailPage(),
      ),
    ];
  }
}
