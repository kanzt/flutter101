import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Foreground Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Foreground Example Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const platform = const MethodChannel('example_service');
  String _serverState = 'Did not make the call yet';

  Future<void> _startForegroundService() async {
    try {
      final result = await platform.invokeMethod('startExampleService');
      setState(() {
        _serverState = result;
      });
    } on PlatformException catch (e) {
      print("Failed to invoke method: '${e.message}'.");
    }
  }

  Future<void> _stopForegroundService() async {
    try {
      final result = await platform.invokeMethod('stopExampleService');
      setState(() {
        _serverState = result;
      });
    } on PlatformException catch (e) {
      print("Failed to invoke method: '${e.message}'.");
    }
  }

  Future<void> _startBackgroundService() async {
    try {
      final result = await platform.invokeMethod('startExampleBackgroundService');
      setState(() {
        _serverState = result;
      });
    } on PlatformException catch (e) {
      print("Failed to invoke method: '${e.message}'.");
    }
  }

  Future<void> _stopBackgroundService() async {
    try {
      final result = await platform.invokeMethod('stopExampleBackgroundService');
      setState(() {
        _serverState = result;
      });
    } on PlatformException catch (e) {
      print("Failed to invoke method: '${e.message}'.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_serverState),
            ElevatedButton(
              child: Text('Start Foreground Service'),
              onPressed: _startForegroundService,
            ),
            ElevatedButton(
              child: Text('Stop Foreground Service'),
              onPressed: _stopForegroundService,
            ),
            ElevatedButton(
              child: Text('Start Background Service'),
              onPressed: _startBackgroundService,
            ),
            ElevatedButton(
              child: Text('Stop Background Service'),
              onPressed: _stopBackgroundService,
            ),
          ],
        ),
      ),
    );
  }
}
