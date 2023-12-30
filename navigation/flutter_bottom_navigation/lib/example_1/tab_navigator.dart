import 'package:flutter/material.dart';
import 'package:flutter_bottom_navigation/example_1/navigator_keys.dart';

class NestedScreenRoutes {
  static const String root = '/';
// static const String detail1 = '/detail1';
// static const String detail2 = '/detail2';
}

class NestedScreen extends StatelessWidget {
  const NestedScreen({required this.navigatorKey, Key? key}) : super(key: key);
  final GlobalKey<NavigatorState> navigatorKey;

  /// Will be used to navigate

  void _push(BuildContext context, String name) {
    // Navigator.of(navigatorKey.currentContext).push(
    //
    BuildContext _desiredContext;

    if (name == 'Page 1') {
      _desiredContext = navigatorKey.currentContext!;
    } else {
      _desiredContext = NavigatorKeys.navigatorKeyMain.currentContext!;
    }
    Navigator.of(_desiredContext).push(
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
            child: Column(
              children: [
                Text(
                  '$name',
                  style: const TextStyle(fontSize: 50, color: Colors.white),
                ),
                ElevatedButton(onPressed: (){
                  _push(context, name);
                }, child: const Text("Goto nested screen")),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Map<String, WidgetBuilder> _routeBuilders(
    BuildContext context,
  ) {
    return {
      '/': (context) => _home(context),

      // NestedScreenRoutes.detail1: (context) => Scaffold(
      //       body: GestureDetector(
      //         onTap: () => _push(context, 'Page 2'),
      //         child: Text(
      //           'Page B',
      //           style: TextStyle(fontSize: 50),
      //         ),
      //       ),
      //     ),

      // NestedScreenRoutes.detail2: (context) => Scaffold(
      //       body: GestureDetector(
      //         onTap: () => _push(context, 'Page 2'),
      //         child: Text(
      //           'Page B',
      //           style: TextStyle(fontSize: 50),
      //         ),
      //       ),
      //     ),
    };
  }

  @override
  Widget build(BuildContext context) {
    var routeBuilders = _routeBuilders(context);

    return WillPopScope(
      onWillPop: () async {
        final isFirstRouteInCurrentTab = !await navigatorKey.currentState!.maybePop();

        // let system handle back button if we're on the first route
        return isFirstRouteInCurrentTab;

      },
      child: Scaffold(
        // body: _home(context)
        ///
        body: Navigator(
          key: navigatorKey,
          initialRoute: NestedScreenRoutes.root,

          /// Starting route from the onGenerateRoute map

          onGenerateRoute: (routeSettings) {
            /// Generate the route we want
            return MaterialPageRoute(builder: (context) {
              return routeBuilders[routeSettings.name]!(context);
            });
          },
        ),
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
