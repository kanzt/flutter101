import 'package:flutter/material.dart';
import 'package:flutter_bottom_navigation/example3/tab2/calendar_page.dart';
import 'package:flutter_bottom_navigation/example3/tab1/home_page.dart';
import 'package:flutter_bottom_navigation/example3/tab3/profile_page.dart';
import 'package:flutter_bottom_navigation/example3/widgets/common_bottom_navigation_bar.dart';
import 'package:flutter_bottom_navigation/example3/widgets/navigator_keys.dart';
import 'package:flutter_icons/flutter_icons.dart';

/// https://medium.com/swlh/common-bottom-navigation-bar-made-easy-flutter-199c9f683b29
class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    NavigatorKeys.bottomNavigationBarHomeKey,
    NavigatorKeys.bottomNavigationBarCalendarKey,
    NavigatorKeys.bottomNavigationBarProfileKey,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Feather.home,
            ),
            label: 'HOME',
            activeIcon: Icon(
              Feather.home,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              FontAwesome.calendar,
            ),
            label: 'CALENDAR',
            activeIcon: Icon(
              FontAwesome.calendar,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              EvilIcons.user,
              size: 36,
            ),
            label: 'PROFILE',
            activeIcon: Icon(
              EvilIcons.user,
              size: 36,
            ),
          ),
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      body: CommonBottomNavigationBar(
        selectedIndex: _selectedIndex,
        navigatorKeys: _navigatorKeys,
        childrens: [
          HomePage(navigatorKey: _navigatorKeys[0]),
          CalendarPage(navigatorKey: _navigatorKeys[1]),
          ProfilePage(navigatorKey: _navigatorKeys[2]),
        ],
      ),
    );
  }
}
