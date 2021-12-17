import 'package:flutter/material.dart';

class TransitionAnimationWidget extends StatefulWidget {
  @override
  TransitionAnimationWidgetState createState() =>
      TransitionAnimationWidgetState();

  final Animation<double> _animation;

  const TransitionAnimationWidget(this._animation, {Key? key}) : super(key: key);
}

class TransitionAnimationWidgetState extends State<TransitionAnimationWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ScaleTransition(
          scale: widget._animation,
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
    super.dispose();
  }
}
