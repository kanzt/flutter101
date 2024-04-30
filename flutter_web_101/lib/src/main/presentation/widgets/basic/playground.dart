import 'package:flutter/material.dart';

class Playground extends StatelessWidget {
  const Playground({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildColumn();
  }

  _buildRow(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
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
    );
  }

  _buildColumn(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
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
    );
  }

  _buildContainer(){
    return
  }
}
