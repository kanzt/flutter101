import 'package:flutter/material.dart';
import 'package:flutter_all_sensor/src/page/geolocation/geolocation_page.dart';
import 'package:flutter_all_sensor/src/page/index_page.dart';

class AppRoute {
  static const indexPage = 'index';
  static const geolocationPage = 'geolocation';
  static const cameraAndMicPage = 'cameraAndMic';
  static const gyroscopePage = 'gyroscope';
  static const ambientLightSensorPage = 'ambientLightSensor';
  static const accelerometerPage = 'accelerometer';
  static const magnetometerPage = 'magnetometer';

  static final route = <String, WidgetBuilder>{
    indexPage: (context) => const IndexPage(),
    geolocationPage: (context) => const GeolocationPage(),
  };
}
