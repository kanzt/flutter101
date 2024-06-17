import 'package:flutter/material.dart';
import 'package:flutter_starter/src/resource/assets/assets.dart';
import 'package:flutter_starter/src/resource/color/color_assets.dart';
import 'package:flutter_starter/src/resource/language/language_size.dart';
import 'package:flutter_starter/src/resource/language/language_type.dart';
import 'package:flutter_starter/src/util/widget/text/edit_text.dart';
import 'package:flutter_starter/src/util/widget/text/text_style_show.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SearchEditText extends StatelessWidget {
  const SearchEditText({
    Key? key,
    required this.label,
    this.controller,
    this.onTap,
    this.onClear,
  }) : super(key: key);

  final String label;
  final TextEditingController? controller;
  final VoidCallback? onTap;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextStyleShow(
          text: label,
          languageSize: LanguageSize.size16,
          languageType: LanguageType.medium,
        ),
        SizedBox(
          height: 10,
        ),
        EditText(
          width: double.infinity,
          controller: controller,
          onTap: onTap,
          isReadOnly: onTap != null,
          contentPadding: EdgeInsets.all(8),
          hintText: label,
          suffixIcon: controller?.text.isNotEmpty == true
              ? IconButton(
                  onPressed: () {
                    if (onClear != null) {
                      onClear!();
                    }
                  },
                  icon: SvgPicture.asset(Assets.del2),
                )
              : null,
          borderColor: ColorAssets.lavenderGray,
        ),
      ],
    );
  }
}
