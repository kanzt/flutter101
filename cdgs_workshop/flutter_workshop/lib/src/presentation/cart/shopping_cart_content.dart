import 'package:flutter/material.dart';
import 'package:flutter_workshop/src/core/config/di/cart_controller.dart';
import 'package:flutter_workshop/src/core/config/theme/light_color.dart';
import 'package:flutter_workshop/src/core/config/theme/theme.dart';
import 'package:flutter_workshop/src/core/widgets/title_text.dart';
import 'package:flutter_workshop/src/data/enum/available_color.dart';
import 'package:flutter_workshop/src/data/enum/available_size.dart';
import 'package:flutter_workshop/src/data/enum/shopping_cart_mode.dart';
import 'package:flutter_workshop/src/data/model/enitiy/cart_item.dart';
import 'package:flutter_workshop/src/presentation/cart/shopping_cart_page_controller.dart';
import 'package:get/get.dart';

class ShoppingCartContent extends StatelessWidget {
  ShoppingCartContent({Key? key, required this.shoppingCartMode}) : super(key: key);

  final _cartController = Get.find<CartController>();
  final _shoppingCartPageController = Get.find<ShoppingCartPageController>();
  final shoppingCartMode;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppTheme.padding,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _cartItems(),
            const Divider(
              thickness: 1,
              height: 70,
            ),
            _price(),
            const SizedBox(height: 30),
            _submitButton(context),
          ],
        ),
      ),
    );
  }

  Widget _cartItems() {
    // return Column(children: AppData.cartList.map((x) => _item(x)).toList());

    return SizedBox(
      height: AppTheme.fullHeight(Get.context!) * 0.5,
      child:
      _cartController.cartTotal > 0 ?
      GetBuilder<CartController>(
        builder: (CartController controller){
          return ListView.builder(
              itemCount: controller.cartTotal, itemBuilder: (ctx, index) {
            return _item(controller.cartList[index]);
          });
        },
      ) : const Center(
                    child:  TitleText(
                              text: 'Cart is empty',
                              color: LightColor.grey,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                    ),
          ),
    );
  }

  Widget _item(CartItem item) {
    return SizedBox(
      height: 80,
      child: Row(
        children: <Widget>[
          if(shoppingCartMode == ShoppingCartMode.delete)
          Checkbox(
            value: item.isSelected,
            activeColor: LightColor.orange,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5)),
            onChanged: (bool? value) {
              _cartController.setSelected(item, value!);
            },
          ),
          // สร้างพื้นที่เพื่อแสดงรูปรองเท้าออกมานอกกรอบ
          AspectRatio(
            aspectRatio: 1.2,
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.bottomLeft,
                  child: SizedBox(
                    height: 70,
                    width: 70,
                    child: Stack(
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                              color: LightColor.lightGrey,
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: -20,
                  bottom: -20,
                  child: Image.asset(
                    item.product.image,
                    height: 114,
                    width: 127,
                  ),
                )
              ],
            ),
          ),
          Expanded(
              child: ListTile(
                  title: TitleText(
                    text: item.product.name,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          TitleText(
                            text: item.size.size,
                            color: LightColor.grey,
                            fontSize: 12,
                          ),
                          const SizedBox(width: 8,),
                          TitleText(
                            text: item.color.colorName,
                            color: LightColor.grey,
                            fontSize: 12,
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          const TitleText(
                            text: '\$ ',
                            color: LightColor.red,
                            fontSize: 12,
                          ),
                          TitleText(
                            text: item.product.price.toString(),
                            fontSize: 14,
                          ),
                        ],
                      ),
                    ],
                  ),
                  trailing: shoppingCartMode == ShoppingCartMode.normal ? Container(
                    width: 35,
                    height: 35,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: LightColor.lightGrey.withAlpha(150),
                        borderRadius: BorderRadius.circular(10)),
                    child: TitleText(
                      text: 'x${item.quantity}',
                      fontSize: 12,
                    ),
                  ) : const SizedBox()))
        ],
      ),
    );
  }

  Widget _price() {
    return Visibility(
      visible: shoppingCartMode == ShoppingCartMode.normal,
      maintainState: true,
      maintainAnimation: true,
      maintainSize: true,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          TitleText(
            text: '${_cartController.cartTotal} Items',
            color: LightColor.grey,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          TitleText(
            text: '\$${_cartController.getPrice()}',
            fontSize: 18,
          ),
        ],
      ),
    );
  }

  Widget _submitButton(BuildContext context) {
    return Column(
      children: [
        TextButton(
          onPressed: _cartController.cartTotal > 0 ? () {
            if(shoppingCartMode == ShoppingCartMode.normal){

            }else{
              _cartController.deleteItemFromCart();
              _shoppingCartPageController.toggleMode();
            }
          } : null,
          style: ButtonStyle(
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            ),
            backgroundColor:
                MaterialStateProperty.all<Color>(_cartController.cartTotal > 0 ? LightColor.orange : LightColor.grey),
          ),
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 4),
            width: AppTheme.fullWidth(context) * .75,
            child: TitleText(
              text: shoppingCartMode == ShoppingCartMode.normal ? 'Buy' : 'Remove selected items',
              color: LightColor.background,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        // _submitButtonWithElevatedButton(),
      ],
    );
  }

  Widget _submitButtonWithElevatedButton(){
    return SizedBox(
      width: 310.5,
      height: 46,
      child: ElevatedButton(
        onPressed: () {},
        style: ButtonStyle(
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          ),
          backgroundColor:
              MaterialStateProperty.all<Color>(LightColor.orange),
        ),
        child: Container(
          alignment: Alignment.center,
          child: const TitleText(
            text: 'Buy',
            color: LightColor.background,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
