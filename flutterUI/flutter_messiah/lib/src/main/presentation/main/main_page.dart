import 'package:flutter/material.dart';
import 'package:flutter_messiah/src/main/presentation/main/home/home_page.dart';
import 'package:flutter_messiah/src/main/presentation/main/main_page_controller.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: GetBuilder(
        init: MainPageController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: HomePage(),
            floatingActionButtonLocation:
            FloatingActionButtonLocation.centerDocked,
            // Centered FAB
            floatingActionButton: Container(
              width: 80,
              height: 80,
              margin: EdgeInsets.only(top: 20),
              child: FloatingActionButton(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100)),
                onPressed: () {
                  // Handle action
                },
                child: FaIcon(
                  FontAwesomeIcons.plus,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              elevation: 0.0,
              backgroundColor: Colors.white,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: Color(0xFFFCC75E),
              // Selected icon color
              unselectedItemColor: Colors.grey,
              // Unselected icon color
              showSelectedLabels: false,
              // Hide labels
              showUnselectedLabels: false,
              currentIndex: controller.currentIndex,
              onTap: (index) {
                controller.onSelectBottomNavigationItem(index);
              },
              items: [
                BottomNavigationBarItem(
                    icon: FaIcon(FontAwesomeIcons.home), label: ""),
                BottomNavigationBarItem(
                    icon: Icon(Icons.search), label: "Search"),
                BottomNavigationBarItem(
                    icon: FaIcon(FontAwesomeIcons.userLarge), label: ""),
              ],
            ),
          );
        },
      ),
    );
  }
}