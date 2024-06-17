import 'package:flutter_starter/src/resource/language/language.dart';

class LanguageTH extends Languages {

  @override
  String get cancel => "ยกเลิก";

  @override
  String get agree => "ตกลง";

  @override
  String get errorPage => "ยังไม่พร้อมเปิดใช้บริการ";

  @override
  String get closeApp => "ปิดแอปพลิเคชัน";

  @override
  String get dialogWarningTitle => "แจ้งเตือน";

  @override
  String get dialogWarningPressedTitle => "ตกลง";

  @override
  String get errorNoConnection =>
      "เกิดข้อผิดพลาด กรุณาตรวจสอบการเชื่อมต่อ \nของท่านและลองใหม่อีกครั้ง";

  @override
  String get tryAgain => "ลองใหม่อีกครั้ง";
}
