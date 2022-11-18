import 'package:flutter_workshop/src/core/config/locale/languages/languages.dart';

class LanguageTh extends Languages {
  // Core
  @override
  String get errorOccurred => "เกิดข้อผิดพลาด";

  @override
  String get connectionTimeout => "หมดเวลาการเชื่อมต่อ";

  @override
  String get pleaseConnectToTheInternet => "กรุณาเชื่อมต่ออินเตอร์เน็ต";

  @override
  String get connectionException => "Connection Exception";

  @override
  String get notFound404 => "ไม่พบที่อยู่ URL";

  @override
  String get loading => "Loading";

  @override
  String get pleaseContactAdmin => "กรุณาติดต่อผู้ดูแลระบบ";

  // App
  @override
  String get bypassLogin => "บายพาสการเข้าสู่ระบบ";

  @override
  String get loginWithKeycloak => "เข้าสู่ระบบด้วย Keycloak";

  @override
  String get logout => "ออกจากระบบ";

  @override
  String get setting => "ตั้งค่า";
}
