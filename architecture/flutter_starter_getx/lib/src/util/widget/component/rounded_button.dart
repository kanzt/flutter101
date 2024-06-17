import 'package:flutter/material.dart';
import 'package:flutter_starter/src/resource/color/color_assets.dart';
import 'package:flutter_starter/src/resource/language/language_size.dart';
import 'package:flutter_starter/src/resource/language/language_type.dart';
import 'package:flutter_starter/src/util/widget/text/text_style_show.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton({
    Key? key,
    this.width = 99,
    this.height = 33,
    this.circular = 17.0,
    required this.buttonLabel,
    this.labelColor = Colors.white,
    this.borderColor = ColorAssets.mangoOrange,
    this.onPressed,
    this.isOutline = false,
    this.languageSize = LanguageSize.size16,
    this.languageType = LanguageType.regular,
    this.outlineBackground = Colors.transparent,
  }) : super(key: key);

  final double width;
  final double height;
  final String buttonLabel;
  final double circular;
  final Color labelColor;
  final Color outlineBackground;
  final Color borderColor;
  final bool isOutline;
  final VoidCallback? onPressed;
  final LanguageSize languageSize;
  final LanguageType languageType;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: () {
          if (onPressed != null) {
            onPressed!();
          }
        },
        style: ButtonStyle(
            elevation: MaterialStateProperty.all<double>(0.0),
            backgroundColor: MaterialStateProperty.all<Color>(
                isOutline ? outlineBackground : ColorAssets.mangoOrange),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(circular),
              side: BorderSide(color: borderColor),
            ))),
        child:
        TextStyleShow(
          text: buttonLabel,
          languageSize: languageSize,
          languageType: languageType,
          color: isOutline ? borderColor : labelColor,
        ),
      ),
    );
  }
}
