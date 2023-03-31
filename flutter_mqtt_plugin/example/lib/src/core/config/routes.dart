import 'package:flutter_mqtt_plugin_example/src/presentation/consumer/consumer_page.dart';
import 'package:flutter_mqtt_plugin_example/src/presentation/login/login_page.dart';
import 'package:get/get.dart';

class Routes {
  static const rootPage = "/loginPage";
  static const loginPage = "/loginPage";
  static const consumerPage = "/consumerPage";

  static List<GetPage> getRoute() {
    return [
      GetPage(
        name: rootPage,
        page: () => LoginPage(),
      ),
      GetPage(
        name: consumerPage,
        page: () => const ConsumerPage(),
      ),
    ];
  }
}
