import 'package:flutter/material.dart';
import 'package:flutter_bottom_navigation/example3/tab2/calendar_page.dart';
import 'package:flutter_bottom_navigation/example3/widgets/navigator_keys.dart';

class CalendarScreen2 extends StatelessWidget {
  const CalendarScreen2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.red,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.all(16),
              child: const Text(
                'Calendar Screen 2',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white),
              ),
              child: const Text(
                'Go back',
                style: TextStyle(color: Colors.black),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(NavigatorKeys.navigatorKeyMain.currentContext!, CalendarPageScreenRoutes.screen3);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white),
              ),
              child: const Text(
                'Go to Screen 3',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
