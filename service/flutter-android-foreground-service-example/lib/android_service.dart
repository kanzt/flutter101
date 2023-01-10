import 'package:flutter/services.dart';

class AndroidService {
  static MethodChannel _methodChannel = const MethodChannel('example_service');

  static AndroidService _instance = AndroidService._privateConstructor();
  static AndroidService get instance => _instance;

  AndroidService._privateConstructor();

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
