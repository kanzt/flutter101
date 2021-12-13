import 'package:chattalk_explicit_animations/basic_examples/screens/animationController/animation_controller_screen.dart';
import 'package:chattalk_explicit_animations/basic_examples/screens/explicit_animation_example_screen.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const BasicExamples());
}

class BasicExamples extends StatelessWidget {
  const BasicExamples({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: ExplicitAnimationExampleScreen.id,
      routes: {
        ExplicitAnimationExampleScreen.id: (context) => const ExplicitAnimationExampleScreen(),
        AnimationControllerScreen.id: (context) => const AnimationControllerScreen(),
      },
    );
  }
}