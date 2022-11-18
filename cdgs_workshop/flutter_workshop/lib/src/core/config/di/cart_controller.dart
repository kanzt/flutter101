
import 'package:flutter_workshop/src/data/model/enitiy/cart_item.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
  List<CartItem> cartList = [];

  int get cartTotal => cartList.length;

  void addItemToCart(CartItem cartItem){
    final cartItemInCartList = cartList.firstWhereOrNull((element) => element.product.id == cartItem.product.id);

    if(cartItemInCartList != null){
      cartItemInCartList.quantity += 1;
    }else{
      cartList.add(cartItem);
    }

    update();
  }

  void deleteItemFromCart(){
    cartList = cartList.where((element) => !element.isSelected).toList();

    update();
  }

  double getPrice() {
    double price = 0;
    for (var x in cartList) {
      price += x.product.price * x.quantity;
    }
    return price;
  }

  void setSelected(CartItem item, bool value) {
    item.isSelected = value;

    update();
  }

  void resetSelectedItem() {
    cartList = cartList.map((e){
      e.isSelected = false;
      return e;
    }).toList();

    update();
  }
}