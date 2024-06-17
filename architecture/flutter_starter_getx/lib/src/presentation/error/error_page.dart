import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_starter/src/resource/assets/assets.dart';
import 'package:flutter_starter/src/resource/language/language.dart';
import 'package:flutter_starter/src/resource/language/language_size.dart';
import 'package:flutter_starter/src/resource/language/language_type.dart';
import 'package:flutter_starter/src/util/widget/component/rounded_button.dart';
import 'package:flutter_starter/src/util/widget/text/text_style_show.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ErrorPage extends StatelessWidget {
  ErrorPage({Key? key}) : super(key: key);
  late final Languages language;

  @override
  Widget build(BuildContext context) {
    language = Languages.of(context)!;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                SvgPicture.asset(Assets.error504),
                Padding(
                  padding: const EdgeInsets.only(top: 49),
                  child: TextStyleShow(
                    text: language.errorPage,
                    languageSize: LanguageSize.size18,
                    languageType: LanguageType.regular,
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
                buttonLabel: language.closeApp,
                isOutline: false,
                onPressed: _exit,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _exit() {
    if (Platform.isIOS) {
      try {
        exit(0);
      } catch (e) {
        SystemNavigator.pop();
      }
    } else {
      try {
        SystemNavigator.pop();
      } catch (e) {
        exit(0);
      }
    }
  }
}
