import 'package:chattalk_explicit_animations/chattalk/screens/chat_screen.dart';
import 'package:chattalk_explicit_animations/chattalk/screens/login_screen.dart';
import 'package:chattalk_explicit_animations/chattalk/screens/registration_screen.dart';
import 'package:chattalk_explicit_animations/chattalk/screens/welcome_screen.dart';
import 'package:flutter/material.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const Chatalk());
}

class Chatalk extends StatelessWidget {
  const Chatalk({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) => const WelcomeScreen(),
        ChatScreen.id: (context) => const ChatScreen(),
        LoginScreen.id: (context) => const LoginScreen(),
        RegistrationScreen.id: (context) => const RegistrationScreen(),
      },
    );
  }
}
