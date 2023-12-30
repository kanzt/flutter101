import 'package:flutter/material.dart';
import 'package:flutter_bottom_navigation/example_3/navigator_keys.dart';
import 'package:flutter_bottom_navigation/example_3/screen2.dart';
import 'package:flutter_bottom_navigation/example_3/tab1/home_page.dart';
import 'package:flutter_bottom_navigation/example_3/tab2/calendar_page.dart';
import 'package:flutter_bottom_navigation/example_3/tab3/profile_page.dart';
import 'package:flutter_bottom_navigation/example_3/widgets/common_bottom_navigation_bar.dart';

/// https://medium.com/swlh/common-bottom-navigation-bar-made-easy-flutter-199c9f683b29
class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = <Widget>[
    const HomePage(),
    const CalendarPage(),
    const ProfilePage(),
  ];

  /// กำหนด GlobalKey ตามจำนวน Tab ของ Bottom navigation
  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    NavigatorKeys.bottomNavigationBarFirstItem,
    NavigatorKeys.bottomNavigationBarSecondItem,
    NavigatorKeys.bottomNavigationBarThirdItem,
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
      body:

          /// BottomNavigationBar แบบใช้ Navigator เดียว ผลลัพธ์คือ เวลาเปลี่ยนหน้าจะโดนทับทั้งหน้ารวมถึง BottomNavigationBar ด้วย
          // _widgetOptions.elementAt(_selectedIndex),

          /// BottomNavigationBar แบบใช้ Nested Navigator ผลลัพธ์คือ เวลาเปลี่ยนหน้าจอจะโดนทับเฉพาะ Content ไม่โดน BottomNavigationBar
          CommonBottomNavigationBar(
        selectedIndex: _selectedIndex,
        navigatorKeys: _navigatorKeys,
        childrens: [
          const HomePage(),
          CalendarPage(
            onNext: () {
              /// ถ้าเราสั่ง Navigator.push ภายใต้ Nested Navigator จะเป็นการ push ที่ Nested Navigator
              /// ดังนั้นถ้าเราต้องการให้ทำงานที่ Navigator หลัก ให้เราทำ Callback แล้วส่งค่าเข้าไปแทน (จุดประสงค์คือเพื่อให้ใช้ Context ของ Navigator หลัก)
              // _next();

              /// หรือถ้าไม่ต้องการเขียนในรูปแบบ Callback ตอนสั่ง Navigator.push ต้องอ้าง context ของ Navigator หลัก โดยสามารถเข้าถึง Context ได้ผ่านคำสั่ง NavigatorKeys.navigatorKeyMain.currentContext
              Navigator.push(NavigatorKeys.navigatorKeyMain.currentContext!,
                  MaterialPageRoute(builder: (context) => const Screen2()));
            },
          ),
          const ProfilePage(),
        ],
      ),
    );
  }

  void _next() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const Screen2()));
  }
}
