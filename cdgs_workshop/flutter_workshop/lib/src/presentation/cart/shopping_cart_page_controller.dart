import 'package:flutter_workshop/src/data/enum/shopping_cart_mode.dart';
import 'package:get/get.dart';

class ShoppingCartPageController extends GetxController {
  ShoppingCartMode _shoppingCartMode = ShoppingCartMode.normal;

  ShoppingCartMode get shoppingCartMode => _shoppingCartMode;

  toggleMode(){

    _shoppingCartMode = _shoppingCartMode.toggle();

    update();
  }
}