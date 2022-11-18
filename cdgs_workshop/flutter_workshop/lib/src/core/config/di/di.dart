import 'package:flutter_workshop/src/core/config/di/application_controller.dart';
import 'package:flutter_workshop/src/core/config/di/auth_controller.dart';
import 'package:flutter_workshop/src/core/config/di/cart_controller.dart';
import 'package:flutter_workshop/src/core/service_manager/service_manager.dart';
import 'package:flutter_workshop/src/data/repository/repository.dart';
import 'package:get/get.dart';

Future<void> initGetX() async {
  // Repository & ServiceManager
  Get.put(ServiceManager());
  Get.put(Repository());

  // Cart state
  Get.put(CartController());

  // Global state
  Get.put(ApplicationController());

  // Auth state
  Get.put(AuthController());
}
