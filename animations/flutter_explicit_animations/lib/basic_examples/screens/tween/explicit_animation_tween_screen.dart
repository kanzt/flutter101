import 'package:flutter/material.dart';

class ExplicitAnimationTweenScreen extends StatefulWidget {
  static const String id = 'ExplicitAnimationTweenScreen';

  const ExplicitAnimationTweenScreen({Key? key}) : super(key: key);

  @override
  _ExplicitAnimationColorTweenScreenState createState() =>
      _ExplicitAnimationColorTweenScreenState();
}

class _ExplicitAnimationColorTweenScreenState
    extends State<ExplicitAnimationTweenScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _containerSizeAnimation;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 3));

    _containerSizeAnimation = Tween(begin: 20.0, end: 300.0).animate(_animationController);

    _animationController.addListener(() {
      print("Current animationController value : ${_animationController.value}");
      print("Current containerSizeAnimation value : ${_containerSizeAnimation.value}");
    });

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
                  Column(
                    children: [
                      child!,
                      const SizedBox(height: 24,),
                      const Text(
                        "The _containerSizeAnimation is betwwen 20 - 300",
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        "${_containerSizeAnimation.value}",
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: _containerSizeAnimation.value,
                    width: _containerSizeAnimation.value,
                    color: Colors.blue,
                  ),
                ],
              ));
        },
        child: const Text(
          "This child is not Related To Animation.\nSo won't rebuild when animation value changes.",
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
