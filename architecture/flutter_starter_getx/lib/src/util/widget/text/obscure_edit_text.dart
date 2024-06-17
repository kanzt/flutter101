import 'package:flutter/material.dart';
import 'package:flutter_starter/src/resource/assets/assets.dart';
import 'package:flutter_starter/src/resource/color/color_assets.dart';
import 'package:flutter_starter/src/util/extension/size_util.dart';
import 'package:flutter_starter/src/util/widget/text/edit_text.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ObscureEditText extends StatefulWidget {
  const ObscureEditText(
      {Key? key, this.controller, required this.hintText})
      : super(key: key);

  final TextEditingController? controller;
  final String hintText;

  @override
  State<ObscureEditText> createState() => _ObscureEditTextState();
}

class _ObscureEditTextState extends State<ObscureEditText> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return EditText(
      width: 327.rh,
      height: 48.rv,
      controller: widget.controller,
      obscureText: _obscureText,
      hintText: widget.hintText,
      textColor: ColorAssets.brightNavyBlue,
      prefixIcon: const Icon(
        Icons.lock_outline_sharp,
        size: 16,
        color: ColorAssets.brightNavyBlue,
      ),
      suffixIcon: ClipOval(
        child: Material(
          color: Colors.transparent,
          child: GestureDetector(
            onLongPressDown: (details){
              setState(() {
                _obscureText = false;
              });
            },
            onLongPressCancel: (){
              setState(() {
                _obscureText = true;
              });
            },
            onLongPressUp: () {
              setState(() {
                _obscureText = true;
              });
            },
            child: IconButton(
              splashRadius: 16,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              icon: SvgPicture.asset(
                Assets.eyePassword,
                color: ColorAssets.brightNavyBlue,
              ),
              onPressed: () {},
            ),
          ),
        ),
      ),
    );
  }
}
