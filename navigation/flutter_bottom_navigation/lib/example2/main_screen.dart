import 'package:flutter/material.dart';
import 'package:flutter_bottom_navigation/example2/screen2.dart';
import 'package:flutter_bottom_navigation/example2/tab1/home_page.dart';
import 'package:flutter_bottom_navigation/example2/tab2/calendar_page.dart';
import 'package:flutter_bottom_navigation/example2/tab3/profile_page.dart';
import 'package:flutter_bottom_navigation/example2/widgets/common_bottom_navigation_bar.dart';
import 'package:flutter_icons/flutter_icons.dart';

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


  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>()
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
      body:

      /// BottomNอรเtionBar แบบใช้ Navigator เดียว ผลลัพธ์คือ เวลาเปลี่ยนหน้าจะโดนทับทั้งหน้ารวมถึง BottomNavigationBar ด้วย
      // _widgetOptions.elementAt(_selectedIndex),


      /// BottomNอรเtionBar แบบใช้ Nested Navigator ผลลัพธ์คือ เวลาเปลี่ยนหน้าจอจะโดนทับเฉพาะ Content ไม่โดน BottomNavigationBar
      CommonBottomNavigationBar(
        selectedIndex: _selectedIndex,
        navigatorKeys: _navigatorKeys,
        childrens: [
          const HomePage(),
          /// ถ้าเราสั่ง Navigator.push ภายใต้ Nested Navigator จะเป็นการ push ที่ Nested Navigator แทน Navigator หลัก ดังนั้นจึงต้องทำเป็น callback ข้างนอก CommonBottomNavigationBar
          /// หรือตอนสั่ง Navigator.push ต้องอ้าง context ที่อยู่ภายนอก CommonBottomNavigationBar
          CalendarPage(onNext: _next,),
          const ProfilePage(),
        ],
      ),
    );
  }

  void _next() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const Screen2()));
  }
}
