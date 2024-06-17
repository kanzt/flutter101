import 'package:flutter/material.dart';
import 'package:flutter_starter/src/resource/color/color_assets.dart';
import 'package:flutter_starter/src/resource/language/language_size.dart';
import 'package:flutter_starter/src/resource/language/language_type.dart';
import 'package:flutter_starter/src/util/widget/text/text_style_show.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';

class ShowDialog extends StatefulWidget {
  final String detail;
  final String? svgImage;
  final String? lottieImage;

  @override
  State<ShowDialog> createState() => _ShowDialogState();
  ShowDialog({required this.detail,this.svgImage,this.lottieImage});
}

class _ShowDialogState extends State<ShowDialog> {
  late String _detail;
   String? _svgImage;
   String? _lottieImage;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _detail = widget.detail;
    _svgImage = widget.svgImage;
    _lottieImage = widget.lottieImage;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
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
                child: widget.lottieImage == null? SvgPicture.asset(width:117,height: 113, _svgImage!): Lottie.asset(width:117,height: 113,_lottieImage!),
              ),
              TextStyleShow(
                text: _detail,
                languageSize: LanguageSize.size18,
                languageType: LanguageType.medium,
                color: ColorAssets.deepSapphire,
              ),
            ],
          ),
        ),
    );
  }
}
