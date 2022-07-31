import 'package:flutter/material.dart';
import 'package:flutter_bottom_navigation/example3/tab1/home_screen_2.dart';
import 'package:flutter_bottom_navigation/example3/tab1/home_screen_3.dart';

class HomePageScreenRoutes {
  static const String root = '/';
  static const String screen2 = '/screen2';
  static const String screen3 = '/screen3';
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key, required this.navigatorKey}) : super(key: key);

  final GlobalKey<NavigatorState> navigatorKey;

  Map<String, WidgetBuilder> _routeBuilders(BuildContext context) {
    return {
      /// ลงทะเบียน Nested Route ที่นี่
      HomePageScreenRoutes.root : (context) => _home(context),
      HomePageScreenRoutes.screen2 : (context) => const HomeScreen2(),
      HomePageScreenRoutes.screen3 : (context) => const HomeScreen3(),
    };
  }

  @override
  Widget build(BuildContext context) {
    var routeBuilders = _routeBuilders(context);

    return Scaffold(
      body: Navigator(
        key: navigatorKey,
        initialRoute: HomePageScreenRoutes.root,
        onGenerateRoute: (routeSettings) {
          return MaterialPageRoute(
              builder: (context) =>
                  routeBuilders[routeSettings.name]!(context));
        },
      ),
    );
  }

  Widget _home(BuildContext context) {
    return Container(
      color: Colors.lightBlueAccent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.all(16),
            child: const Text(
              'Home Screen 1',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, HomePageScreenRoutes.screen2);
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
