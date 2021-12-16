import 'package:chattalk_explicit_animations/basic_examples/screens/loop/loading_indicator_animator.dart';
import 'package:flutter/material.dart';

class ExplicitAnimationLoopScreen extends StatefulWidget {
  static const id = "ExplicitAnimationLoop";

  const ExplicitAnimationLoopScreen({Key? key}) : super(key: key);

  @override
  _ExplicitAnimationLoopScreenState createState() => _ExplicitAnimationLoopScreenState();
}

class _ExplicitAnimationLoopScreenState extends State<ExplicitAnimationLoopScreen> with TickerProviderStateMixin {
  late AnimationController _repeatController;
  late AnimationController _reverseController;

  @override
  void initState() {
    super.initState();
    _repeatController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);

    _reverseController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);

    _repeatController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _repeatController.repeat();
      } else if (status == AnimationStatus.dismissed) {
        _repeatController.forward();
      }
    });

    _reverseController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _reverseController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _reverseController.forward();
      }
    });

    _repeatController.forward();
    _reverseController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LoadingIndicatorAnimator(
          repeatController: _repeatController,
          reverseController: _reverseController,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _repeatController.dispose();
    _reverseController.dispose();
    super.dispose();
  }

}
