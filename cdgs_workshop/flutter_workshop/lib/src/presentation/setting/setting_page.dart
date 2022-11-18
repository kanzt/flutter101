import 'package:flutter/material.dart';
import 'package:flutter_workshop/src/core/config/di/auth_controller.dart';
import 'package:flutter_workshop/src/core/config/locale/languages/languages.dart';
import 'package:flutter_workshop/src/core/config/theme/light_color.dart';
import 'package:flutter_workshop/src/core/config/theme/theme.dart';
import 'package:flutter_workshop/src/core/widgets/appbar_icon_button.dart';
import 'package:flutter_workshop/src/core/widgets/extentions.dart';
import 'package:flutter_workshop/src/core/widgets/home_icon_button_language_widget.dart';
import 'package:flutter_workshop/src/core/widgets/title_text.dart';
import 'package:flutter_workshop/src/presentation/setting/setting_page_controller.dart';
import 'package:get/get.dart';

class SettingPage extends StatelessWidget {
  SettingPage({Key? key}) : super(key: key);

  late Languages languages;

  final _authController = Get.find<AuthController>();

  final _settingPageController = Get.put(SettingPageController());

  @override
  Widget build(BuildContext context) {
    languages = Languages.of(context)!;
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: AppTheme.fullWidth(context),
          height: AppTheme.fullHeight(context),
          child: Column(
            children: <Widget>[
              _appBar(),
              Expanded(
                child: _content(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _appBar() {
    return Container(
      padding: AppTheme.padding,
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              AppbarIconButton(
                Icons.arrow_back_ios,
                iconColor: Colors.black54,
                boxShadow: const [],
                onPressed: () {
                  _settingPageController.onWillPop();
                  Get.back();
                  // Navigator.of(context).pop();
                },
              ),
              HomeIconButtonLanguageWidget(),
            ],
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: TitleText(text: languages.setting),
            ),
          ),
        ],
      ),
    );
  }

  Widget _content() {
    return Container(
      height: AppTheme.fullHeight(Get.context!),
      color: Colors.white,
      child: Stack(
        children: [
          Container(
            height: 180,
            width: AppTheme.fullWidth(Get.context!),
            color: LightColor.orange,
          ),
          Positioned(
            top: 150,
            child: Container(
              width: AppTheme.fullWidth(Get.context!),
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0)),
              ),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: LightColor.iconColor,
                      ),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(12.0)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.logout_outlined),
                        const SizedBox(
                          width: 16,
                        ),
                        TitleText(
                          text: languages.logout,
                          fontWeight: FontWeight.w400,
                        ),
                      ],
                    ),
                  ).ripple(
                    () {
                      _authController.endSession();
                    },
                    borderRadius: const BorderRadius.all(
                      Radius.circular(12.0),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
