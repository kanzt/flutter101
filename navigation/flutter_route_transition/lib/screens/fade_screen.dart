import 'package:flutter/material.dart';
import 'package:flutter_route_transition/transitions/fade_route.dart';

import '../main.dart';

class FadeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: RaisedButton(
          child: Text('FadeTransition'),
          onPressed: () => Navigator.push(context, FadeRoute(page: Screen2())),
        ),
      ),
    );
  }
}
