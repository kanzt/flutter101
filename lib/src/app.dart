import 'package:flutter/material.dart';
import 'package:flutter101/src/pages/login/login_page.dart';

/**
 * Config ระดับ Application
 */
class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // ระบุว่าไม่แสดงแถบ Ribbon debug
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(), // ระบุว่าให้หน้าไหนเริ่มทำงานเป็นลำดับแรก
    );
  }
}