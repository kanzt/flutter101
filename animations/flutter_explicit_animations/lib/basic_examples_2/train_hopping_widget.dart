import 'package:flutter/material.dart';

class TrainHoppingAnimationWidget extends StatefulWidget {
  const TrainHoppingAnimationWidget({Key? key}) : super(key: key);

  @override
  TrainHoppingAnimationWidgetState createState() =>
      TrainHoppingAnimationWidgetState();
}

class TrainHoppingAnimationWidgetState
    extends State<TrainHoppingAnimationWidget> with TickerProviderStateMixin {
  late AnimationController _controller;

  late Animation<double> hoppingAnimation;

  Color _color = Colors.lightGreen;

  void action() {
    setState(() {
      _color = Colors.purpleAccent;
    });
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
        vsync: this, duration: const Duration(seconds: 2));

    Animation<double> firstAnimation = Tween(
      begin: 0.0,
      end: 0.5,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.ease));
    Animation<double> secondAnimation = Tween(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticIn));

    hoppingAnimation = TrainHoppingAnimation(
        firstAnimation, secondAnimation,
        onSwitchedTrain: action);

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ScaleTransition(
          scale: hoppingAnimation,
          child: AnimatedContainer(
            color: _color,
            duration: const Duration(milliseconds: 300),
            curve: Curves.linear,
            width: 200.0,
            height: 200.0,
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
