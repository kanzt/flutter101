import 'package:flutter/material.dart';
import 'package:flutter_drawer_menu/drawer/app_drawer.dart';
import 'package:flutter_drawer_menu/drawer/sliding_drawer.dart';

class SlidingDrawerPage extends StatefulWidget {
  const SlidingDrawerPage({Key? key}) : super(key: key);

  @override
  _SlidingDrawerPageState createState() => _SlidingDrawerPageState();
}

class _SlidingDrawerPageState extends State<SlidingDrawerPage> {
  bool _isOpen = false;

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return SlidingDrawer(
        isOpen: _isOpen,
        openFn: () {
          setState(() {
            _isOpen = true;
          });
        },
        closeFn: () {
          setState(() {
            _isOpen = false;
          });
        },
        drawer: const AppDrawer(),
        child: Scaffold(
          appBar: AppBar(
            // Here we take the value from the MyHomePage object that was created by
            // the App.build method, and use it to set our appbar title.
            title: const Text('Flutter Demo Home Page'),
            leading: IconButton(
              onPressed: () {
                setState(() {
                  _isOpen = !_isOpen;
                });
              },
              icon: const Icon(Icons.menu),
            ),
          ),
          body: Center(
            // Center is a layout widget. It takes a single child and positions it
            // in the middle of the parent.
            child: Column(
              // Column is also a layout widget. It takes a list of children and
              // arranges them vertically. By default, it sizes itself to fit its
              // children horizontally, and tries to be as tall as its parent.
              //
              // Invoke "debug painting" (press "p" in the console, choose the
              // "Toggle Debug Paint" action from the Flutter Inspector in Android
              // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
              // to see the wireframe for each widget.
              //
              // Column has various properties to control how it sizes itself and
              // how it positions its children. Here we use mainAxisAlignment to
              // center the children vertically; the main axis here is the vertical
              // axis because Columns are vertical (the cross axis would be
              // horizontal).
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                Text(
                  'You have pushed the button this many times:',
                ),
              ],
            ),
          ),
        ));
  }
}
