import 'package:flutter/material.dart';

class SlidingDrawer extends StatelessWidget {
  final Widget drawer;
  final Widget child;
  final int swipeSensitivity;
  final double drawerRatio;
  final Color overlayColor;
  final double overlayOpacity;
  final int animationDuration;
  final Curve animationCurve;
  final VoidCallback openFn;
  final VoidCallback closeFn;
  final bool isOpen;

  const SlidingDrawer({
    Key? key,
    required this.drawer,
    required this.child,
    required this.isOpen,
    required this.openFn,
    required this.closeFn,
    this.swipeSensitivity = 25,
    this.drawerRatio = 0.8,
    this.overlayColor = Colors.black,
    this.overlayOpacity = 0.5,
    this.animationDuration = 500,
    this.animationCurve = Curves.ease,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final drawerWidth = width * drawerRatio;

    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        if (details.delta.dx > swipeSensitivity) {
          openFn();
        } else if (details.delta.dx < -swipeSensitivity) {
          closeFn();
        }
      },
      child: SizedBox(
        width: width,
        height: height,
        child: Stack(
          children: [
            AnimatedPositioned(
              width: drawerWidth,
              height: height,
              left: isOpen ? 0 : -drawerWidth,
              duration: Duration(milliseconds: animationDuration),
              curve: animationCurve,
              child: Container(
                color: Colors.amber,
                child: drawer,
              ),
            ),
            AnimatedPositioned(
              height: height,
              width: width,
              left: isOpen ? drawerWidth : 0,
              duration: Duration(milliseconds: animationDuration),
              curve: animationCurve,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  child,
                  AnimatedSwitcher(
                    duration: Duration(milliseconds: animationDuration),
                    switchInCurve: animationCurve,
                    switchOutCurve: animationCurve,
                    child: isOpen
                        ? GestureDetector(
                      onTap: () {
                        closeFn();
                      },
                      child: Container(
                        color: overlayColor.withOpacity(
                          overlayOpacity,
                        ),
                      ),
                    )
                        : null,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
