import 'package:flutter/material.dart';

class ExplicitMultiupleAnimationScreen extends StatefulWidget {
  static const id = "ExplicitMultiupleAnimationScreen";

  const ExplicitMultiupleAnimationScreen({Key? key}) : super(key: key);

  @override
  _ExplicitMultipleAnimationScreenState createState() =>
      _ExplicitMultipleAnimationScreenState();
}

class _ExplicitMultipleAnimationScreenState
    extends State<ExplicitMultiupleAnimationScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _avatarOpacityAnimation;
  late final Animation<double> _avatarSizeAnimation;
  late final Animation<double> _dividerWidthAnimation;
  late final Animation<double> _profileOpacityAnimation;
  late final Animation<double> _profileHeightAnimation;
  late final Animation<double> _profileWidthAnimation;
  late final Animation<double> _profileTextOpacityAnimation;

  @override
  void initState() {
    // TODO: implement initState
    _controller = AnimationController(
        duration: const Duration(milliseconds: 3500), vsync: this);

    _avatarOpacityAnimation = Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.1, 0.4, curve: Curves.ease)));
    _avatarSizeAnimation = Tween(begin: 10.0, end: 80.0).animate(
        CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.1, 0.4, curve: Curves.elasticOut)));
    _dividerWidthAnimation = Tween(begin: 500.0, end: 5.0).animate(
        CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.40, 0.55, curve: Curves.fastOutSlowIn)));
    _profileOpacityAnimation = Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: _controller, curve: const Interval(0.55, 0.75)));
    _profileWidthAnimation = Tween(begin: 1.0, end: 400.0).animate(
        CurvedAnimation(
            parent: _controller, curve: const Interval(0.60, 0.85)));
    _profileHeightAnimation = Tween(begin: 5.0, end: 370.0).animate(
        CurvedAnimation(parent: _controller, curve: const Interval(0.1, 0.35)));
    _profileTextOpacityAnimation = Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _controller, curve: const Interval(0.8, 0.95)));

    _controller.forward();

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _controller,
          builder: _buildLayout,
        ),
      ),
    );
  }

  Widget _buildLayout(BuildContext context, Widget? child) {
    return Center(
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.black12,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Opacity(
              opacity: _avatarOpacityAnimation.value,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Container(
                      width: 170,
                      height: 170,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blue
                              .withOpacity(_avatarOpacityAnimation.value)),
                    ),
                    CircleAvatar(
                      radius: _avatarSizeAnimation.value,
                      backgroundImage: const NetworkImage(
                          "https://avatars.githubusercontent.com/u/49674128?v=4"),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5, bottom: 20),
              child: Divider(
                thickness: 1.5,
                height: 0,
                color: Colors.blue,
                indent: 5,
                endIndent: _dividerWidthAnimation.value,
              ),
            ),
            Opacity(
              opacity: _profileOpacityAnimation.value,
              child: Container(
                color: Colors.blue,
                width: _profileWidthAnimation.value,
                height: _profileHeightAnimation.value,
                child: Center(
                    child: Opacity(
                  opacity: _profileTextOpacityAnimation.value,
                  child: const Text(
                    "Your Profile Section",
                    style: TextStyle(color: Colors.white, fontSize: 26),
                  ),
                )),
              ),
            ),
            const Text("สำหรับเรียนรู้วิธีการใช้งาน Interval \nเพื่อหน่วงเวลาการเล่น Animation", textAlign: TextAlign.center, style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
