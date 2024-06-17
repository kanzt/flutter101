import 'package:flutter/material.dart';
import 'package:flutter_starter/src/resource/assets/assets.dart';
import 'package:flutter_starter/src/resource/color/color_assets.dart';
import 'package:flutter_starter/src/resource/language/language.dart';
import 'package:flutter_starter/src/resource/language/language_size.dart';
import 'package:flutter_starter/src/resource/language/language_type.dart';
import 'package:flutter_starter/src/util/widget/component/rounded_button.dart';
import 'package:flutter_starter/src/util/widget/text/text_style_show.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class WarningDialog extends StatefulWidget {
  final String? title;
  final String? pressedTitle;
  final String? detail;
  final String? svgImage;
  final String? lottieImage;
  final VoidCallback? onPositive;

  @override
  State<WarningDialog> createState() => _WarningDialogState();
  WarningDialog({this.title, this.pressedTitle, this.detail,this.svgImage,this.lottieImage,this.onPositive});
}

class _WarningDialogState extends State<WarningDialog> {
  late final Languages _language;
  String? _pressedTitle;
  String? _title;
  late String? _detail;
  VoidCallback? _onPositive;
  String? _imageSvg;
  String? _imageLottie;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _language = Languages.of(context)!;
    _title = widget.title ?? _language.dialogWarningTitle;
    _pressedTitle = widget.pressedTitle ?? _language.dialogWarningPressedTitle;
    _detail = widget.detail;
    _imageSvg = widget.svgImage??Assets.dialogWarning;
    _imageLottie = widget.lottieImage;
    _onPositive = widget.onPositive;
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
          padding: EdgeInsets.only( bottom: 20,),
          width: 343,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 32, bottom: 23),
                child:
                widget.lottieImage == null? SvgPicture.asset(width:117,height: 113, _imageSvg!): Lottie.asset(width:117,height: 113,_imageLottie!, repeat: false),
              ),
              TextStyleShow(
                text: _title!,
                languageSize: LanguageSize.size18,
                languageType: LanguageType.bold,
                color: ColorAssets.deepSapphire,
                textAlign: TextAlign.center,
              ),

              Visibility(
                visible: _detail?.isBlank == false,
                child: Padding(
                padding: EdgeInsets.only(top: 6),
                child: TextStyleShow(
                  text: _detail??"",
                  languageSize: LanguageSize.size16,
                  languageType: LanguageType.regular,
                  color: ColorAssets.raven,
                  textAlign: TextAlign.center,
                ),
              )),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: RoundedButton(
                    width: 99,
                    height: 33,
                    circular: 24,
                    buttonLabel: _pressedTitle!,
                    isOutline: false,
                    onPressed: () {
                      if(_onPositive!=null){
                        _onPositive!();
                      }
                      Get.back();
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
