import 'package:flutter_workshop/src/core/config/locale/languages/languages.dart';

class LanguageEn extends Languages {
  // Core
  @override
  String get errorOccurred => "Error occurred";

  @override
  String get connectionTimeout => "Connection timeout";

  @override
  String get pleaseConnectToTheInternet => "Please connect to the internet";

  @override
  String get connectionException => "Connection Exception";

  @override
  String get notFound404 => "URL not found";

  @override
  String get loading => "กำลังโหลด";

  @override
  String get pleaseContactAdmin => "please contact administrator";

  // App
  @override
  String get bypassLogin => "Bypass login";

  @override
  String get loginWithKeycloak => "Login with Keycloak";

  @override
  String get logout => "Logout";

  @override
  String get setting => "Setting";
}
