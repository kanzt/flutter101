import 'package:flutter/material.dart';

class HeartButton extends StatefulWidget {
  const HeartButton({Key? key}) : super(key: key);

  @override
  _HeartButtonState createState() => _HeartButtonState();
}

class _HeartButtonState extends State<HeartButton> with SingleTickerProviderStateMixin {
  bool isFav = false;
  late AnimationController _heartController;
  late Animation<Color?> _heartColorAnimation;

  @override
  void initState() {
    _heartController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _heartColorAnimation = ColorTween(begin: Colors.grey[400], end: Colors.red)
        .animate(_heartController);

    _heartController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          isFav = true;
        });
      }
      if (status == AnimationStatus.dismissed) {
        setState(() {
          isFav = false;
        });
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _heartController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _heartController,
        builder: (BuildContext context, _) {
          return IconButton(
            padding: const EdgeInsets.all(0),
            splashRadius: 30,
            icon: Icon(
              Icons.favorite,
              color: _heartColorAnimation.value,
              size: 48,
            ),
            onPressed: () {
              isFav ? _heartController.reverse() : _heartController.forward();
            },
          );
        });
  }
}
