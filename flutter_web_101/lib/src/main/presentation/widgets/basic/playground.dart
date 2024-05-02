import 'package:flutter/material.dart';
import 'package:flutter_web_101/src/res/drawable/drawable.dart';

class Playground extends StatelessWidget {
  const Playground({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildStack(),
    );
  }

  _buildRow() {
    return SizedBox(
      // color: Colors.red,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Colors.orange,
            child: const FlutterLogo(
              size: 60.0,
            ),
          ),
          Container(
            color: Colors.blue,
            child: const FlutterLogo(
              size: 60.0,
            ),
          ),
          Container(
            color: Colors.purple,
            child: const FlutterLogo(
              size: 60.0,
            ),
          ),
        ],
      ),
    );
  }

  _buildColumn() {
    return SizedBox(
      // color: Colors.red,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Colors.orange,
            child: const FlutterLogo(
              size: 60.0,
            ),
          ),
          Container(
            color: Colors.blue,
            child: const FlutterLogo(
              size: 60.0,
            ),
          ),
          Container(
            color: Colors.purple,
            child: const FlutterLogo(
              size: 60.0,
            ),
          ),
        ],
      ),
    );
  }

  _buildStack() {
    return Container(
      // color: Colors.red,
      width: double.infinity,
      child: Stack(
        alignment: AlignmentDirectional.topStart,
        children: [
          Container(
            color: Colors.orange,
            child: const FlutterLogo(
              size: 80.0,
            ),
          ),
          Container(
            color: Colors.blue,
            child: const FlutterLogo(
              size: 70.0,
            ),
          ),
          Container(
            color: Colors.purple,
            child: const FlutterLogo(
              size: 60.0,
            ),
          ),
        ],
      ),
    );
  }

  _buildContainer() {
    return Container(
      width: 48,
      height: 48,
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.amber[600],
      ),
    );
  }

  _buildPadding() {
    return Container(
      color: Colors.red,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: _buildContainer(),
      ),
    );
  }

  _buildText() {
    return const Text(
      "Hello World",
      style: TextStyle(
        color: Colors.red,
        fontWeight: FontWeight.bold,
        fontSize: 40,
      ),
    );
  }

  _buildImage() {
    return Image.asset(
      Drawable.logo,
      width: 200,
      height: 200,
    );
  }
}
