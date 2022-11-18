import 'package:flutter/material.dart';
import 'package:flutter_workshop/src/core/config/di/cart_controller.dart';
import 'package:flutter_workshop/src/core/config/theme/light_color.dart';
import 'package:flutter_workshop/src/core/config/theme/theme.dart';
import 'package:flutter_workshop/src/core/widgets/custom_app_bar.dart';
import 'package:flutter_workshop/src/core/widgets/extentions.dart';
import 'package:flutter_workshop/src/data/enum/shopping_cart_mode.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class Header extends StatelessWidget {
  const Header(
      {Key? key,
      required this.headLine1,
      required this.headLine2,
      this.isShoppingCart = false,
      this.shoppingCartMode = ShoppingCartMode.normal,
      this.onPressedIcon})
      : super(key: key);

  final String headLine1;
  final String headLine2;
  final bool isShoppingCart;
  final ShoppingCartMode shoppingCartMode;
  final Function? onPressedIcon;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const CustomAppBar(),
        _title(),
      ],
    );
  }

  Widget _title() {
    return Container(
      margin: AppTheme.padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                headLine1,
                style: GoogleFonts.mulish(
                    fontSize: 27,
                    fontWeight: FontWeight.w400,
                    color: LightColor.titleTextColor),
              ),
              Text(
                headLine2,
                style: GoogleFonts.mulish(
                    fontSize: 27,
                    fontWeight: FontWeight.w700,
                    color: LightColor.titleTextColor),
              ),
            ],
          ),
          isShoppingCart && Get.find<CartController>().cartList.isNotEmpty
              ? Container(
                  padding: const EdgeInsets.all(10),
                  child: Icon(
                    shoppingCartMode == ShoppingCartMode.normal
                        ? Icons.edit_outlined
                        : Icons.close_outlined,
                    color: LightColor.orange,
                  ),
                ).ripple(() {
                  if (onPressedIcon != null) {
                    onPressedIcon!();
                  }
                }, borderRadius: const BorderRadius.all(Radius.circular(13)))
              : const SizedBox()
        ],
      ),
    );
  }
}
