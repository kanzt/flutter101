import 'package:flutter/material.dart';

class AnimatedCrossFadeWidget extends StatefulWidget {
  const AnimatedCrossFadeWidget({Key? key}) : super(key: key);

  @override
  AnimatedCrossFadeWidgetState createState() => AnimatedCrossFadeWidgetState();
}

class AnimatedCrossFadeWidgetState extends State<AnimatedCrossFadeWidget> {
  @override
  void initState() {
    super.initState();
  }

  final double _size = 200.0;

  CrossFadeState _fadeState = CrossFadeState.showFirst;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            AnimatedCrossFade(
              crossFadeState: _fadeState,
              duration: const Duration(milliseconds: 1000),
              firstCurve: Curves.easeInOut,
              secondCurve: Curves.easeInOut,
              firstChild: Center(
                child: Image.asset(
                  "images/flutter-logo.png",
                  width: _size,
                  height: _size,
                ),
              ),
              secondChild: Center(
                child: Image.asset(
                  "images/dart-logo.png",
                  width: _size,
                  height: _size,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _fadeState = _fadeState == CrossFadeState.showFirst
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst;
                  });
                },
                child: const Text("Animate"),
              ),
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

  @override
  void dispose() {
    super.dispose();
  }
}
