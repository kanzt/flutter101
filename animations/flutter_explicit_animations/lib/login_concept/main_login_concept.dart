import 'package:chattalk_explicit_animations/login_concept/screens/login_concept.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Animations',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: const Color(0xFF0e7cfe),
          primarySwatch: Colors.blue,
          textTheme: GoogleFonts.rubikTextTheme(Theme.of(context).textTheme)),
      home: const LogInScreen(),
    );
  }
}