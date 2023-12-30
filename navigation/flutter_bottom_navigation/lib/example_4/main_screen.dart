import 'package:flutter/material.dart';
import 'package:flutter_bottom_navigation/example_4/tab1/home_page.dart';
import 'package:flutter_bottom_navigation/example_4/tab2/calendar_page.dart';
import 'package:flutter_bottom_navigation/example_4/tab3/profile_page.dart';
import 'package:flutter_bottom_navigation/example_4/widgets/common_bottom_navigation_bar.dart';
import 'package:flutter_bottom_navigation/example_4/widgets/navigator_keys.dart';

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
              Icons.home,
            ),
            label: 'HOME',
            activeIcon: Icon(
              Icons.home,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.calendar_month,
            ),
            label: 'CALENDAR',
            activeIcon: Icon(
              Icons.calendar_month,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              size: 36,
            ),
            label: 'PROFILE',
            activeIcon: Icon(
              Icons.person,
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
