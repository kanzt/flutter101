import 'package:flutter/material.dart';
import 'package:flutter_bottom_navigation/example_3/widgets/screen2.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.lightBlueAccent,
      child: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(
                builder: (context) => const Screen2()
            ));
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.white),
          ),
          child: const Text('Go to next screen', style: TextStyle(color: Colors.black),),
        ),
      ),
    );
  }
}