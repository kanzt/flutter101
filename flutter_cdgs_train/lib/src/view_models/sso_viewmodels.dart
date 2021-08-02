import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SSOModel {
  final IconData icon;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color iconColor;

  /// ถ้าหากเราสร้าง Object ที่ไม่มีการเปลี่ยนแปลงค่าเราสามารถใช้ keyword const ที่ constructor ได้ และอย่าลืมตั้ง property ของ class ทุกตัวเป็น final
  /// https://dart.dev/codelabs/dart-cheatsheet#const-constructors
  const SSOModel({
    this.icon,
    this.onPressed,
    this.backgroundColor,
    this.iconColor,
  });
}

class SSOViewModel {
  List<SSOModel> get item => [
    SSOModel(
      icon: FontAwesomeIcons.apple,
      backgroundColor: Color(0xFF323232),
      onPressed: () {
        //todo
      },
    ),
    SSOModel(
      icon: FontAwesomeIcons.google,
      backgroundColor: Color(0xFFd7483b),
      onPressed: () {
        //todo
      },
    ),
    SSOModel(
      icon: FontAwesomeIcons.facebookF,
      backgroundColor: Color(0xFF4063ae),
      onPressed: () {
        //todo
      },
    ),
    SSOModel(
      icon: FontAwesomeIcons.line,
      backgroundColor: Color(0xFF21b54d),
      onPressed: () {
        //todo
      },
    ),
  ];
}