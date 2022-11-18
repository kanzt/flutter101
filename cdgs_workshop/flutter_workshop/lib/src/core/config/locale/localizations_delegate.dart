import 'package:flutter/material.dart';
import 'package:flutter_workshop/src/core/config/locale/languages/language_en.dart';
import 'package:flutter_workshop/src/core/config/locale/languages/language_th.dart';
import 'package:flutter_workshop/src/core/config/locale/languages/languages.dart';

class AppLocalizationsDelegate extends LocalizationsDelegate<Languages> {

  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      ['en', 'th',].contains(locale.languageCode);

  @override
  Future<Languages> load(Locale locale) => _load(locale);

  static Future<Languages> _load(Locale locale) async {
    switch (locale.languageCode) {
      case 'en':
        return LanguageEn();
      case 'th':
        return LanguageTh();
      default:
        return LanguageEn();
    }
  }

  @override
  bool shouldReload(LocalizationsDelegate<Languages> old) => false;
}
