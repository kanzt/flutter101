import 'dart:async';

import 'package:flutter_messiah/src/main/core/config/routes.dart';
import 'package:get/get.dart';

class SplashPageController extends GetxController {
  final _duration = Duration(seconds: 1);
  Timer? _timer;

  @override
  void onReady() async {
    super.onReady();

    _timer = Timer(_duration, () => Get.offAllNamed(Routes.mainPage));
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
