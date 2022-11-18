import 'package:flutter/material.dart';
import 'package:flutter_workshop/src/core/config/theme/light_color.dart';

enum AvailableColor {
  yellow,
  lightBlue,
  black,
  red,
  skyBlue,
}

extension AvailableColorExtension on AvailableColor {
  String get colorName {
    switch (this) {
      case AvailableColor.yellow:
        return 'Yellow';
      case AvailableColor.lightBlue:
        return 'Purple';
      case AvailableColor.black:
        return 'Black';
      case AvailableColor.red:
        return 'Red';
      case AvailableColor.skyBlue:
        return 'Blue';
      default:
        return '';
    }
  }

  Color get color {
    switch (this) {
      case AvailableColor.yellow:
        return LightColor.yellowColor;
      case AvailableColor.lightBlue:
        return LightColor.lightBlue;
      case AvailableColor.black:
        return LightColor.black;
      case AvailableColor.red:
        return LightColor.red;
      case AvailableColor.skyBlue:
        return LightColor.skyBlue;
      default:
        return Colors.transparent;
    }
  }
}
