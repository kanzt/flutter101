import 'package:flutter_workshop/src/data/enum/available_color.dart';
import 'package:flutter_workshop/src/data/enum/available_size.dart';
import 'package:flutter_workshop/src/data/model/remote/product.dart';
import 'package:flutter_workshop/src/presentation/detail/product_detail_page.dart';
import 'package:get/get.dart';

class ProductDetailPageController extends GetxController {
  List<AvailableSize> availableSize = [];
  AvailableSize selectedSize = AvailableSize.us7;

  List<AvailableColor> availableColor = [];
  AvailableColor selectedColor = AvailableColor.yellow;

  late Product product;

  @override
  void onInit() {
    super.onInit();

    for (var value in AvailableSize.values) {
      availableSize.add(value);
    }

    for (var value in AvailableColor.values) {
      availableColor.add(value);
    }

    _receiveArguments();
  }

  void setSelectedSize(AvailableSize size){
    selectedSize = size;

    update();
  }

  void setSelectedColor(AvailableColor color){
    selectedColor = color;

    update();
  }

  void _receiveArguments() {
    final args = Get.arguments;
    product = args[0][ProductDetailPage.productArg];
  }
}
