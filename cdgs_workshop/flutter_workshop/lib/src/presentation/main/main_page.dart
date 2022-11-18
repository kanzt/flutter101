import 'package:flutter/material.dart';
import 'package:flutter_workshop/src/core/config/di/auth_controller.dart';
import 'package:flutter_workshop/src/core/config/di/cart_controller.dart';
import 'package:flutter_workshop/src/core/constant/assets.dart';
import 'package:flutter_workshop/src/core/config/route/routes.dart';
import 'package:flutter_workshop/src/core/config/theme/light_color.dart';
import 'package:flutter_workshop/src/core/widgets/custom_confirm_dialog.dart';
import 'package:flutter_workshop/src/core/widgets/header.dart';
import 'package:flutter_workshop/src/core/widgets/title_text.dart';
import 'package:flutter_workshop/src/presentation/main/main_page_controller.dart';
import 'package:flutter_workshop/src/presentation/main/widgets/main_content.dart';
import 'package:get/get.dart';

class MainPage extends StatelessWidget {
  MainPage({Key? key}) : super(key: key);

  final _mainPageController = Get.put(MainPageController());
  final _authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await showDialog(
            context: context,
            builder: (ctx) {
          return CustomConfirmDialog(
            title: 'ยืนยันปิดแอปพลิเคชัน ?',
            description: '',
            positiveText: "ยืนยัน",
            negativeText: "ยกเลิก",
            positiveColor: LightColor.orange,
            assetImage: Assets.logout,
            positiveHandler: () async {
               _authController.endSession();
            },
            negativeHandler: () async {

            },
          );
        });
        return Future.value(false);
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Header(headLine1: 'Our', headLine2: 'Products'),
              Expanded(child: MainContent()),
            ],
          ),
        ),
        floatingActionButton: _flotingButton(),
      ),
    );
  }

  Widget _flotingButton() {
    return FloatingActionButton(
      onPressed: () {
        Get.toNamed(Routes.shoppingCartPage);
        // Navigator.of(context).pushNamed(Routes.shoppingCartPage);
      },
      backgroundColor: LightColor.orange,
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: Align(
          alignment: Alignment.center,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Icon(Icons.shopping_basket,
                    color: Theme.of(Get.context!)
                        .floatingActionButtonTheme
                        .backgroundColor),
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  width: 22,
                  height: 22,
                  padding: const EdgeInsets.only(left: 1),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: LightColor.orange),
                    color: Colors.white,
                  ),
                  child: GetBuilder<CartController>(
                    builder: (CartController controller) {
                      return TitleText(
                        text: "${controller.cartTotal}",
                        color: LightColor.orange,
                        fontSize: 12,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
