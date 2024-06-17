import 'package:flutter/material.dart';
import 'package:flutter_starter/src/resource/language/language.dart';
import 'package:flutter_starter/src/resource/language/th/language_th.dart';

class AppLocalizationsDelegate extends LocalizationsDelegate<Languages> {
  AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => [
        'th',
      ].contains(locale.languageCode);

  @override
  Future<Languages> load(Locale locale) => _load(locale);

  static Future<Languages> _load(Locale locale) async {
    return LanguageTH();
  }

  @override
  bool shouldReload(LocalizationsDelegate<Languages> old) => false;
}
