import 'package:flutter/material.dart';

class AnimationInsideWidget extends StatefulWidget {
  const AnimationInsideWidget({Key? key}) : super(key: key);

  @override
  AnimationInsideWidgetState createState() => AnimationInsideWidgetState();
}

class AnimationInsideWidgetState extends State<AnimationInsideWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _positionAnimation;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));

    _positionAnimation = Tween(
      begin: const Offset(0.0, -6.0),
      end: const Offset(0.0, 0.0),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.fastOutSlowIn,
      ),
    );

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 200.0,
          height: 200.0,
          color: Colors.greenAccent,
          child: Align(
            alignment: const Alignment(0.0, 0.0),
            child: SlideTransition(
              position: _positionAnimation,
              child: Container(
                height: 100.0,
                width: 100.0,
                color: Colors.amberAccent,
              ),
            ),
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
