import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {

  @required
  final TextEditingController controller;
  final double fontSize;
  final String labelText;
  final String hintText;
  final IconData icon;
  final Color textColor;
  final bool isPassword;

  CustomTextField(this.controller, {
    this.fontSize,
    this.labelText,
    this.hintText,
    this.icon,
    this.textColor,
    this.isPassword = false
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: TextStyle(
        color: textColor ?? Colors.black,
        fontWeight: FontWeight.normal,
        fontSize: fontSize ?? 20.0,
      ),
      decoration: InputDecoration(
        labelText: labelText ?? 'Username',
        hintText: hintText ?? 'Username',
        prefixIcon: icon == null ? null :Icon(icon),
      ),
      obscureText: isPassword,
    );
  }
}
