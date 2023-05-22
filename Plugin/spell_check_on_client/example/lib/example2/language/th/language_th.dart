
import 'package:example/example2/language/language.dart';

class LanguageTH extends Languages {
  @override
  String get hello => "สวัสดี";

  @override
  String get selectYear => "เลือกปี";

  @override
  String get cancel => "ยกเลิก";

  @override
  String get agree => "ตกลง";

  @override
  String get qrScanTitle => "สแกนคิวอาร์โค้ดของท่าน";

  @override
  String get errorPage => "ยังไม่พร้อมเปิดใช้บริการ";

  @override
  String get emptyItem => "ไม่พบข้อมูล";

  @override
  String get closeApp => "ปิดแอปพลิเคชัน";

  @override
  String get hostName => "Host Name";

  @override
  String get username => "Username";

  @override
  String get register => "ลงทะเบียน";

  @override
  String get login => "เข้าสู่ระบบ";

  @override
  String get testConnectionToIFlowSoft => "ทดสอบการเชื่อมต่อสารบรรณ";

  @override
  String get registerSuccess => "การลงทะเบียนสำเร็จ";

  @override
  String get registerSuccessDescription =>
      "ท่านสามารถเข้าสู่ระบบ ด้วย Username/Password\nสารบรรณอิเล็กทรอนิกส์";

  @override
  String get registerFailed => "ไม่สามารถลงทะเบียนได้";

  @override
  String get registerFailedDescription =>
      "กรุณาตรวจสอบ\nHost Name,Serial Number,Username\nหรือติดต่อผู้ดูแลระบบ";

  @override
  String get ok => "ตกลง";

  @override
  String get changePassword => "เปลี่ยนรหัสผ่าน";

  @override
  String get eSarabun => "สารบรรณอิเล็กทรอนิกส์";

  @override
  String get password => "Password";

  @override
  String get fileNameItemTitle => "ชื่อไฟล์ : ";

  @override
  String get fileSizeItemTitle => "ขนาดไฟล์ : ";

  @override
  String get fileTypeItemTitle => "ชนิดไฟล์ : ";

  @override
  String get nameTodoTitle => "ชื่อเรื่อง : ";

  @override
  String get numberTodoTitle => "เลขที่หนังสือ : ";

  @override
  String get dateTodoTitle => "ลงวันที่ : ";

  @override
  String get dialogWarningTitle => "แจ้งเตือน";

  @override
  String get dialogWarningPressedTitle => "ตกลง";

  @override
  String get newPassword => "New Password";

  @override
  String get confirmNewPassword => "Confirm New Password";

  @override
  String get save => "บันทึก";

  @override
  String get waitForSign => "รอลงนาม\n";

  @override
  String get waitForOrder => "รอสั่งการ\n";

  @override
  String get AcknowledgeNewCircular => "รับทราบ\nหนังสือเวียนใหม่";

  @override
  String get searchBook => "ค้นหาหนังสือ";

  @override
  String get searchCircularBook => "ค้นหาหนังสือ\nเวียนใหม่";

  @override
  String get homePage => "หน้าหลัก";

  @override
  String get qrcodePage => "สแกน QR CODE";

  @override
  String get settingPage => "การตั้งค่า";

  @override
  String get role => "บทบาทหน้าที่";

  @override
  String get setting => "ตั้งค่า";

  @override
  String get settingHelp => "ช่วยเหลือ";

  @override
  String get settingLogin => "ตั้งค่าการใช้งานเพื่อเข้าสู่ระบบ";

  @override
  String get settingPin => "PIN และ ความปลอดภัย";

  @override
  String get settingPolicy => "ข้อกำหนดและเงื่อนไข";

  @override
  String get settingSignature => "จัดเก็บลายเซ็นอิเล็กทรอนิกส์";

  @override
  String get settingVersion => "เวอร์ชั่น";

  @override
  String get logout => "ออกจากระบบ";

  @override
  String get qrTitle => "สแกน QR CODE";

  @override
  String get qrDetail =>
      "สแกน QR CODE ล็อกอินเข้าสู่ระบบเว็บ แอพพลิเคชั่น หรือหนังสือของระบบสารบรรณ อิเล็กทรอนิกส์เพื่อดูหนังสืออ้างถึง และเอกสารแนบ";

  @override
  String get btnQrTitle => "SCAN QR CODE";

  @override
  String get fileAttachment => "ไฟล์แนบ";

  @override
  String get clearSignature => "ล้างค่า";

  @override
  String get storeESignature => "จัดเก็บลายเซ็นอิเล็กทรอนิกส์";

  @override
  String get createSignature => "สร้างลายเซ็นอิเล็กทรอนิกส์ใหม่";

  @override
  String get newSignature => "ลายเซ็นใหม่";

  @override
  String get touchToSign => "แตะเพื่อเซ็น";

  @override
  String get operationList => "รายการที่ต้องดำเนินการ";

  @override
  String get changePin => "เปลี่ยนรหัส PIN";

  @override
  String get enabledBiometric => "ใช้งานระบบ Touch ID/Face ID";

