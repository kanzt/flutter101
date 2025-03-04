
import 'package:flutter_mqtt_example/src/core/lifecycle/application_lifecycle_controller.dart';
import 'package:flutter_mqtt_example/src/core/remote/service_api.dart';
import 'package:flutter_mqtt_example/src/core/remote/service_manager.dart';
import 'package:flutter_mqtt_example/src/core/repository/repository.dart';
import 'package:flutter_mqtt_example/src/core/repository/repository_impl.dart';
import 'package:flutter_mqtt_example/src/util/notification/notification_service.dart';
import 'package:get/get.dart';

Future<void> initCoreDI() async {
  // Application lifecycle
  Get.put(ApplicationLifecycleController());

  // Notification Service
  Get.put(NotificationService());

  // ServiceManager
  Get.lazyPut(() => ServiceManager(), fenix: true);

  // Service API
  Get.put(ServiceApi());

  // Repository
  Get.put<Repository>(RepositoryImpl(Get.find()));
}
