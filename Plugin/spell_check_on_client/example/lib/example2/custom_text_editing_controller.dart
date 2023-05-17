import 'package:flutter/material.dart';

class CustomTextEdittingController extends TextEditingController {
  final List<String> listErrorTexts;

  CustomTextEdittingController({String? text, this.listErrorTexts = const []})
      : super(text: text);

  @override
  TextSpan buildTextSpan(
      {required BuildContext context,
      TextStyle? style,
      required bool withComposing}) {
    final List<TextSpan> children = [];
    if (listErrorTexts.isEmpty) {
      return TextSpan(text: text, style: style);
    }
    try {
      text.splitMapJoin(
          // ^[ก-ฮ]+|^[ฯะัาำิีึืฺุูเแโใไๅๆ็่้๊๋์]+
          //
          // [^\s\w]|^[ก-ฮ]+|^[ฯะัาำิีึืฺุูเแโใไๅๆ็่้๊๋์]+
          //
          // \b(สาว|hel)+\b|[ก-ฮฯะัาำิีึืฺุูเแโใไๅๆ็่้๊๋์]
          //
          // \b(สาว|hel)+\b|[ก-ฮฯะัาำิีึืฺุูเแโใไๅๆ็่้๊๋์]
          //
          // r'\b(' + listErrorTexts.join('|').toString() + r')+\b'
          RegExp(r'(' + listErrorTexts.join('|').toString() + r')+'),
          onMatch: (m) {
        children.add(TextSpan(
          text: m[0],
          style: style!.copyWith(
              decoration: TextDecoration.underline,
              decorationStyle: TextDecorationStyle.wavy,
              decorationColor: Colors.red),
        ));
        return "";
      }, onNonMatch: (n) {
        children.add(TextSpan(text: n, style: style));
        return n;
      });
    } on Exception catch (e) {
      return TextSpan(text: text, style: style);
    }
    return TextSpan(children: children, style: style);
  }
}
