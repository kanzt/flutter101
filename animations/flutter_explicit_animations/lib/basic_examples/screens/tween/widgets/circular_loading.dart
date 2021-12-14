import 'package:flutter/material.dart';

class CircularLoading extends StatefulWidget {
  const CircularLoading({Key? key}) : super(key: key);

  @override
  _CircularLoadingState createState() => _CircularLoadingState();
}

class _CircularLoadingState extends State<CircularLoading> with SingleTickerProviderStateMixin {

  late AnimationController _animationController;
  late Animation<Color?> _valueColors;


  @override
  void initState() {
    _animationController =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);
    _animationController.repeat();
    _valueColors = _animationController
        .drive(ColorTween(begin: const Color(0xFF333276), end: const Color(0xFFF5D400)));

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) => CircularProgressIndicator(
        valueColor: _valueColors,
      ),
    );
  }
}
