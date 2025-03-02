import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_messiah/src/main/core/config/routes.dart';
import 'package:flutter_messiah/src/res/color/palette.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Messiah Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "IBMPlexSans",
        primaryColor: Palette.primaryColor,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 8,
            backgroundColor: Colors.white,
            shape: const CircleBorder(),
            minimumSize: const Size.square(80),
          ),
        ),
        primarySwatch: Palette.kToDark,
        scaffoldBackgroundColor: Colors.white,
      ),
      initialRoute: Routes.rootPage,
      getPages: Routes.getRoute(),
    );
  }
}
