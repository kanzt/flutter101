import 'package:flutter/material.dart';

class ConsumerPage extends StatelessWidget {
  const ConsumerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Waiting for notification..."),
      ),
    );
  }
}
