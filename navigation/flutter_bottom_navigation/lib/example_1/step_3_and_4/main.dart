import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

/// Main ingredient to nested navigation is a second Navigator widget
/// When we start with a MaterialApp we introduce a Navigator which we use throughout the app
/// To introduce new navigation we need to introduce a new Navigator widget
/// When we call 'Navigator.method()' then the nearest Navigator widget (above this widget in widget tree) is used.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nested Navigation',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nested Navigation example'),
      ),
      body: NestedScreen(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Business',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'School',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}

class NestedScreenRoutes {
  static const String root = '/';
// static const String detail1 = '/detail1';
// static const String detail2 = '/detail2';
}

class NestedScreen extends StatelessWidget {
  NestedScreen({this.navigatorKey, Key? key}) : super(key: key);
  final GlobalKey<NavigatorState>? navigatorKey;

  Map<String, WidgetBuilder> _routeBuilders(BuildContext context) {
    return {
      '/': (context) => _home(context),

      /// we only have one screen for now
    };
  }

  void _push(BuildContext context, String name) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.grey[700],
          appBar: AppBar(
            title: const Text('Nested screen'),
            leading: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.keyboard_arrow_left_outlined),
            ),
            backgroundColor: Colors.black,
            elevation: 15,
          ),
          body: Center(
            child: Text(
              '$name',
              style: const TextStyle(fontSize: 50, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   body: _home(context)
    // );

    var routeBuilders = _routeBuilders(context);

    return Scaffold(
      body: Navigator(
        key: navigatorKey,
        initialRoute: NestedScreenRoutes.root,
        onGenerateRoute: (routeSettings) {
          return MaterialPageRoute(
              builder: (context) =>
                  routeBuilders[routeSettings.name]!(context));
        },
      ),
    );
  }

  Widget _home(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () => _push(context, 'Page 1'),
              child: const Text(
                'Page A',
                style: TextStyle(fontSize: 50),
              ),
            ),
            GestureDetector(
              onTap: () => _push(context, 'Page 2'),
              child: const Text(
                'Page B',
                style: TextStyle(fontSize: 50),
              ),
            )
          ],
        ),
      ),
    );
  }
}
