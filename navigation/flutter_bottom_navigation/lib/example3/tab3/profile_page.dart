import 'package:flutter/material.dart';
import 'package:flutter_bottom_navigation/example3/tab3/profile_screen_2.dart';
import 'package:flutter_bottom_navigation/example3/tab3/profile_screen_3.dart';


class ProfilePageScreenRoutes {
  static const String root = '/';
  static const String screen2 = '/Profile/Screen2';
  static const String screen3 = '/Profile/Screen3';
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key, required this.navigatorKey}) : super(key: key);

  final GlobalKey<NavigatorState> navigatorKey;

  Map<String, WidgetBuilder> _routeBuilders(BuildContext context) {
    return {
      ProfilePageScreenRoutes.root: (context) => _profile(context),
      ProfilePageScreenRoutes.screen2: (context) => const ProfileScreen2(),
      ProfilePageScreenRoutes.screen3: (context) => const ProfileScreen3(),
    };
  }

  @override
  Widget build(BuildContext context) {
    var routeBuilders = _routeBuilders(context);

    return Scaffold(
      body: Navigator(
        key: navigatorKey,
        initialRoute: ProfilePageScreenRoutes.root,
        onGenerateRoute: (routeSettings) {
          return MaterialPageRoute(
              builder: (context) =>
                  routeBuilders[routeSettings.name]!(context));
        },
      ),
    );
  }

  Widget _profile(BuildContext context) {
    return Container(
      color: Colors.lightBlueAccent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.all(16),
            child: const Text(
              'Profile Screen 1',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, ProfilePageScreenRoutes.screen2);
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
