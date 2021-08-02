import 'package:flutter/material.dart';

class BackGroundTheme {
  const BackGroundTheme();

  static const _gradientStart = const Color(0xFF36D1DC);
  static const _gradientEnd = const Color(0xFF5B86E5);

  /// วิธีการเขียน getter ใน Flutter แบบง่าย
  get gradientStart => _gradientStart;
  get gradientEnd => _gradientEnd;

  static const gradient = LinearGradient(
    colors: [
      _gradientStart,
      _gradientEnd,
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [0.0, 1.0],
  );
// ไม่ใช่ตัวแปร final (static const) ไม่สามารถประกาศใน class BackGroundTheme()
// ที่ประกาศ constructor เป็น const
// LinearGradient gradients = LinearGradient(
//   colors: [
//     _gradientStart,
//     _gradientEnd,
//   ],
//   begin: Alignment.topCenter,
//   end: Alignment.bottomCenter,
//   stops: [0.0, 1.0],
// );
}