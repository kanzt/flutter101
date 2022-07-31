import 'package:flutter/material.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({Key? key, this.onNext}) : super(key: key);


  final VoidCallback? onNext;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      child: Center(
        child: ElevatedButton(
          onPressed: onNext,
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.white),
          ),
          child: const Text('Go to next screen', style: TextStyle(color: Colors.black),),
        ),
      ),
    );
  }
}
