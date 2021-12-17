import 'package:flutter/material.dart';

class HeartAnimationWidget extends StatefulWidget {
  const HeartAnimationWidget({Key? key}) : super(key: key);

  @override
  _HeartAnimationWidgetState createState() => _HeartAnimationWidgetState();
}

// Add with TickerProviderStateMixin
class _HeartAnimationWidgetState extends State<HeartAnimationWidget>
    with SingleTickerProviderStateMixin {
  // Define the _controller variable
  late AnimationController _controller;

  late Animation<double> _greyHeartSize;
  late Animation<double> _redCircleSize;
  late Animation<double> _whiteCircleSize;
  late Animation<double> _waveEffectSize;
  late Animation<double> _waveEffectOpacity;
  late Animation<double> _redHeartSize;

  // Add the initState method to initialize the AnimationController
  @override
  void initState() {
    super.initState();

    // As the class itself is the TickerProvider we can pass this in the vsync argument
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));

    // Tween size from 148 to 0, on a 0.0 to 0.15 interval using an easeInOut curve
    _greyHeartSize = Tween(begin: 148.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.15, curve: Curves.easeInOut),
      ),
    );

    // Tween size from 0 to 310 on a 0 to 0.3 interval using an easeInOut curve
    _redCircleSize = Tween(begin: 0.0, end: 310.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.3, curve: Curves.easeInOut),
      ),
    );

    // Tween size from 0 to 315 on a 0.1 to 0.25 interval using an easeInOut curve
    _whiteCircleSize = Tween(begin: 0.0, end: 315.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.1, 0.25, curve: Curves.easeInOut),
      ),
    );

    // Tween size from 0 to 300 on a 0 to 0.3 interval using an easeInOut curve
    _waveEffectSize = Tween(begin: 110.0, end: 210.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.5, curve: Curves.easeInOut),
      ),
    );

    _redHeartSize = TweenSequence(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
          tween: Tween(begin: 5.0, end: 200.0)
              .chain(CurveTween(curve: Curves.easeOut)),
          weight: 20.0,
        ),
        TweenSequenceItem<double>(
          tween: Tween(begin: 200.0, end: 80.0)
              .chain(CurveTween(curve: const Cubic(0.71, -0.01, 1.0, 1.0))),
          weight: 20.0,
        ),
        TweenSequenceItem<double>(
          tween: Tween(begin: 80.0, end: 148.0)
              .chain(CurveTween(curve: Curves.elasticOut)),
          weight: 60.0,
        ),
      ],
    ).animate(
        (CurvedAnimation(parent: _controller, curve: const Interval(0.1, 1.0))));

    _waveEffectOpacity = TweenSequence(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          weight: 60.0,
        ),
        TweenSequenceItem<double>(
          tween: Tween(begin: 1.0, end: 0.0),
          weight: 40.0,
        ),
      ],
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.7, curve: Curves.easeInOut),
      ),
    );
  }

  // Don't forget to always dispose an AnimationController
  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () {
          _controller.reset();
          _controller.forward();
        },
        child: Stack(
          children: [
            AnimatedBuilder(
                animation: _controller,
                builder: (BuildContext context, Widget? child) {
                  return Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      height: _redCircleSize.value,
                      width: _redCircleSize.value,
                      child: Image.asset('images/Circle_Red.png'),
                    ),
                  );
                }),
            AnimatedBuilder(
                animation: _controller,
                builder: (BuildContext context, Widget? child) {
                  return Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      height: _whiteCircleSize.value,
                      width: _whiteCircleSize.value,
                      child: Image.asset('images/Circle_white.png'),
                    ),
                  );
                }),
            AnimatedBuilder(
                animation: _controller,
                builder: (BuildContext context, Widget? child) {
                  return Align(
                    alignment: Alignment.center,
                    child: Opacity(
                      opacity: _waveEffectOpacity.value,
                      child: SizedBox(
                        height: _waveEffectSize.value,
                        width: _waveEffectSize.value,
                        child: Image.asset('images/Heart_WaveEffect.png'),
                      ),
                    ),
                  );
                }),
            AnimatedBuilder(
              animation: _controller,
              builder: (BuildContext context, Widget? child) {
                return Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    height: _redHeartSize.value,
                    width: _redHeartSize.value,
                    child: Image.asset('images/Heart_Red.png'),
                  ),
                );
              },
            ),
            AnimatedBuilder(
              animation: _controller,
              builder: (BuildContext context, Widget? child) {
                return Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    height: _greyHeartSize.value,
                    width: _greyHeartSize.value,
                    child: Image.asset('images/Heart_Grey.png'),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          }),
    );
  }
}
