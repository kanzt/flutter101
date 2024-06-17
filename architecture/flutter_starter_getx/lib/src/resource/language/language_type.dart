import 'dart:ui';

class LanguageType{
  const LanguageType._(this.value);
  final FontWeight? value;
  static const LanguageType thin = LanguageType._(FontWeight.w100);
  static const LanguageType extraLight = LanguageType._(FontWeight.w200);
  static const LanguageType light = LanguageType._(FontWeight.w300);
  static const LanguageType regular = LanguageType._(FontWeight.w400);
  static const LanguageType medium = LanguageType._(FontWeight.w500);
  static const LanguageType semiBold = LanguageType._(FontWeight.w600);
  static const LanguageType bold = LanguageType._(FontWeight.w700);
  static const LanguageType extraBold = LanguageType._(FontWeight.w800);
  static const LanguageType black = LanguageType._(FontWeight.w900);
}
