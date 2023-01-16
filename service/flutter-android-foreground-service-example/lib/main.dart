import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_foreground_example/service.dart';

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
  String? _serverState = 'Did not make the call yet';

  StreamSubscription? subscription;

  @override
  void initState() {
    super.initState();

    subscription = Service.instance.listenToForegroundService().listen((event) {
      print(event);
    });
  }

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
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
            Text(_serverState ?? ""),
            StreamBuilder(
              stream: Service.instance.onConnectStatus,
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                return Text("Stream status : ${snapshot.data ?? ''}");
              },
            ),
            ElevatedButton(
                child: Text('Start Foreground Service'),
                onPressed: () async {
                  final result =
                      await Service.instance.startForegroundService();
                  setState(() {
                    _serverState = result;
                  });
                }),
            ElevatedButton(
                child: Text('Stop Foreground Service'),
                onPressed: () async {
                  final result = await Service.instance.stopForegroundService();
                  setState(() {
                    _serverState = result;
                  });
                }),
            ElevatedButton(
                child: Text('Start Background Service'),
                onPressed: () async {
                  final result =
                      await Service.instance.startBackgroundService();
                  setState(() {
                    _serverState = result;
                  });
                }),
            ElevatedButton(
                child: Text('Stop Background Service'),
                onPressed: () async {
                  final result = await Service.instance.stopBackgroundService();
                  setState(() {
                    _serverState = result;
                  });
                }),
          ],
        ),
      ),
    );
  }
}
