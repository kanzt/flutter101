import 'package:flutter/material.dart';
import 'package:flutter_workshop/src/core/config/di/cart_controller.dart';
import 'package:flutter_workshop/src/core/config/theme/light_color.dart';
import 'package:flutter_workshop/src/core/widgets/extentions.dart';
import 'package:flutter_workshop/src/core/widgets/title_text.dart';
import 'package:get/get.dart';

class AppbarIconButton extends StatelessWidget {
  const AppbarIconButton(
    this.icon, {
    Key? key,
    this.onPressed,
    this.borderColor = Colors.black54,
    this.iconColor = LightColor.iconColor,
    this.size = 15,
    this.padding = 12,
    this.isOutLine = true,
    this.boxShadow = const [
      BoxShadow(
        color: Color(0xfff8f8f8),
        blurRadius: 5,
        spreadRadius: 10,
        offset: Offset(5, 5),
      ),
    ],
    this.backgroundColor = Colors.transparent,
  }) : super(key: key);

  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;
  final Color borderColor;
  final double size;
  final double padding;
  final bool isOutLine;
  final List<BoxShadow>? boxShadow;
  final Function? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      padding: EdgeInsets.all(padding),
      // margin: EdgeInsets.all(padding),
      decoration: BoxDecoration(
          border: Border.all(
              color: borderColor,
              style: isOutLine ? BorderStyle.solid : BorderStyle.none),
          borderRadius: const BorderRadius.all(Radius.circular(13)),
          color: isOutLine
              ? (boxShadow != null ? Colors.transparent : backgroundColor)
              : Theme.of(context).backgroundColor,
          boxShadow: boxShadow),
      child: Padding(
          padding: EdgeInsets.only(left: icon == Icons.arrow_back_ios ? 2 : 0),
          child: Stack(
            children: [
              Align(
                  alignment: Alignment.center,
                  child: Icon(icon, color: iconColor, size: size)),
              if (icon == Icons.shopping_basket)
                Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      width: 18,
                      height: 18,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: LightColor.orange),
                        // color: const Color(0XFF02AADA).withOpacity(0.9),
                        color: LightColor.orange.withOpacity(0.9),
                      ),
                      child: GetBuilder<CartController>(
                        builder: (CartController controller) {
                          return TitleText(
                            text: "${controller.cartTotal}",
                            color: Colors.white,
                            fontSize: 10,
                          );
                        },
                      ),
                    ))
            ],
          )),
    ).ripple(() {
      if (onPressed != null) {
        onPressed!();
      }
    }, borderRadius: const BorderRadius.all(Radius.circular(13)));
  }
}
