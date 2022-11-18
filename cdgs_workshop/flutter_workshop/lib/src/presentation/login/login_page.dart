import 'package:flutter/material.dart';
import 'package:flutter_workshop/src/core/config/di/auth_controller.dart';
import 'package:flutter_workshop/src/core/constant/assets.dart';
import 'package:flutter_workshop/src/core/config/locale/languages/languages.dart';
import 'package:flutter_workshop/src/core/config/theme/light_color.dart';
import 'package:flutter_workshop/src/core/widgets/title_text.dart';
import 'package:get/get.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  final _authPageController = Get.put(AuthController());

  late Languages language;

  @override
  Widget build(BuildContext context) {
    language = Languages.of(context)!;
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Image.asset(Assets.eCommerceLogo),
            _loginWithKeycloakButton(),
            _bypassLoginButton(),
          ],
        ),
      ),
    );
  }

  Widget _loginWithKeycloakButton() {
    // return SizedBox(
    //   width: 250,
    //   child: OutlinedButton(
    //     onPressed: () {},
    //     style: OutlinedButton.styleFrom(
    //         shape: const StadiumBorder(),
    //         side: const BorderSide(color: LightColor.orange)),
    //     child: const TitleText(
    //       text: "Login with Keycloak",
    //       fontWeight: FontWeight.w400,
    //       color: LightColor.orange,
    //     ),
    //   ),
    // );

    /// สามารถใช้แทนกันได้ ได้ผลลัพธ์เหมือนด้านบน
    // final buttonStyle = ButtonStyle(
    //   overlayColor: MaterialStateProperty.all<Color>(LightColor.orange.withOpacity(0.2)),
    //   backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
    //   shape: MaterialStateProperty.all<RoundedRectangleBorder>(
    //     RoundedRectangleBorder(
    //       borderRadius: BorderRadius.circular(18.0),
    //       side: const BorderSide(color: LightColor.orange),
    //     ),
    //   ),
    // );

    /// Shorthand ของ butonStyle ด้านบน
    final buttonStyle = ElevatedButton.styleFrom(
      primary: Colors.white,
      onPrimary: LightColor.orange,
      shape: const StadiumBorder(),
      side: const BorderSide(color: LightColor.orange),
    );

    return SizedBox(
      width: 250,
      child: ElevatedButton(
        onPressed: () {
          _authPageController.signInWithAutoCodeExchange();
        },
        style: buttonStyle,
        child: TitleText(
          text: language.loginWithKeycloak,
          fontWeight: FontWeight.w400,
          color: LightColor.orange,
        ),
      ),
    );
  }

  Widget _bypassLoginButton() {
    return SizedBox(
      width: 250,
      child: ElevatedButton(
        onPressed: _authPageController.bypassLogin,
        style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color>(LightColor.orange),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: const BorderSide(color: LightColor.orange)))),
        child: TitleText(
          text: language.bypassLogin,
          fontWeight: FontWeight.w400,
          color: Colors.white,
        ),
      ),
    );
  }
}
