import 'dart:async';

import 'package:flutter_messiah/src/main/core/config/routes.dart';
import 'package:flutter_messiah/src/main/util/shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

class SplashPageController extends GetxController {
  final _duration = Duration(seconds: 1);
  Timer? _timer;

  @override
  void onReady() async {
    super.onReady();

    _navigateToMainPage();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  void _navigateToMainPage() async {
    // var accessToken = "Passed";
    var accessToken =
        await SharedPreference.read(SharedPreference.KEY_ACCESS_TOKEN);

    if (accessToken != null) {
      final refreshToken =
          await SharedPreference.read(SharedPreference.KEY_REFRESH_TOKEN);

      // TODO : Call refresh token
      final tokenResponse = true;
      // final tokenResponse = await _repository.token(
      //   Authentication(
      //       grantType: GrantType.renew,
      //       clientId: Constant.client_id,
      //       clientSecret: Constant.client_secret,
      //       deviceToken:
      //           await SharedPreference.read(SharedPreference.KEY_FCM_TOKEN) ??
      //               "",
      //       refreshToken: refreshToken!),
      // );

      if (tokenResponse == true) {
        // await Future.wait([
        //   SharedPreference.write(
        //     SharedPreference.KEY_ACCESS_TOKEN,
        //     tokenResponse?.result?.accessToken,
        //   ),
        //   SharedPreference.write(
        //     SharedPreference.KEY_REFRESH_TOKEN,
        //     tokenResponse?.result?.refreshToken,
        //   )
        // ]);

        _timer = Timer(_duration, () => Get.offAllNamed(Routes.mainPage));
      } else {
        await SharedPreference.clearLogoutAll();
        _timer = Timer(
          _duration,
          () => Get.offAllNamed(Routes.loginPage),
        );
      }
    } else {
      await SharedPreference.clearLogoutAll();
      // Init 1 : 1.2 > 1.2.3
      _timer = Timer(
        _duration,
        () => Get.offAllNamed(Routes.loginPage),
      );
    }
  }
}