  @override
  String get invalidPasscodePleaseTryAgain =>
      "รหัส PIN ไม่ถูกต้อง\nกรุณาลองใหม่อีกครั้ง";

  @override
  String get pendingListTitle => "รายการรอลงนาม";

  @override
  String get searchListHint => "เลขที่หนังสือ/ลงวันที่/ชื่อเรื่อง";

  @override
  String get orderListTitle => "รายการรอสั่งการ";

  @override
  String get acceptListTitle => "รายการหนังสือเวียนใหม่";

  @override
  String get changePinCodeSuccess => "เปลี่ยนรหัส PIN สำเร็จ";

  @override
  String get draftPdf => "ไฟล์ร่าง PDF";

  @override
  String get signPdf => "ลงนาม";

  @override
  String get comment => "คอมเมนต์";

  @override
  String get bookPathAndOperation => "ทางเดินหนังสือ/สั่งการ";

  @override
  String get emptyAttachment => "ไม่พบไฟล์แนบ";

  @override
  String get eSign => "ลงนามอิเล็กทรอนิกส์";

  @override
  String get bookNo => "เลขที่หนังสือ";

  @override
  String get signDate => "ลงวันที่";

  @override
  String get signTopic => "ชื่อเรื่อง";

  @override
  String get signLevel => "ระดับการลงนาม";

  @override
  String get signPosition => "ตำแหน่งผู้ลงนาม";

  @override
  String get certificate => "ใบรับรอง";

  @override
  String get certificatePassword => "รหัสผ่านใบรับรอง";

  @override
  String get useDefaultSignature => "ใช้ลายเซ็นอิเล็กทรอนิกส์ที่จัดเก็บในระบบ";

  @override
  String get useNewSignature => "ลงนามลายเซ็นอิเล็กทรอนิกส์ใหม่";

  @override
  String get commentDocument => "คอมเมนต์เอกสาร";

  @override
  String get bookInformation => "ข้อมูลหนังสือ";

  @override
  String get bookDetail => "รายละเอียดหนังสือ";

  @override
  String get year => "ปี";

  @override
  String get bookType => "ประเภทหนังสือ";

  @override
  String get from => "จาก";

  @override
  String get to => "ถึง";

  @override
  String get topic => "เรื่อง";

  @override
  String get order => "สั่งการ";

  @override
  String get saveTheOrderOffer => "บันทึกคำสั่งการ / คำเสนอ";

  @override
  String get conclusion => "สรุปเนื้อหา";

  @override
  String get searchListTitle => "รายการหนังสือ";

  @override
  String get acceptCircular => "รับทราบหนังสือเวียนใหม่";

  @override
  String get acceptBook => "รับทราบหนังสือ";

  @override
  String get askForAcceptCircularBook =>
      "คุณต้องการรับทราบหนังสือเวียนฉบับนี้หรือ ไม่";

  @override
  String get acceptBookSuccess => "รับทราบหนังสือเวียนเรียบร้อยแล้ว";

  @override
  String get upToDate => "ถึงวันที่";

  @override
  String get datedBook => "หนังสือลงวันที่";

  @override
  String get search => "ค้นหา";

  @override
  String get clearFilter => "ล้างค่า";

  @override
  String get bookSearch => "ค้นหารายการหนังสือ";

  @override
  String get movementTable => "ตารางความเคลื่อนไหว";

  @override
  String get noMovementTable => "ไม่พบตารางความเคลื่อนไหว";

  @override
  String get pathDiagram => "แผนภาพเส้นทางเดินหนังสือ";

  @override
  String get registerValidateMessage => "กรุณาระบุ host name และ user name";

  @override
  String get registerErrorMessage =>
      "ไม่สามารถลงทะเบียนได้กรุณาตรวจสอบข้อมูล host name และ user name";

  @override
  String get errorNoConnection =>
      "เกิดข้อผิดพลาด กรุณาตรวจสอบการเชื่อมต่อ \nของท่านและลองใหม่อีกครั้ง";

  @override
  String get tryAgain => "ลองใหม่อีกครั้ง";

  @override
  String get pleaseInsertHostName => "กรุณาระบุ host name";

  @override
  String get testConnectionSarabun => "ทดสอบการเชื่อมต่อกับสารบรรณ";

  @override
  String get connectSuccess => "การเชื่อมต่อสำเร็จ";

  @override
  String get connectFailed => "การเชื่อมต่อไม่สำเร็จ";

  @override
  String get loginValidateMessage => "กรุณาระบุ user name และ password";

  @override
  String get cantLogin => "ไม่สามารถ login เข้าใช้งานระบบได้";

  @override
  String get greeting => "สวัสดีค่ะ";

  @override
  String get saveData => "บันทึกข้อมูล";

  @override
  String get confirmSaveSignature => "คุณต้องการบันทึกลายเซ็นนี้หรือไม่";

  @override
  String get saveSignatureSuccess => "บันทึกข้อมูลลายเซ็นเรียบร้อย";

  @override
  String get signatureIsRequired => "ต้องระบุภาพลายเซ็น";

  @override
  String get cameraPermissionTitle => "ต้องการเข้าถึงกล้อง";

