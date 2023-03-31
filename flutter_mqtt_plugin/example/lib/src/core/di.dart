import 'package:flutter_mqtt_plugin_example/src/core/remote/service_api.dart';
import 'package:flutter_mqtt_plugin_example/src/core/remote/service_manager.dart';
import 'package:flutter_mqtt_plugin_example/src/core/repository/repository.dart';
import 'package:flutter_mqtt_plugin_example/src/core/repository/repository_impl.dart';
import 'package:get/get.dart';

Future<void> initCoreDI() async {
  // ServiceManager
  Get.lazyPut(() => ServiceManager(), fenix: true);

  // Service API
  Get.put(ServiceApi());

  // Repository
  Get.put<Repository>(RepositoryImpl(Get.find()));
}
