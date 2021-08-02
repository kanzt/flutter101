import 'package:flutter/material.dart';
import 'package:flutter101/src/config/app_route.dart';
import 'package:flutter101/src/constants/app_setting.dart';
import 'package:flutter101/src/pages/home/home_page.dart';
import 'package:flutter101/src/pages/login/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

/**
 * Config ระดับ Application
 */
class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: AppRoute().route,
      debugShowCheckedModeBanner: false, // ระบุว่าไม่แสดงแถบ Ribbon debug
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      /// FutureBuilder ทำให้ฟังก์ชัน async ทำงานกับ Widget ได้
      home: FutureBuilder<SharedPreferences>(
        future: SharedPreferences.getInstance(),
        builder: (context, snapShot){
          if(!snapShot.hasData){
            return Container(
              color: Colors.white,
            );
          }

          final token = snapShot.data.getString(AppSetting.tokenSetting) ?? '';
          if(token.isNotEmpty){
            return HomePage();
          }
          return LoginPage();
        },
      ), // ระบุว่าให้หน้าไหนเริ่มทำงานเป็นลำดับแรก
    );
  }
}