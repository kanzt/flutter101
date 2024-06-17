import 'package:flutter/material.dart';

class TextWithMinLines extends Text {
  const TextWithMinLines(super.data, {
    super.key,
    super.style,
    super.strutStyle,
    super.textAlign,
    super.textDirection,
    super.locale,
    super.softWrap,
    super.overflow,
    super.textScaleFactor,
    this.minLines = 0,
    super.maxLines,
    super.semanticsLabel,
    super.textWidthBasis,
    super.textHeightBehavior,
  }) : assert(minLines >= 0),
        super();

  final int minLines;

  @override
  Widget build(BuildContext context) {
    final displayText = super.build(context);
    if (minLines <= 1) {
      return displayText;
    }
    return IndexedStack(
      children: [
        displayText,
        Text(
          '\n'* (minLines - 1),
          style: style,
          strutStyle: strutStyle,
          textAlign: textAlign,
          textDirection: textDirection,
          locale: locale,
          softWrap: softWrap,
          textScaleFactor: textScaleFactor,
          maxLines: maxLines,
          textHeightBehavior: textHeightBehavior,
        ),
      ],
    );
  }
}