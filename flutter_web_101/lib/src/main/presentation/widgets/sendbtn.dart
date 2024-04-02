import 'package:flutter/material.dart';
import 'package:flutter_web_101/src/main/presentation/util/responsiveLayout.dart';
import 'package:flutter_web_101/src/res/drawable/drawable.dart';

class SendBtn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        height: 40,
        padding: EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [
              Color(0xFF18341d),
              Color(0xFF507d58),
            ], begin: Alignment.bottomRight, end: Alignment.topLeft),
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: [
              BoxShadow(
                  color: const Color(0xFF507d58).withOpacity(.3),
                  offset: const Offset(0.0, 8.0),
                  blurRadius: 8.0)
            ]),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {},
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Send",
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Montserrat-Bold",
                        fontSize: ResponsiveLayout.isSmallScreen(context)
                            ? 12
                            : ResponsiveLayout.isMediumScreen(context)
                                ? 12
                                : 16,
                        letterSpacing: 1.0),
                  ),
                  SizedBox(
                    width: ResponsiveLayout.isSmallScreen(context)
                        ? 4
                        : ResponsiveLayout.isMediumScreen(context)
                            ? 6
                            : 8,
                  ),
                  Image.asset(
                    Drawable.sent,
                    color: Colors.white,
                    width: ResponsiveLayout.isSmallScreen(context)
                        ? 12
                        : ResponsiveLayout.isMediumScreen(context)
                            ? 12
                            : 20,
                    height: ResponsiveLayout.isSmallScreen(context)
                        ? 12
                        : ResponsiveLayout.isMediumScreen(context)
                            ? 12
                            : 20,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
