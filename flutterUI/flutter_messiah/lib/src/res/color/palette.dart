import 'package:flutter/material.dart';

class Palette {

  static const MaterialColor kToDark = const MaterialColor(
    0xFFFCC75E,
    // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
    const <int, Color>{
      50: const Color(0xFFE3B355), //10%
      100: const Color(0xFFca9f4b), //20%
      200: const Color(0xffb08b42), //30%
      300: const Color(0xff977738), //40%
      400: const Color(0xff7e642f), //50%
      500: const Color(0xff655026), //60%
      600: const Color(0xff4c3c1c), //70%
      700: const Color(0xff322813), //80%
      800: const Color(0xff191409), //90%
      900: const Color(0xff000000), //100%
    },
  );

  static const primaryColor = Color(0xFFFCC75E);
  static const lightGray = Color(0xFFF2F2F2);
}
