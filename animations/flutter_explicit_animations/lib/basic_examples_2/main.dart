import 'package:chattalk_explicit_animations/basic_examples_2/animated_container.dart';
import 'package:chattalk_explicit_animations/basic_examples_2/animated_crossfade.dart';
import 'package:chattalk_explicit_animations/basic_examples_2/animation_inside.dart';
import 'package:chattalk_explicit_animations/basic_examples_2/delay_animation_widget.dart';
import 'package:chattalk_explicit_animations/basic_examples_2/easing_animation_widget.dart';
import 'package:chattalk_explicit_animations/basic_examples_2/heart_animation_widget.dart';
import 'package:chattalk_explicit_animations/basic_examples_2/sequence_animation_widget.dart';
import 'package:chattalk_explicit_animations/basic_examples_2/train_hopping_widget.dart';
import 'package:chattalk_explicit_animations/basic_examples_2/transition_test.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Animation Demo',
      theme: ThemeData(),
      home: const MyHomePage(title: 'Animation Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        title: Image.asset("images/flutter-belgium.png"),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          children: <Widget>[
            ListTile(
              title: const Text("Easing animation"),
              subtitle: const Text("A simple easing animation."),
              onTap: () {
                Navigator.of(context).push(PageRouteBuilder(
                    opaque: true,
                    transitionDuration: const Duration(seconds: 1),
                    pageBuilder:
                        (BuildContext content, Animation _, Animation __) {
                      return const EasingAnimationWidget();
                    },
                    transitionsBuilder: (BuildContext context,
                        Animation<double> animation,
                        Animation<double> _,
                        Widget child) {
                      return FadeTransition(
                        opacity: animation,
                        child: child,
                      );
                    }));
              },
            ),
            ListTile(
              title: const Text("Delayed animation"),
              subtitle:
                  const Text("A delayed animation, with custom page transition"),
              onTap: () {
                Navigator.of(context).push(PageRouteBuilder(
                    opaque: true,
                    transitionDuration: const Duration(seconds: 1),
                    pageBuilder: (BuildContext content, Animation _,
                        Animation secondAnimation) {
                      return const DelayAnimationWidget();
                    },
                    transitionsBuilder: (BuildContext context,
                        Animation<double> animation,
                        Animation<double> secondAnimation,
                        Widget child) {
                      return FadeTransition(opacity: animation, child: child);
                    }));
              },
            ),
            ListTile(
              title: const Text("Heart animation"),
              subtitle: const Text("A more complex micro-animation."),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const HeartAnimationWidget()),
                );
              },
            ),
            ListTile(
              title: const Text("Transition animation"),
              subtitle: const Text(
                  "A scale transition animation, with custom page transition"),
              onTap: () {
                Navigator.of(context).push(PageRouteBuilder(
                    opaque: true,
                    transitionDuration: const Duration(seconds: 1),
                    pageBuilder: (BuildContext content, Animation<double> primary,
                        Animation secondAnimation) {
                      return TransitionAnimationWidget(primary);
                    },
                    transitionsBuilder: (BuildContext context,
                        Animation<double> animation,
                        Animation<double> secondAnimation,
                        Widget child) {
                      return child;
                    }));
              },
            ),
            ListTile(
              title: const Text("Sequence animation"),
              subtitle: const Text("A sequenced animation."),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SequenceAnimationWidget()),
                );
              },
            ),
            ListTile(
              title: const Text("Trainhopping animation"),
              subtitle: const Text("An example of a trainhopping animation."),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const TrainHoppingAnimationWidget()),
                );
              },
            ),
            ListTile(
              title: const Text("Animated container "),
              subtitle: const Text("An example of an animated container."),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AnimatedContainerWidget()),
                );
              },
            ),
            ListTile(
              title: const Text("Animated CrossFade "),
              subtitle: const Text("An example of an animated CrossFade."),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AnimatedCrossFadeWidget()),
                );
              },
            ),
            ListTile(
              title: const Text("Animation Inside!"),
              subtitle: const Text("A small SlideTransition"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AnimationInsideWidget()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
