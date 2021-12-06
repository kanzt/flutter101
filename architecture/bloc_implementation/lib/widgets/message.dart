import 'package:bloc_implementation/themes/themes.dart';
import 'package:flutter/material.dart';

class Message extends StatelessWidget {
  final String message;

  const Message({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Text(message, style: messageTextStyle, textAlign: TextAlign.center,),
      ),
    );
  }
}
