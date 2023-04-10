import 'package:flutter/material.dart';
import 'package:flutter_mqtt_plugin_example/src/util/notification/notification_service.dart';
import 'package:flutter_mqtt_plugin_example/src/util/widget/default_app_bar.dart';

class ConsumerPage extends StatelessWidget {
  const ConsumerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(
        isHideBackButton : true,
      ),
      body: Stack(
        children: [
          const Center(
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
                              valueListenable:
                                  NotificationService.recentNotification,
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
