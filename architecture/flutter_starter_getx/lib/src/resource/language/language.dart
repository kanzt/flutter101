import 'package:flutter/cupertino.dart';

abstract class Languages {
  // // Core
  static Languages? of(BuildContext context) {
    return Localizations.of<Languages>(context, Languages);
  }

  String get dialogWarningTitle;

  String get dialogWarningPressedTitle;

  String get cancel;

  String get agree;

  String get closeApp;

  String get errorPage;

  String get errorNoConnection;

  String get tryAgain;
}
