import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_mqtt_plugin_method_channel.dart';

abstract class FlutterMqttPluginPlatform extends PlatformInterface {
  /// Constructs a FlutterMqttPluginPlatform.
  FlutterMqttPluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterMqttPluginPlatform _instance = MethodChannelFlutterMqttPlugin();

  /// The default instance of [FlutterMqttPluginPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterMqttPlugin].
  static FlutterMqttPluginPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterMqttPluginPlatform] when
  /// they register themselves.
  static set instance(FlutterMqttPluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Stream<String?> getToken() {
    throw UnimplementedError('getToken() has not been implemented.');
  }

  Stream<String?> onReceivedNotification() {
    throw UnimplementedError('onReceivedNotification() has not been implemented.');
  }

  Stream<String?> onOpenedNotification() {
    throw UnimplementedError('onOpenedNotification() has not been implemented.');
  }

  Future<String?> initialNotification() {
    throw UnimplementedError('initialNotification() has not been implemented.');
  }
}
