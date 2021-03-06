import 'package:flutter/material.dart';

class SequenceAnimationWidget extends StatefulWidget {
  const SequenceAnimationWidget({Key? key}) : super(key: key);

  @override
  SequenceAnimationWidgetState createState() => SequenceAnimationWidgetState();
}

class SequenceAnimationWidgetState extends State<SequenceAnimationWidget>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  late Animation<double> animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
        vsync: this, duration: const Duration(seconds: 2));

    animation = TweenSequence(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0.0, end: 1.0)
              .chain(CurveTween(curve: Curves.easeInOut)),
          weight: 10.0,
        ),
        TweenSequenceItem<double>(
          tween: ConstantTween<double>(1.0),
          weight: 10.0,
        ),
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: 1.0, end: 0.2)
              .chain(CurveTween(curve: Curves.bounceInOut)),
          weight: 10.0,
        ),
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0.2, end: 2.0)
              .chain(CurveTween(curve: Curves.fastOutSlowIn)),
          weight: 70.0,
        ),
      ],
    ).animate(_controller);

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ScaleTransition(
          scale: animation,
          child: Container(
            width: 200.0,
            height: 200.0,
            color: Colors.orange,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          }),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
