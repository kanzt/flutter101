

import 'package:flutter/material.dart';

class Palette {
  static const MaterialColor kToDark = MaterialColor(
    0xff6685ff,
    // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
    <int, Color>{
      50: Color(0xff5c78e6), //10%
      100: Color(0xff526acc), //20%
      200: Color(0xff475db3), //30%
      300: Color(0xff3d5099), //40%
      400: Color(0xff334380), //50%
      500: Color(0xff293566), //60%
      600: Color(0xff1f284c), //70%
      700: Color(0xff141b33), //80%
      800: Color(0xff0a0d19), //90%
      900: Color(0xff000000), //100%
    },
  );

  static const todayColor = Color(0xffF7F7B9);
  static const dangerColor = Color(0xffFF6666);

  static const wfhColor = Color(0xff3283B9);
  static const dayOffColor = Color(0xffFFA000);
  static const nationalDayColor = Color(0xffF37F7F);

}