import 'package:flutter/material.dart';
import 'package:flutter_bottom_navigation/example_4/widgets/navigator_keys.dart';

class CalendarPageScreenRoutes {
  static const String root = '/';
  static const String screen2 = '/Screen2';
  static const String screen3 = '/Screen3';
}

class CalendarPage extends StatelessWidget {
  const CalendarPage({Key? key, required this.navigatorKey}) : super(key: key);

  final GlobalKey<NavigatorState> navigatorKey;

  Map<String, WidgetBuilder> _routeBuilders(BuildContext context) {
    return {
      CalendarPageScreenRoutes.root: (context) => _calendar(context),
    };
  }

  @override
  Widget build(BuildContext context) {
    var routeBuilders = _routeBuilders(context);

    return Scaffold(
      body: Navigator(
        key: navigatorKey,
        initialRoute: CalendarPageScreenRoutes.root,
        onGenerateRoute: (routeSettings) {
          return MaterialPageRoute(
              builder: (context) =>
                  routeBuilders[routeSettings.name]!(context));
        },
      ),
    );
  }

  Widget _calendar(BuildContext context) {
    return Container(
      color: Colors.red,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.all(16),
            child: const Text(
              'Calendar Screen 1',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(
                  NavigatorKeys.navigatorKeyMain.currentContext!,
                  CalendarPageScreenRoutes.screen2);
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.white),
            ),
            child: const Text(
              'Go to next screen',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
