import 'package:flutter/material.dart';
import 'package:flutter_mqtt_example/src/core/config/routes.dart';
import 'package:flutter_mqtt_example/src/util/notification/notification_service.dart';
import 'package:flutter_mqtt_example/src/util/widget/default_app_bar.dart';
import 'package:get/get.dart';

class NotificationDetailPage extends StatelessWidget {
  const NotificationDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(
        onBack: () {
          Get.offAllNamed(Routes.consumerPage);
        },
      ),
      body: Container(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Notification payload :",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            ValueListenableBuilder(
              valueListenable: Get.find<NotificationService>().selectedNotification,
              builder: (BuildContext context, String? value,
                  Widget? child) {
                return Text(value ?? "");
              },
            ),
          ],
        ),
      ),
    );
  }
}
