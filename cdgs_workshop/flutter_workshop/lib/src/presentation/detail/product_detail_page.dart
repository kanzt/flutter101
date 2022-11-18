import 'package:flutter/material.dart';
import 'package:flutter_workshop/src/core/config/di/cart_controller.dart';
import 'package:flutter_workshop/src/core/config/route/routes.dart';
import 'package:flutter_workshop/src/core/config/theme/light_color.dart';
import 'package:flutter_workshop/src/core/config/theme/theme.dart';
import 'package:flutter_workshop/src/core/widgets/appbar_icon_button.dart';
import 'package:flutter_workshop/src/core/widgets/extentions.dart';
import 'package:flutter_workshop/src/core/widgets/title_text.dart';
import 'package:flutter_workshop/src/data/enum/available_color.dart';
import 'package:flutter_workshop/src/data/enum/available_size.dart';
import 'package:flutter_workshop/src/data/model/enitiy/cart_item.dart';
import 'package:flutter_workshop/src/data/data.dart';
import 'package:flutter_workshop/src/presentation/detail/product_detail_page_controller.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class ProductDetailPage extends StatelessWidget {
  ProductDetailPage({Key? key}) : super(key: key);

  final _productDetailPageController = Get.put(ProductDetailPageController());
  final _cartController = Get.find<CartController>();

  // Arg
  static const productArg = "productArg";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  // Colors.red,
                  Color(0xfffbfbfb),
                  Color(0xfff7f7f7),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              )),
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  _appBar(),
                  _productImage(),
                  _productImageThumbnail(context),
                ],
              ),
              _detailWidget(),
              _addToCartButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailWidget() {
    return DraggableScrollableSheet(
        maxChildSize: .8,
        initialChildSize: .53,
        minChildSize: .53,
        builder: (context, scrollController) {
          return Container(
            padding: AppTheme.padding.copyWith(bottom: 0),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                color: Colors.white),
            child: NotificationListener<OverscrollIndicatorNotification>(
                onNotification: (overScroll) {
                  overScroll.disallowIndicator();
                  return true;
                },
                child: _bottomSheetContent(scrollController, null)),

            // child: _bottomSheetContent(scrollController, const BouncingScrollPhysics()),
          );
        });
  }

  _bottomSheetContent(ScrollController scrollController,
      ScrollPhysics? physics) {
    return SingleChildScrollView(
      controller: scrollController,
      physics: physics,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          const SizedBox(height: 5),
          Container(
            alignment: Alignment.center,
            child: Container(
              width: 50,
              height: 5,
              decoration: const BoxDecoration(
                  color: LightColor.iconColor,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
            ),
          ),
          const SizedBox(height: 10),
          _productTitle(),
          const SizedBox(
            height: 20,
          ),
          _availableSize(),
          const SizedBox(
            height: 20,
          ),
          _availableColor(),
          const SizedBox(
            height: 20,
          ),
          _description(),
        ],
      ),
    );
  }

  Widget _productTitle() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        // Text("NIKE AIR MAX 200",
        //         style: GoogleFonts.mulish(
        //             fontSize: 25, fontWeight: FontWeight.w800, color: LightColor.titleTextColor))
        TitleText(text: _productDetailPageController.product.name, fontSize: 25),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const TitleText(
                  text: "\$ ",
                  fontSize: 18,
                  color: LightColor.red,
                ),
                TitleText(
                  text: "${_productDetailPageController.product.price}",
                  fontSize: 25,
                ),
              ],
            ),
            Row(
              children: const <Widget>[
                Icon(Icons.star, color: LightColor.yellowColor, size: 17),
                Icon(Icons.star, color: LightColor.yellowColor, size: 17),
                Icon(Icons.star, color: LightColor.yellowColor, size: 17),
                Icon(Icons.star, color: LightColor.yellowColor, size: 17),
                Icon(Icons.star_border, size: 17),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _availableSize() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const TitleText(
          text: "Available Size",
          fontSize: 14,
        ),
        const SizedBox(height: 20),
        GetBuilder<ProductDetailPageController>(
          builder: (ProductDetailPageController controller) {
            return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: controller.availableSize
                    .map((e) =>
                    _sizeWidget(e,
                        isSelected: e == controller.selectedSize))
                    .toList());
          },
        ),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //   children: <Widget>[
        //     _sizeWidget("US 6"),
        //     _sizeWidget("US 7", isSelected: true),
        //     _sizeWidget("US 8"),
        //     _sizeWidget("US 9"),
        //   ],
        // )
      ],
    );
  }

  Widget _sizeWidget(AvailableSize size, {bool isSelected = false}) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(
            color: LightColor.iconColor,
            style: !isSelected ? BorderStyle.solid : BorderStyle.none),
        borderRadius: const BorderRadius.all(Radius.circular(13)),
        color: isSelected ? LightColor.orange : Colors.transparent,
      ),
      child: TitleText(
        text: size.name,
        fontSize: 16,
        color: isSelected ? LightColor.background : LightColor.titleTextColor,
      ),
    ).ripple(() {
      _productDetailPageController.setSelectedSize(size);
    }, borderRadius: const BorderRadius.all(Radius.circular(13)));
  }

  Widget _availableColor() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const TitleText(
          text: "Available Size",
          fontSize: 14,
        ),
        const SizedBox(height: 20),
        GetBuilder<ProductDetailPageController>(
          builder: (ProductDetailPageController controller) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: controller.availableColor.map((e) => Padding(
                  padding: const EdgeInsets.only(right: 30),
                  child: _colorWidget(
                      e, isSelected: e == controller.selectedColor)))
                  .toList()
            );
          },
          // child: Row(
          //   mainAxisAlignment: MainAxisAlignment.start,
          //   children: <Widget>[
          //     _colorWidget(LightColor.yellowColor, isSelected: true),
          //     const SizedBox(
          //       width: 30,
          //     ),
          //     _colorWidget(LightColor.lightBlue),
          //     const SizedBox(
          //       width: 30,
          //     ),
          //     _colorWidget(LightColor.black),
          //     const SizedBox(
          //       width: 30,
          //     ),
          //     _colorWidget(LightColor.red),
          //     const SizedBox(
          //       width: 30,
          //     ),
          //     _colorWidget(LightColor.skyBlue),
          //   ],
          // ),
        )
      ],
    );
  }

  Widget _colorWidget(AvailableColor availableColor, {bool isSelected = false}) {
    return GestureDetector(
      onTap: (){
        _productDetailPageController.setSelectedColor(availableColor);
      },
      child: CircleAvatar(
        radius: 12,
        backgroundColor: availableColor.color.withAlpha(150),
        child: isSelected
            ? Icon(
          Icons.check_circle,
          color: availableColor.color,
          size: 18,
        )
            : CircleAvatar(radius: 7, backgroundColor: availableColor.color),
      ),
    );
  }

  Widget _description() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const <Widget>[
        TitleText(
          text: "Available Size",
          fontSize: 14,
        ),
        SizedBox(height: 20),
        Text("This is product description"),
      ],
    );
  }

  Widget _appBar() {
    return Container(
      padding: AppTheme.padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          AppbarIconButton(
            Icons.arrow_back_ios,
            iconColor: Colors.black54,
            onPressed: () {
              Get.back();
              // Navigator.of(context).pop();
            },
          ),
          AppbarIconButton(
            Icons.shopping_basket,
            iconColor: LightColor.grey.withOpacity(0.7),
            size: 15,
            padding: 4,
            isOutLine: false,
            onPressed: () {
              Get.toNamed(Routes.shoppingCartPage);
              // Navigator.of(context).pushNamed(Routes.shoppingCartPage);
            },
          ),
        ],
      ),
    );
  }

  Widget _productImage() {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        const TitleText(
          text: "AIP",
          fontSize: 160,
          color: LightColor.lightGrey,
        ),
        Image.asset(_productDetailPageController.product.image, width: 226, height: 172,)
        // Image.asset('assets/show_1.png')
      ],
    );
  }

  Widget _productImageThumbnail(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 0),
      width: AppTheme.fullWidth(context),
      height: 80,
      child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children:
          AppData.showThumbnailList.map((x) => _thumbnail(x)).toList()),
    );
  }

  Widget _thumbnail(String image) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        height: 40,
        width: 50,
        decoration: BoxDecoration(
          border: Border.all(
            color: LightColor.grey,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(13)),
          // color: Theme.of(context).backgroundColor,
        ),
        child: Image.asset(image),
      ).ripple(() {},
          borderRadius: const BorderRadius.all(Radius.circular(13))),
    );
  }

  Widget _addToCartButton() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xfffbfbfb).withOpacity(1.0),
                const Color(0xfff7f7f7).withOpacity(0.8),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            )),
        child: SizedBox(
          width: 310.5,
          height: 46,
          child: ElevatedButton(
            onPressed: () {
              _cartController.addItemToCart(
                CartItem(
                    _productDetailPageController.product,
                    _productDetailPageController.selectedSize,
                    _productDetailPageController.selectedColor
                ),
              );

              Fluttertoast.showToast(
                  msg: "Added to cart",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.TOP,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.black,
                  textColor: Colors.white,
                  fontSize: 16.0
              );
            },
            style: ButtonStyle(
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              backgroundColor:
              MaterialStateProperty.all<Color>(LightColor.orange),
            ),
            child: Container(
              alignment: Alignment.center,
              child: const TitleText(
                text: 'Add to cart',
                color: LightColor.background,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
