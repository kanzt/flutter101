import 'package:flutter/material.dart';
import 'package:flutter_starter/src/resource/assets/assets.dart';
import 'package:flutter_starter/src/resource/language/language.dart';
import 'package:flutter_starter/src/resource/language/language_size.dart';
import 'package:flutter_starter/src/resource/language/language_type.dart';
import 'package:flutter_starter/src/util/widget/component/rounded_button.dart';
import 'package:flutter_starter/src/util/widget/text/text_style_show.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class ErrorNoConnectionPage extends StatelessWidget {
  const ErrorNoConnectionPage({Key? key, this.callback}) : super(key: key);

  final VoidCallback? callback;

  @override
  Widget build(BuildContext context) {
    var language = Languages.of(context)!;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                SvgPicture.asset(Assets.warningNoConnection),
                Padding(
                  padding: const EdgeInsets.only(top: 49),
                  child: TextStyleShow(
                    text: language.errorNoConnection,
                    languageSize: LanguageSize.size18,
                    languageType: LanguageType.regular,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 24, right: 24, top: 61),
              child: RoundedButton(
                width: double.infinity,
                height: 48,
                circular: 24,
                buttonLabel: language.tryAgain,
                isOutline: false,
                onPressed: () {
                  if (callback != null) {
                    callback!();
                  }else{
                    Get.back();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
