import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TestWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
     return Container(
      color: Colors.green,
      child: Text('Hello World'),
      alignment: Alignment.center,
      padding: new EdgeInsets.all(40.0),
      margin: new EdgeInsets.only(left: 20.0, bottom: 40.0, top: 50.0),
    );
  }
}