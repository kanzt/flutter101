import 'package:chattalk_explicit_animations/basic_examples/screens/animationController/animation_controller_screen.dart';
import 'package:chattalk_explicit_animations/basic_examples/screens/clipper/custom_clipper_selection_page.dart';
import 'package:chattalk_explicit_animations/basic_examples/screens/explicit_animation_example_screen.dart';
import 'package:chattalk_explicit_animations/basic_examples/screens/loop/explicit_animation_loop_screen.dart';
import 'package:chattalk_explicit_animations/basic_examples/screens/multipleAnimation/explicit_multiple_animation_screen.dart';
import 'package:chattalk_explicit_animations/basic_examples/screens/tween/explicit_animation_color_tween_screen.dart';
import 'package:chattalk_explicit_animations/basic_examples/screens/tween/explicit_animation_tween_chain_screen.dart';
import 'package:chattalk_explicit_animations/basic_examples/screens/tween/explicit_animation_tween_screen.dart';
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
        ExplicitAnimationColorTweenScreen.id: (context) => const ExplicitAnimationColorTweenScreen(),
        ExplicitAnimationTweenScreen.id: (context) => const ExplicitAnimationTweenScreen(),
        ExplicitAnimationTweenChainScreen.id: (context) => const ExplicitAnimationTweenChainScreen(),
        ExplicitMultiupleAnimationScreen.id: (context) => const ExplicitMultiupleAnimationScreen(),
        CustomClipperSelectionPage.id: (context) => const CustomClipperSelectionPage(),
        ExplicitAnimationLoopScreen.id: (context) => const ExplicitAnimationLoopScreen(),
      },
    );
  }
}