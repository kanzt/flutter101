import 'package:flutter/material.dart';
import 'package:flutter_bottom_navigation/example_4/main_screen.dart';
import 'package:flutter_bottom_navigation/example_4/tab2/calendar_page.dart';
import 'package:flutter_bottom_navigation/example_4/tab2/calendar_screen_2.dart';
import 'package:flutter_bottom_navigation/example_4/tab2/calendar_screen_3.dart';
import 'package:flutter_bottom_navigation/example_4/widgets/navigator_keys.dart';

void main() {
  runApp(const MyApp());
}

/// เหมือน example 2 100% แต่ใช้ Named routing
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      initialRoute: "/",
      routes: <String, WidgetBuilder>{
        "/" : (_) => const MainScreen(),

        /// สำหรับหน้าจอ Calendar เราต้องการให้เวลาเปลี่ยนหน้าจะต้องทับเยื้อหาทั้งหน้าจอ จึงต้องใช้งาน Navigation หลักด้วย ดังนั้นเราจึงกำหนด Route ที่นี่
        CalendarPageScreenRoutes.screen2 : (_) => const CalendarScreen2(),
        CalendarPageScreenRoutes.screen3 : (_) => const CalendarScreen3(),
      },
      navigatorKey: NavigatorKeys.navigatorKeyMain,
    );
  }
}
