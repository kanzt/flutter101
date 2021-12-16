import 'package:chattalk_explicit_animations/basic_examples/screens/animationController/animation_controller_screen.dart';
import 'package:chattalk_explicit_animations/basic_examples/screens/clipper/custom_clipper_selection_page.dart';
import 'package:chattalk_explicit_animations/basic_examples/screens/loop/explicit_animation_loop_screen.dart';
import 'package:chattalk_explicit_animations/basic_examples/screens/multipleAnimation/explicit_multiple_animation_screen.dart';
import 'package:chattalk_explicit_animations/basic_examples/screens/tween/explicit_animation_color_tween_screen.dart';
import 'package:chattalk_explicit_animations/basic_examples/screens/tween/explicit_animation_tween_chain_screen.dart';
import 'package:chattalk_explicit_animations/basic_examples/screens/tween/explicit_animation_tween_screen.dart';
import 'package:chattalk_explicit_animations/chattalk/components/rounded_button.dart';
import 'package:flutter/material.dart';

class ExplicitAnimationExampleScreen extends StatefulWidget {
  static const String id = 'explicitAnimationExamples';

  const ExplicitAnimationExampleScreen({Key? key}) : super(key: key);

  @override
  _ExplicitAnimationExampleScreenState createState() =>
      _ExplicitAnimationExampleScreenState();
}

class _ExplicitAnimationExampleScreenState
    extends State<ExplicitAnimationExampleScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                RoundedButton(
                  title: 'AnimationController Example',
                  color: Colors.deepPurpleAccent,
                  onPressed: () {
                    Navigator.pushNamed(context, AnimationControllerScreen.id);
                  },
                ),
                RoundedButton(
                  title: 'Tween Example',
                  color: Colors.deepPurpleAccent,
                  onPressed: () {
                    Navigator.pushNamed(context, ExplicitAnimationTweenScreen.id);
                  },
                ),
                RoundedButton(
                  title: 'ColorTween Example',
                  color: Colors.deepPurpleAccent,
                  onPressed: () {
                    Navigator.pushNamed(context, ExplicitAnimationColorTweenScreen.id);
                  },
                ),
                RoundedButton(
                  title: 'Tween chain with curve Example',
                  color: Colors.deepPurpleAccent,
                  onPressed: () {
                    Navigator.pushNamed(context, ExplicitAnimationTweenChainScreen.id);
                  },
                ),
                RoundedButton(
                  title: 'Interval Animation Example',
                  color: Colors.deepPurpleAccent,
                  onPressed: () {
                    Navigator.pushNamed(context, ExplicitMultiupleAnimationScreen.id);
                  },
                ),
                RoundedButton(
                  title: 'Custom Clipper Example',
                  color: Colors.deepPurpleAccent,
                  onPressed: () {
                    Navigator.pushNamed(context, CustomClipperSelectionPage.id);
                  },
                ),
                RoundedButton(
                  title: 'Loop animation Example',
                  color: Colors.deepPurpleAccent,
                  onPressed: () {
                    Navigator.pushNamed(context, ExplicitAnimationLoopScreen.id);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
