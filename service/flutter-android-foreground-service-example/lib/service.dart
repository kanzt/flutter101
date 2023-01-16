import 'dart:async';

import 'package:flutter/services.dart';

class Service {
  // New Method Channel
  static MethodChannel _methodChannel = const MethodChannel('example_service');

  // New Event Channel
  static const EventChannel _eventChannel =
      const EventChannel('connect_status');
  static const EventChannel _eventChannelFs =
      const EventChannel('foreground_service_stream');

  static Service _instance = Service._privateConstructor();

  static Service get instance => _instance;

  Service._privateConstructor();

  Stream<String> get onConnectStatus {
    return _eventChannel.receiveBroadcastStream().cast();
  }

  Stream<String> listenToForegroundService() {
    return _eventChannelFs.receiveBroadcastStream().cast();
  }

  Future<String?> startForegroundService() async {
    try {
      final result = await _methodChannel.invokeMethod('startExampleService');
      return result as String?;
    } on PlatformException catch (e) {
      print("Failed to invoke method: '${e.message}'.");
    }
    return null;
  }

  Future<String?> stopForegroundService() async {
    try {
      final result = await _methodChannel.invokeMethod('stopExampleService');
      return result as String?;
    } on PlatformException catch (e) {
      print("Failed to invoke method: '${e.message}'.");
    }
    return null;
  }

  Future<String?> startBackgroundService() async {
    try {
      final result =
          await _methodChannel.invokeMethod('startExampleBackgroundService');
      return result as String?;
    } on PlatformException catch (e) {
      print("Failed to invoke method: '${e.message}'.");
    }
    return null;
  }

  Future<String?> stopBackgroundService() async {
    try {
      final result =
          await _methodChannel.invokeMethod('stopExampleBackgroundService');
      return result as String?;
    } on PlatformException catch (e) {
      print("Failed to invoke method: '${e.message}'.");
    }
    return null;
  }
}
