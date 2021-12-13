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
                  title: 'Tween Example',
                  color: Colors.deepPurpleAccent,
                  onPressed: () {
                    // Navigator.pushNamed(context, ExplicitAnimationTweenScreen.id);
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
