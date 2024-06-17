import 'package:flutter/material.dart';
import 'package:flutter_starter/src/resource/color/color_assets.dart';
import 'package:flutter_starter/src/util/widget/text/edit_text.dart';

class TodoEditText extends StatelessWidget {
  const TodoEditText({Key? key, this.controller, this.obscureText = false}) : super(key: key);

  final TextEditingController? controller;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return EditText(
      controller: controller,
      contentPadding: EdgeInsets.symmetric(horizontal: 16),
      textColor: ColorAssets.raven,
      borderColor: ColorAssets.lavenderGray,
      width: double.infinity,
      obscureText: obscureText,
      height: 40,
      borderRadius: 10,
    );
  }
}
