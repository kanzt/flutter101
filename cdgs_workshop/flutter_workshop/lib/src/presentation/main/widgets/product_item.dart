import 'package:flutter/material.dart';
import 'package:flutter_workshop/src/core/config/theme/light_color.dart';
import 'package:flutter_workshop/src/core/type/type.dart';
import 'package:flutter_workshop/src/core/widgets/extentions.dart';
import 'package:flutter_workshop/src/data/model/remote/product.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({Key? key, required this.product, this.onSelected}) : super(key: key);

  final Product product;

  final OnSelected? onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: LightColor.background,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        boxShadow: <BoxShadow>[
          BoxShadow(color: Color(0xfff8f8f8), blurRadius: 15, spreadRadius: 10),
        ],
      ),
      margin: EdgeInsets.symmetric(vertical: !product.isSelected ? 20 : 0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Stack(
          children: <Widget>[
            Positioned(
              left: 0,
              top: 0,
              child: IconButton(
                icon: Icon(
                  product.isliked ? Icons.favorite : Icons.favorite_border,
                  color:
                      product.isliked ? LightColor.red : LightColor.iconColor,
                ),
                onPressed: () {},
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                SizedBox(height: product.isSelected ? 15 : 0),
                Expanded(
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: LightColor.orange.withAlpha(40),
                      ),
                      Image.asset(product.image, height: 178, width: 166,)
                    ],
                  ),
                ),
                // SizedBox(height: 5),
                Text(
                  product.name,
                  style: GoogleFonts.mulish(
                    fontSize: product.isSelected ? 16 : 14,
                    fontWeight: FontWeight.w800,
                    color: LightColor.titleTextColor,
                  ),
                ),
                Text(
                  product.category,
                  style: GoogleFonts.mulish(
                    fontSize: product.isSelected ? 14 : 12,
                    fontWeight: FontWeight.w800,
                    color: LightColor.orange,
                  ),
                ),
                Text(
                  product.price.toString(),
                  style: GoogleFonts.mulish(
                    fontSize: product.isSelected ? 18 : 16,
                    fontWeight: FontWeight.w800,
                    color: LightColor.titleTextColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ).ripple(() {
        if(onSelected != null){
          onSelected!(product);
        }
      }, borderRadius: const BorderRadius.all(Radius.circular(20))),
    );
  }
}
