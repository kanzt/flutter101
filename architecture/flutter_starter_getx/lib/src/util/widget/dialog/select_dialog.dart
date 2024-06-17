import 'package:flutter/material.dart';
import 'package:flutter_starter/src/resource/color/color_assets.dart';
import 'package:flutter_starter/src/resource/language/language.dart';
import 'package:flutter_starter/src/resource/language/language_size.dart';
import 'package:flutter_starter/src/resource/language/language_type.dart';
import 'package:flutter_starter/src/util/widget/component/rounded_button.dart';
import 'package:flutter_starter/src/util/widget/text/text_style_show.dart';
import 'package:get/get.dart';

class SelectDialog extends StatefulWidget {
  final String title;
  final String detail;
  final String? positiveTitle;
  final String? negativeTitle;
  final VoidCallback? onPositive;
  final VoidCallback? onNegative;
  final bool? isDismissDialog;

  @override
  State<SelectDialog> createState() => _SelectDialogState();

  SelectDialog(
      {required this.title,
      required this.detail,
      this.positiveTitle,
      this.negativeTitle,
      this.onPositive,
      this.onNegative,
      this.isDismissDialog});
}

class _SelectDialogState extends State<SelectDialog> {
  late final Languages _language;
  String? _positiveTitle;
  String? _negativeTitle;
  VoidCallback? _onPositive;
  VoidCallback? _onNegative;
  bool? _isDismissDialog;
  String? _title;
  late String? _detail;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _language = Languages.of(context)!;
    _title = widget.title;
    _detail = widget.detail;
    _positiveTitle = widget.positiveTitle ?? _language.agree;
    _negativeTitle = widget.negativeTitle ?? _language.cancel;
    _onPositive = widget.onPositive;
    _isDismissDialog = widget.isDismissDialog ?? true;
    _onNegative = widget.onNegative;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 0),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        child: Container(
          padding: EdgeInsets.only(
            bottom: 20,
          ),
          width: 343,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20.0, left: 22),
                child: Row(
                  children: [
                    TextStyleShow(
                      text: _title!,
                      languageSize: LanguageSize.size18,
                      languageType: LanguageType.bold,
                      color: ColorAssets.deepSapphire,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5.0, left: 22),
                child: Row(
                  children: [
                    TextStyleShow(
                      text: _detail!,
                      languageSize: LanguageSize.size16,
                      languageType: LanguageType.regular,
                      color: ColorAssets.raven,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 18),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RoundedButton(
                        width: 99,
                        height: 33,
                        circular: 24,
                        buttonLabel: _negativeTitle!,
                        isOutline: true,
                        onPressed: () {
                          Get.back();
                          if (_onNegative != null) {
                            _onNegative!();
                          }
                        }),
                    SizedBox(
                      width: 10,
                    ),
                    RoundedButton(
                        width: 99,
                        height: 33,
                        circular: 24,
                        buttonLabel: _positiveTitle!,
                        isOutline: false,
                        onPressed: () {
                          if (_isDismissDialog == true) {
                            Get.back();
                          }
                          if (_onPositive != null) {
                            _onPositive!();
                          }
                        }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
