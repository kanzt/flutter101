import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AnimationControllerScreen extends StatefulWidget {
  static const String id = 'AnimationControllerScreen';
  const AnimationControllerScreen({Key? key}) : super(key: key);

  @override
  _AnimationControllerScreenState createState() => _AnimationControllerScreenState();
}

class _AnimationControllerScreenState extends State<AnimationControllerScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 3));

    _animationController.forward();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  child!,
                  const SizedBox(
                    height: 20,
                  ),
                  Transform.scale(
                    scale: _animationController.value,
                    child: Container(
                      height: 100,
                      width: 100,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ));
        },
        child: const Text(
          "This child is not Related To Animation.\nSo won't rebuild when animation value changes.",
        ),
      ),
    );
  }
}
