import 'package:flutter/material.dart';
import './registration_screen.dart';
import './login_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import '../components/rounded_button.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome';

  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation animation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    animation = CurvedAnimation(parent: controller, curve: Curves.bounceOut);
    Future.delayed(const Duration(seconds: 1), (){
      controller.forward();
    });
    // controller.addListener(() {
    //   setState(() {});
    // });
  }

  @override
  void dispose() {
    super.dispose();

    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: AnimatedBuilder(
                    builder: (BuildContext context, Widget? child) {
                      return SizedBox(
                        child: Image.asset('images/logo.png'),
                        height: animation.value * 100,
                      );
                    },
                    animation: controller,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                SizedBox(
                  child: DefaultTextStyle(
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 45.0,
                      fontWeight: FontWeight.w400,
                    ),
                    child: AnimatedTextKit(
                      animatedTexts: [
                        TypewriterAnimatedText('Chatalk'),
                      ],
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 48.0,
            ),
            RoundedButton(
              title: 'Log In',
              color: Colors.deepPurple,
              onPressed: () {
                Navigator.pushNamed(context, LoginScreen.id);
              },
            ),
            RoundedButton(
              title: 'Register',
              color: Colors.purple,
              onPressed: () {
                Navigator.pushNamed(context, RegistrationScreen.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}
