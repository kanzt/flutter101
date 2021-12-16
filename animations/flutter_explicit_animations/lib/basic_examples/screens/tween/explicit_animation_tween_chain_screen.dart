import 'package:chattalk_explicit_animations/chattalk/components/rounded_button.dart';
import 'package:flutter/material.dart';

class ExplicitAnimationTweenChainScreen extends StatefulWidget {
  const ExplicitAnimationTweenChainScreen({Key? key}) : super(key: key);

  static const id = "ExplicitAnimationTweenChainScreen";

  @override
  _ExplicitAnimationTweenChainScreenState createState() =>
      _ExplicitAnimationTweenChainScreenState();
}

class _ExplicitAnimationTweenChainScreenState
    extends State<ExplicitAnimationTweenChainScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _containerSizeAnimation;
  late Cubic cubit;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 3));

    _containerSizeAnimation = Tween(begin: 20.0, end: 300.0)
        .chain(CurveTween(curve: Curves.easeOut))
        .animate(_animationController);
    // หรือถ้าต้องการกำหนด Curve เอง
    // CurveTween(curve: const Cubic(0.71, -0.01, 1.0, 1.0))

    // _containerSizeAnimation = Tween(begin: 20.0, end: 300.0).animate(
    //     CurvedAnimation(
    //         parent: _animationController,
    //         curve: Curves.easeOut));

    _animationController.addListener(() {
      // print("Current animationController value : ${_animationController.value}");
      print(
          "Current containerSizeAnimation value : ${_containerSizeAnimation.value}");
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
      body: Stack(
        fit: StackFit.expand,
        children: [
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      child!,
                      const SizedBox(
                        height: 24,
                      ),
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
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 0),
              child: Wrap(
                spacing: 4,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      onChangeCubit(Curves.ease);
                    },
                    child: const Text("Curves.ease"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      onChangeCubit(Curves.easeIn);
                    },
                    child: const Text("Curves.easeIn"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      onChangeCubit(Curves.easeOut);
                    },
                    child: const Text("Curves.easeOut"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void onChangeCubit(Cubic easeOut) {
    if (!_animationController.isAnimating) {
      setState(() {
        cubit = easeOut;
        _containerSizeAnimation = Tween(begin: 20.0, end: 300.0)
            .chain(CurveTween(curve: cubit))
            .animate(_animationController);
      });
      if (_animationController.isCompleted) {
        _animationController.reset();
        _animationController.forward();
      } else {
        _animationController.forward();
      }
    }
  }
}
