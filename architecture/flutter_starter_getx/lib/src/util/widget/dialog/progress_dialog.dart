import 'package:flutter/material.dart';
import 'package:flutter_starter/src/resource/assets/assets.dart';
import 'package:flutter_starter/src/resource/color/color_assets.dart';
import 'package:flutter_starter/src/resource/language/language_size.dart';
import 'package:flutter_starter/src/resource/language/language_type.dart';
import 'package:flutter_starter/src/util/widget/text/text_style_show.dart';
import 'package:lottie/lottie.dart';

class ProgressDialog extends StatelessWidget {
  ProgressDialog({Key? key, this.value}) : super(key: key);

  final String? value;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 100),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        child: Container(
          width: 198,
          height: 146,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Lottie.asset(Assets.progress, width: 120, height: 120),
              Positioned(
                bottom: 16,
                child: Container(
                  margin: const EdgeInsets.only(left: 7),
                  child: TextStyleShow(
                    text: value ?? "0 %",
                    color: ColorAssets.brightNavyBlue,
                    languageType: LanguageType.bold,
                    languageSize: LanguageSize.size18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
