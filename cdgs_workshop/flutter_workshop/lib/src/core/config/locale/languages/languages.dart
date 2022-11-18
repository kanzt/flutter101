import 'package:flutter/material.dart';

abstract class Languages {

  static Languages? of(BuildContext context) {
    return Localizations.of<Languages>(context, Languages);
  }

  // Core
  String get errorOccurred;

  String get connectionTimeout;

  String get pleaseConnectToTheInternet;

  String get connectionException;

  String get notFound404;

  String get loading;

  String get pleaseContactAdmin;


  // App
  String get loginWithKeycloak;

  String get bypassLogin;

  String get setting;

  String get logout;

}