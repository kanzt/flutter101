import 'package:ambient_light/ambient_light.dart';
import 'package:flutter/material.dart';

class AmbientLightPage extends StatefulWidget {
  const AmbientLightPage({super.key});

  @override
  State<AmbientLightPage> createState() => _AmbientLightPageState();
}

class _AmbientLightPageState extends State<AmbientLightPage> {
  double? lightLevel;

  @override
  void initState() {
    super.initState();

    // double? lightLevel = await AmbientLight().currentAmbientLight();
    // print('Ambient light level: $lightLevel');

    // Listen to ambient light sensor data stream
    AmbientLight().ambientLightStream.listen((double lightLevel) {
      print('Ambient light level: $lightLevel');
      setState(() {
        lightLevel = lightLevel;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Ambient light sensor supports only Android and iOS"),
            Text("Please open console to see Light level"),
          ],
        ),
      ),
    );
  }
}
