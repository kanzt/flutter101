import 'package:flutter/material.dart';
import 'package:flutter_messiah/src/main/presentation/splash/splash_page_controller.dart';
import 'package:get/get.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashPageController>(
        init: SplashPageController(),
        builder: (_) {
          return Scaffold(
            body: Container(
              width: Get.width,
              height: Get.height,
              child: Center(
                child: Text("Splash screen"),
              ),
            ),
          );
        });
  }
}
