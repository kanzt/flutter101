import 'package:flutter/material.dart';
import 'package:flutter_workshop/src/core/config/theme/light_color.dart';
import 'package:flutter_workshop/src/core/config/theme/theme.dart';
import 'package:flutter_workshop/src/core/type/type.dart';
import 'package:flutter_workshop/src/core/widgets/extentions.dart';
import 'package:flutter_workshop/src/data/model/remote/category.dart';
import 'package:google_fonts/google_fonts.dart';


class CategoryItem extends StatelessWidget {
  const CategoryItem({
    Key? key,
    required this.category,
    this.onSelected,
  }) : super(key: key);

  final Category category;
  final OnSelected? onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      child: Container(
        padding: AppTheme.hPadding,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          color:
              category.isSelected ? LightColor.background : Colors.transparent,
          border: Border.all(
            color: category.isSelected ? LightColor.orange : LightColor.grey,
            width: category.isSelected ? 2 : 1,
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color:
                  category.isSelected ? const Color(0xfffbf2ef) : Colors.white,
              blurRadius: 10,
              spreadRadius: 5,
              offset: const Offset(5, 5),
            ),
          ],
        ),
        child: Row(
          children: <Widget>[
            Image.asset(
              category.image,
              height: 40,
            ),
            Text(category.name,
                style: GoogleFonts.mulish(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: LightColor.titleTextColor,
                ))
          ],
        ),
      ).ripple(
        () {
          if(onSelected != null){
            onSelected!(category);
          }
        },
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
    );
  }
}
