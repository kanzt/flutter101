import 'package:flutter/cupertino.dart';
import 'package:flutter_starter/src/resource/color/color_assets.dart';
import 'package:flutter_starter/src/resource/language/language_size.dart';
import 'package:flutter_starter/src/resource/language/language_type.dart';
import 'package:flutter_starter/src/resource/theme/theme.dart';

class TextStyleShow extends StatelessWidget {
  final String text;
  final LanguageSize languageSize;
  final LanguageType languageType;
  final Color color;
  final TextAlign? textAlign;
  final int? maxLines;
  final double? lineHeight;

  const TextStyleShow({
    Key? key,
    required this.text,
    required this.languageSize,
    required this.languageType,
    this.color = ColorAssets.jet,
    this.maxLines,
    this.textAlign,
    this.lineHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      textAlign: textAlign,
      style: AppTheme.textStyle(
        languageSize: languageSize,
        languageType: languageType,
      )?.copyWith(color: color, height: lineHeight),
    );
  }
}
