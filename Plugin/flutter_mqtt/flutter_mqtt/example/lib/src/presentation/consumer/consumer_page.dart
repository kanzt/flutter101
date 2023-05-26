import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_mqtt_example/src/presentation/consumer/consumer_page_controller.dart';
import 'package:flutter_mqtt_example/src/util/notification/notification_service.dart';
import 'package:flutter_mqtt_example/src/util/widget/default_app_bar.dart';
import 'package:get/get.dart';
import 'package:open_settings/open_settings.dart';

class ConsumerPage extends StatelessWidget {
  ConsumerPage({Key? key}) : super(key: key);

  final ConsumerPageController consumerPageController =
      Get.put(ConsumerPageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(
        isHideBackButton: true,
        onLogout: () {
          consumerPageController.logout();
        },
      ),
      body: Stack(
        children: [
          Visibility(
            visible: Platform.isAndroid,
            child: FutureBuilder(
              future: consumerPageController.isAllowAutoStartEnabled(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data == false) {
                    return Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        width: double.infinity,
                        margin: const EdgeInsets.all(8),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0x4D03DAC5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Allow this app to run in the background"),
                            const SizedBox(
                              height: 8,
                            ),
                            const Text(
                                "Give MQTT Flutter Sample App permission to run in the background"),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    OpenSettings.openMainSetting();
                                  },
                                  child: const Text("TURN ON"),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                }
                return const SizedBox();
              },
            ),
          ),
          const Align(
            alignment: Alignment.center,
            child: Text("Waiting for notification..."),
          ),
          Positioned(
            left: 8,
            bottom: 0,
            right: 8,
            child: SizedBox(
              height: 120,
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Recent notification :",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Row(
                        children: <Widget>[
                          Flexible(
                            child: ValueListenableBuilder(
                              valueListenable: Get.find<NotificationService>()
                                  .recentNotification,
                              builder: (BuildContext context, String? value,
                                  Widget? child) {
                                return Text(value ?? "");
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
