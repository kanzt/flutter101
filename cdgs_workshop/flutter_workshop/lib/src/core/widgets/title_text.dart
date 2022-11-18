import 'package:flutter/material.dart';
import 'package:flutter_workshop/src/core/config/theme/light_color.dart';
import 'package:google_fonts/google_fonts.dart';

class TitleText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color color;
  final TextAlign textAlign;
  final FontWeight fontWeight;
  const TitleText(
      {Key? key,
        required this.text,
        this.fontSize = 18,
        this.color = LightColor.titleTextColor,
        this.textAlign = TextAlign.start,
        this.fontWeight = FontWeight.w800})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text(text,
        textAlign: textAlign,
        style: GoogleFonts.mulish(
            fontSize: fontSize, fontWeight: fontWeight, color: color));
  }
}
