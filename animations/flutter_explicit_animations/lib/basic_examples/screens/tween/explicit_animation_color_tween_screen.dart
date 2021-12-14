import 'package:chattalk_explicit_animations/basic_examples/screens/tween/widgets/circular_loading.dart';
import 'package:chattalk_explicit_animations/basic_examples/screens/tween/widgets/heart_btn.dart';
import 'package:flutter/material.dart';

class ExplicitAnimationColorTweenScreen extends StatefulWidget {
  static const String id = 'ExplicitAnimationColorTweenScreen';

  const ExplicitAnimationColorTweenScreen({Key? key}) : super(key: key);

  @override
  _ExplicitAnimationColorTweenScreenState createState() =>
      _ExplicitAnimationColorTweenScreenState();
}

class _ExplicitAnimationColorTweenScreenState
    extends State<ExplicitAnimationColorTweenScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: const [
              HeartButton(),
              SizedBox(
                height: 16,
              ),
              CircularLoading(),
            ],
          ),
        ),
      ),
    );
  }
}
