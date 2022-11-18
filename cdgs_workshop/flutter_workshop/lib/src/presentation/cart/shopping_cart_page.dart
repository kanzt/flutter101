import 'package:flutter/material.dart';
import 'package:flutter_workshop/src/core/config/di/cart_controller.dart';
import 'package:flutter_workshop/src/core/widgets/header.dart';
import 'package:flutter_workshop/src/presentation/cart/shopping_cart_content.dart';
import 'package:flutter_workshop/src/presentation/cart/shopping_cart_page_controller.dart';
import 'package:get/get.dart';

class ShoppingCartPage extends StatelessWidget {
  const ShoppingCartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GetBuilder<ShoppingCartPageController>(
          init: ShoppingCartPageController(),
          builder: (ShoppingCartPageController controller) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Header(
                  headLine1: 'Shopping',
                  headLine2: 'Cart',
                  isShoppingCart: true,
                  shoppingCartMode: controller.shoppingCartMode,
                  onPressedIcon: () {
                    controller.toggleMode();
                    Get.find<CartController>().resetSelectedItem();
                  },
                ),
                Expanded(
                    child: ShoppingCartContent(
                        shoppingCartMode: controller.shoppingCartMode)),
              ],
            );
          },
        ),
      ),
    );
  }
}
