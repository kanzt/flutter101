import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DefaultAppBar extends StatelessWidget with PreferredSizeWidget {
  DefaultAppBar({Key? key, this.onBack, this.isHideBackButton = false, this.onLogout})
      : super(key: key);

  VoidCallback? onBack;
  bool isHideBackButton;
  VoidCallback? onLogout;

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
                if (onBack != null) {
                  onBack!();
                } else {
                  Get.back();
                }
              },
            );
          },
        ),
      ),
      actions: <Widget>[
        IconButton(
          icon: const Icon(
            Icons.logout,
            color: Colors.white,
          ),
          onPressed: () {
            if (onLogout != null) {
              onLogout!();
            }
          },
        )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
