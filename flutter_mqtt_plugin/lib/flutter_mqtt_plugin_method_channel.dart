import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_mqtt_plugin_platform_interface.dart';

const tokenChannelName = "th.co.cdgs.flutter_mqtt_plugin/token";
const messageChannelName = "th.co.cdgs.flutter_mqtt_plugin/onReceivedMessage";
const openNotificationChannelName =
    "th.co.cdgs.flutter_mqtt_plugin/onOpenedNotification";

/// An implementation of [FlutterMqttPluginPlatform] that uses method channels.
class MethodChannelFlutterMqttPlugin extends FlutterMqttPluginPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_mqtt_plugin');
  final tokenUpdateEventChannel = const EventChannel(tokenChannelName);
  final messageEventChannel = const EventChannel(messageChannelName);
  final openNotificationEventChannel =
      const EventChannel(openNotificationChannelName);

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Stream<String?> getToken() {
    return tokenUpdateEventChannel
        .receiveBroadcastStream(tokenChannelName)
        .cast();
  }

  @override
  Stream<String?> onReceivedNotification() {
    return messageEventChannel
        .receiveBroadcastStream(messageChannelName)
        .cast();
  }

  @override
  Stream<String?> onOpenedNotification() {
    return messageEventChannel
        .receiveBroadcastStream(openNotificationChannelName)
        .cast();
  }
}
