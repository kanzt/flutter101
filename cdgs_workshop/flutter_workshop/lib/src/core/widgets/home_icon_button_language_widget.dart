import 'package:flutter/material.dart';
import 'package:flutter_workshop/src/core/config/di/application_controller.dart';
import 'package:flutter_workshop/src/core/constant/assets.dart';
import 'package:flutter_workshop/src/core/widgets/title_text.dart';
import 'package:flutter_workshop/src/core/widgets/triangle_shape_widget.dart';
import 'package:flutter_workshop/src/presentation/setting/setting_page_controller.dart';
import 'package:get/get.dart';

class HomeIconButtonLanguageWidget extends StatelessWidget {
  HomeIconButtonLanguageWidget({Key? key}) : super(key: key);

  final _settingPageController = Get.find<SettingPageController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingPageController>(
      builder: (SettingPageController _) {
        return WillPopScope(
          onWillPop: _settingPageController.onWillPop,
          child: Container(
            color: Colors.transparent,
            child: Material(
              color: Colors.transparent,
              child: IconButton(
                key: _settingPageController.languageButtonKey,
                iconSize: 31,
                splashRadius: 24,
                icon: Image.asset(
                  Get.locale.toString() == "th"
                      ? Assets.icThailandFlag
                      : Assets.icEnglandFlag,
                  width: 31,
                  height: 31,
                ),
                onPressed: () {
                  _settingPageController.toggleMenu(
                      context, _overlayEntryBuilder());
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLanguageButtonItem(
      BuildContext context, String text, String languageCode, String asset) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(8.0), topRight: Radius.circular(8.0)),
        onTap: () {
          Get.find<ApplicationController>().changeLanguage(languageCode);
          _settingPageController.onMenuClosed();
        },
        child: Ink(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Image.asset(
                asset,
                width: 31,
                height: 31,
              ),
              Container(
                  color: Colors.transparent,
                  margin: const EdgeInsets.only(left: 11),
                  child: TitleText(
                    text: text,
                    fontWeight: FontWeight.w400,
                  )),
            ],
          ),
        ),
      ),
    );
  }

  OverlayEntry _overlayEntryBuilder() {
    return OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            Positioned(
              top: _settingPageController.buttonPosition.dy +
                  _settingPageController.buttonSize.height,
              left: _settingPageController.buttonPosition.dx + 8 + 4,
              child: CustomPaint(
                  size: const Size(20, 20), painter: DrawTriangleShape()),
            ),
            Positioned(
              top: _settingPageController.buttonPosition.dy +
                  _settingPageController.buttonSize.height +
                  20,
              left: _settingPageController.buttonPosition.dx - 80,
              child: Stack(
                children: [
                  Container(
                    width: 125,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.transparent,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                      color: Colors.white,
                      // boxShadow: [
                      //   BoxShadow(
                      //     spreadRadius: 3,
                      //     color: Colors.grey.shade300,
                      //     offset: const Offset(0.0, 3.0), //(x,y)
                      //     blurRadius: 6.0,
                      //   ),
                      // ],
                    ),
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            _buildLanguageButtonItem(
                                context, "ไทย", "th", Assets.icThailandFlag),
                            _buildLanguageButtonItem(
                                context, "English", "en", Assets.icEnglandFlag),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
