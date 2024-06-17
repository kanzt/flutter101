import 'package:flutter/material.dart';
import 'package:flutter_starter/src/presentation/splash/splash_page_controller.dart';
import 'package:flutter_starter/src/resource/assets/assets.dart';
import 'package:flutter_starter/src/resource/color/color_assets.dart';
import 'package:flutter_starter/src/util/extension/size_util.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashPageController>(
      init: SplashPageController(),
      builder: (_) {
        return Scaffold(
            body: Container(
          width: Get.width,
          height: Get.height,
          color: ColorAssets.clearBlue2,
          child: Stack(
            children: [

            ],
          ),
        ));
      },
    );
  }
}
