import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_all_sensor/src/config/app_route.dart';
import 'package:flutter_all_sensor/src/page/cameraandmic/camera/camera_and_mic_page.dart';
import 'package:flutter_all_sensor/src/page/cameraandmic/image_picker/image_picker_page.dart';

class IndexPage extends StatelessWidget {
  const IndexPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  AppRoute.geolocationPage,
                );
              },
              child: const Text("Geolocation"),
            ),
            const SizedBox(
              height: 8,
            ),
            ElevatedButton(
              onPressed: () async {
                await availableCameras().then(
                  (value) => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CameraAndMicPage(cameras: value),
                    ),
                  ),
                );
              },
              child: const Text("Camera and Mic (lib camera)"),
            ),
            const SizedBox(
              height: 8,
            ),
            ElevatedButton(
              onPressed: () async {
                await availableCameras().then(
                      (value) => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ImagePickerPage(),
                    ),
                  ),
                );
              },
              child: const Text("Camera and Mic (lib image_picker)"),
            ),
            const SizedBox(
              height: 8,
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pushNamed(
                  context,
                  AppRoute.sensorPlusPage,
                );
              },
              child: const Text("Sensor Plus"),
            ),
            const SizedBox(
              height: 8,
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pushNamed(
                  context,
                  AppRoute.ambientLightSensorPage,
                );
              },
              child: const Text("Ambient Light"),
            ),
          ],
        ),
      ),
    );
  }
}
