import 'package:flutter/material.dart';
import 'package:flutter_workshop/src/core/constant/assets.dart';
import 'package:flutter_workshop/src/core/config/route/routes.dart';
import 'package:flutter_workshop/src/core/config/theme/light_color.dart';
import 'package:flutter_workshop/src/core/config/theme/theme.dart';
import 'package:flutter_workshop/src/core/widgets/extentions.dart';
import 'package:get/get.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppTheme.padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _icon(
            context,
            Icons.sort,
            color: Colors.black54,
            onPressed: () {
              Get.toNamed(Routes.settingPage);
            },
          ),
          _icon(
            context,
            Assets.pin,
            color: LightColor.orange,
            onPressed: () {
              Get.toNamed(Routes.nearbyStorePage);
            },
          ),
          // ClipRRect(
          //   borderRadius: const BorderRadius.all(Radius.circular(13)),
          //   child: Image.asset("assets/user.png"),
          // ).ripple(() {
          //   Get.toNamed(Routes.nearbyStorePage);
          // }, borderRadius: const BorderRadius.all(Radius.circular(13)))
        ],
      ),
    );
  }

  Widget _icon<T>(BuildContext context, T icon,
      {Color color = LightColor.iconColor, VoidCallback? onPressed}) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(13)),
          color: Theme.of(context).backgroundColor,
          boxShadow: AppTheme.shadow),
      child: icon is IconData
          ? Icon(
              icon,
              color: color,
            )
          : Image.asset(
              icon as String,
              color: color,
              width: 24,
              height: 24,
            ),
    ).ripple(() {
      if (onPressed != null) {
        onPressed();
      }
    }, borderRadius: const BorderRadius.all(Radius.circular(13)));
  }
}
