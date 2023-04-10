import 'package:flutter/material.dart';
import 'package:flutter_mqtt_plugin_example/src/core/config/routes.dart';
import 'package:get/get.dart';

class DefaultAppBar extends StatelessWidget with PreferredSizeWidget {
  DefaultAppBar({Key? key, this.onBack, this.isHideBackButton = false}) : super(key: key);

  VoidCallback? onBack;
  bool isHideBackButton;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text("Flutter MQTT Sample App"),
      leading: Visibility(
        maintainState: true,
        maintainAnimation: true,
        maintainSize: true,
        visible: Get.rawRoute?.isFirst == false && isHideBackButton == false,
        child: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                if(onBack != null){
                  onBack!();
                }else{
                  Get.back();
                }
              },
            );
          },
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
