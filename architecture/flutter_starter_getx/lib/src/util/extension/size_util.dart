import 'package:get/get.dart';

var _decidedWidth = 375;
var _decidedHeight = 667;

var _widthPercent = (int size) => ((size / _decidedWidth) * 100).truncate();
var _heightPercent = (int size) => ((size / _decidedHeight) * 100).truncate();

/// ใช้สำหรับคำนวณ % ของ Widget ตามดีไซน์ใน XD เทียบกับอุปกรณ์จริง
extension Resolution on int{

  double get rh => (Get.width * (_widthPercent(this) / 100));

  double get rv => (Get.height * (_heightPercent(this) / 100));

  double get rt => (Get.width * (_widthPercent(this) / 100));
}

