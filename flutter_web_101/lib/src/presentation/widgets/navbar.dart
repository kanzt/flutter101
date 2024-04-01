import 'package:flutter/material.dart';
import 'package:flutter_web_101/src/presentation/util/responsiveLayout.dart';

class NavBar extends StatelessWidget {
  final navLinks = ["Home", "Products", "News", "Contact"];

  List<Widget> navItem() {
    return navLinks.map((text) {
      return Padding(
        padding: const EdgeInsets.only(left: 18),
        child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Text(text,
                style: const TextStyle(fontFamily: "Montserrat-Bold"))),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 45, vertical: 38),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(8),
                // decoration: BoxDecoration(
                //   borderRadius: BorderRadius.circular(18),
                //   gradient: const LinearGradient(colors: [
                //     Color(0xFF18341d),
                //     Color(0xFF507d58),
                //   ], begin: Alignment.bottomRight, end: Alignment.topLeft),
                // ),
                child: Image.network("assets/logo.png", width: 50, height: 50,),
                // const Center(
                //   child: Text(
                //     "CDG",
                //     style: TextStyle(fontSize: 30, color: Colors.white),
                //   ),
                // ),
              ),
              const SizedBox(
                width: 16,
              ),
              // const Text("Intranet", style: TextStyle(fontSize: 26))
            ],
          ),
          if (!ResponsiveLayout.isSmallScreen(context))
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                ...navItem(),
                InkWell(
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Container(
                      margin: const EdgeInsets.only(left: 20),
                      width: 120,
                      height: 40,
                      decoration: BoxDecoration(
                          gradient: const LinearGradient(
                              colors: [
                                Color(0xFF18341d),
                                Color(0xFF507d58),
                              ],
                              begin: Alignment.bottomRight,
                              end: Alignment.topLeft),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                                color: const Color(0xFF6078ea).withOpacity(.3),
                                offset: const Offset(0, 8),
                                blurRadius: 8)
                          ]),
                      child: const Material(
                        color: Colors.transparent,
                        child: Center(
                          child: Text("Login",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  letterSpacing: 1,
                                  fontFamily: "Montserrat-Bold")),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          else
            Image.network("assets/menu.png", width: 26, height: 26)
        ],
      ),
    );
  }
}
