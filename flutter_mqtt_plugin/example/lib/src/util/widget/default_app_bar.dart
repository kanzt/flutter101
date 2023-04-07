import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DefaultAppBar extends StatelessWidget with PreferredSizeWidget {
  DefaultAppBar({Key? key, this.onBack}) : super(key: key);

  VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text("Flutter MQTT Sample App"),
      leading: Builder(
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
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
