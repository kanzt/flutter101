import 'package:flutter/material.dart';
import 'package:flutter_starter/src/resource/language/language_size.dart';
import 'package:flutter_starter/src/resource/language/language_type.dart';

class AppTheme {
  static TextStyle? textStyle({
    required LanguageSize languageSize,
    required LanguageType languageType,
  }) {
    return TextStyle(
      fontFamily: "Sarabun",//
      fontSize: languageSize.value,
      fontWeight: languageType.value,
    );
  }

  static const MaterialColor kAppThemeSwatch = MaterialColor(
    0xff3b82f4,
    <int, Color>{
      50: Color(0xff3575dc),//10%
      100: Color(0xff2f68c3),//20%
      200: Color(0xff295bab),//30%
      300: Color(0xff234e92),//40%
      400: Color(0xff1e417a),//50%
      500: Color(0xff183462),//60%
      600: Color(0xff122749),//70%
      700: Color(0xff0c1a31),//80%
      800: Color(0xff060d18),//90%
      900: Color(0xff000000),//100%
    },
  );
}
