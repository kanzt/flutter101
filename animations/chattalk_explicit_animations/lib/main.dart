import 'package:flutter/material.dart';
import './screens/welcome_screen.dart';
import './screens/chat_screen.dart';
import './screens/login_screen.dart';
import './screens/registration_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(Chatalk());
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
        RegistrationScreen.id: (context) => const RegistrationScreen()
      },
    );
  }
}
