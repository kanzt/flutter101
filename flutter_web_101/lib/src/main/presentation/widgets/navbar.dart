import 'package:flutter/material.dart';
import 'package:flutter_web_101/src/main/presentation/util/responsiveLayout.dart';
import 'package:flutter_web_101/src/res/drawable/drawable.dart';

class NavBar extends StatefulWidget {
  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> with TickerProviderStateMixin {
  final navLinks = ["Home", "Products", "News", "Contact"];

  bool _isNavbarOpened = false;

  List<Widget> navItemLarge() {
    return navLinks.map((text) {
      return Padding(
        padding: const EdgeInsets.only(left: 18),
        child: Text(text,
            style: const TextStyle(fontFamily: "Montserrat-Bold")),
      );
    }).toList();
  }

  List<Widget> navItemSmall() {
    return navLinks.map((text) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Text(text,
            style: const TextStyle(fontFamily: "Montserrat-Bold")),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 45, vertical: 38),
      child: Column(
        children: [
          Row(
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
                    child: Image.asset(
                      Drawable.logo,
                      width: 50,
                      height: 50,
                    ),
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
                    ...navItemLarge(),
                    Container(
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
                                color:
                                    const Color(0xFF6078ea).withOpacity(.3),
                                offset: const Offset(0, 8),
                                blurRadius: 8)
                          ]),
                      child: const Center(
                        child: Text(
                          "Login",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              letterSpacing: 1,
                              fontFamily: "Montserrat-Bold"),
                        ),
                      ),
                    ),
                  ],
                )
              else
                GestureDetector(
                    onTap: () {
                      setState(() {
                        _isNavbarOpened = !_isNavbarOpened;
                      });
                    },
                    child:
                        Image.asset(Drawable.menu, width: 26, height: 26))
            ],
          ),
          //  Navbar menu for small screen
          if (ResponsiveLayout.isSmallScreen(context))
            Visibility(
              visible: _isNavbarOpened,
              maintainState: true,
              maintainAnimation: true,
              maintainSize: true,
              child: AnimatedSize(
                curve: Curves.easeOut,
                duration: const Duration(microseconds: 500),
                child: SizedBox(
                  height: _isNavbarOpened ? 250 : 0,
                  child: Column(
                    children: [
                      ...navItemSmall(),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