  @override
  String get cameraPermission =>
      "การดำเนินการอนุญาตเข้าถึงกล้อง เพื่อความ\nสะดวกในการใช้งานในครั้งถัดไป โดยไปที่ \"ตั้งค่า\"";

  @override
  String get waitForSignNotFound => "ไม่พบข้อมูลรายการรอลงนาม";

  @override
  String get certificatePasswordIsRequired => "รหัสผ่านใบรับรองต้องมีค่า";

  @override
  String get sendRemarkIsRequired => "สรุปเนื้อหาต้องมีค่า";

  @override
  String get signPositionIsRequired => "ตำแหน่งผู้ลงนามต้องมีค่า";

  @override
  String get signatureIsRequired2 => "ลายเซ็นต้องมีค่า";

  @override
  String get confirmSignSave => "คุณต้องการบันทึกข้อมูลการลงนามฉบับนี้หรือไม่";

  @override
  String get signatureNotFoundTitle => "ไม่พบลายเซ็นอิเล็กทรอนิกส์ในระบบ";

  @override
  String get signatureNotFoundDetail =>
      "ท่านสามารถบันทึกลายเซ็นอิเล็กทรอนิกส์ใน \nระบบได้ที่ เมนูตั้งค่า \"จัดเก็บลายเซ็นอิเล็กทรอนิกส์\"";

  @override
  String get saveSignatureFailed => "เกิดข้อผิดพลาดขณะลงนามอิเล็กทรอนิกส์";

  @override
  String get saveESignatureSuccess =>
      "บันทึกข้อมูลลงนามอิเล็กทรอนิกส์เรียบร้อย";

  @override
  String get errorQrScan => "ไม่รอบรับ code นี้";

  @override
  String get fileTypeError => "ไม่รอบรับประเภทไฟล์นี้";

  @override
  String get noApplicationTitle => "ไม่พบแอปพลิเคชัน";

  @override
  String get noApplicationDetail => "กดตกลงเพื่อดาวน์โหลด";

  @override
  String get commentIsRequired => "กรุณาระบุคอมเมนต์";

  @override
  String get confirmSaveComment => "คุณต้องการบันทึกข้อมูลคอมเมนต์นี้หรือไม่";

  @override
  String get nameFilePath => "ชื่อไฟล์เส้นทางเดิน...";

  @override
  String get saveWaitForCommandFailed => "เกิดข้อผิดพลาดขณะลงนามคำสั่งการ";

  @override
  String get saveWaitForCommandSuccess => "บันทึกสั่งการของคุณเรียบร้อยแล้ว";

  @override
  String get listOverLimit =>
      "ผลการค้นหามีมากกว่า 1000 รายการ\nกรุณาระบุเงื่อนไขการค้นหาเพิ่มเติม";

  @override
  String get startDateMustBeforeEndDate =>
      "วันที่เริ่มต้นต้องน้อยกว่าวันที่สิ้นสุด";

  @override
  String get endDateIsRequired => "กรุณาระบุวันที่สิ้นสุด";

  @override
  String get startDateIsRequired => "กรุณาระบุวันที่เริ่มต้น";

  @override
  String get bookNotFound => "ไม่พบรายการข้อมูลหนังสือตามที่ค้นหา";

  @override
  String get waitForOrderNotFound => "ไม่พบข้อมูลรายการรอสั่งการ";

  @override
  String get circularBookNotFound => "ไม่พบข้อมูลรายการหนังสือเวียนใหม่";

  @override
  String get itemMovementDateSend => "วันเวลาส่ง";

  @override
  String get itemMovementTo => "ส่งจาก(ผู้ส่ง)";

  @override
  String get itemMovementDateReceive => "วันที่รับ";

  @override
  String get itemMovementOrgName => "หน่วยงานรับ/บุคคล";

  @override
  String get itemMovementStatus => "สถานะ รอรับ";

  @override
  String get office => "ระดับสำนักงาน/กอง/ศูนย์";

  @override
  String get askFaceScanMessage => "ขออนุญาตเข้าถึงข้อมูล\nการใช้งานระบบสแกนใบหน้า (Face ID)\nที่ท่านได้ทำการบันทึกไว้บนอุปกรณ์นี้\nเพื่อความสะดวกในการเข้าใข้งาน\nแอพพลิเคชั่น\nสารบรรณอิเล็กทรอนิกส์";

  @override
  String get allowButtonLabel => "อนุญาตเข้าถึงข้อมูล";

  @override
  String get askFingerprintMessage => "ขออนุญาตเข้าถึงข้อมูล\nการใช้งานระบบสแกนลายนิ้วมือ (Touch ID)\nที่ท่านได้ทำการบันทึก ไว้บนอุปกรณ์นี้\nเพื่อความสะดวกในการเข้าใข้งาน\nแอพพลิเคชั่น\nสารบรรณอิเล็กทรอนิกส์";

  @override
  String get skipLabel => "ข้ามขั้นตอนนี้";

  @override
  String get passcodeValidateLabel => "รหัส PIN ไม่ถูกต้อง";

  @override
  String get forgotPasscodeLabel => "ลืมรหัส PIN";
}
