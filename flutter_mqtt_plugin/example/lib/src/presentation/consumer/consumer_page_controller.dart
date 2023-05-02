import 'dart:io';

import 'package:flutter_mqtt_plugin_example/src/core/config/routes.dart';
import 'package:flutter_mqtt_plugin_example/src/core/flavor/flavor_config.dart';
import 'package:flutter_mqtt_plugin_example/src/core/repository/repository.dart';
import 'package:flutter_mqtt_plugin_example/src/data/entity/logout_request.dart';
import 'package:flutter_mqtt_plugin_example/src/util/notification/notification_service.dart';
import 'package:flutter_mqtt_plugin_example/src/util/shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

class ConsumerPageController extends GetxController {
  final repository = Get.find<Repository>();

  @override
  void onInit() async {
    super.onInit();
    if (Platform.isAndroid) {
      final clientId =
          await SharedPreference.read(SharedPreference.KEY_CLIENT_ID) ?? "";
      final topic =
          await SharedPreference.read(SharedPreference.KEY_TOKEN) ?? "";
      FlavorConfig.instance.values.initializationSettings.connectionSetting
          .clientId = clientId;
      FlavorConfig.instance.values.initializationSettings.connectionSetting
          .topic = topic;

      await Get.find<NotificationService>().initialize(
        settings: FlavorConfig.instance.values.initializationSettings,
      );
    }
  }

  void logout() async {
    final disconnectResult = await Get.find<NotificationService>().disconnect();
    if (disconnectResult == true) {
      final queueName =
          await SharedPreference.read(SharedPreference.KEY_QUEUE_NAME) ?? "";
      final token =
          await SharedPreference.read(SharedPreference.KEY_TOKEN) ?? "";
      final response = await repository.logout(
        LogoutRequest(token: token, queueName: queueName),
      );

      if (response?.result == true) {
        SharedPreference.clearLogoutAll();
        Get.offAllNamed(Routes.loginPage);
      }
    }
  }
}
