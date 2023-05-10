import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'src/types.dart';

export 'src/helpers.dart';
export 'src/typedefs.dart';
export 'src/types.dart';

abstract class FlutterMqttPlatform extends PlatformInterface {
  /// Constructs a FlutterMqttPlatform.
  FlutterMqttPlatform() : super(token: _token);

  static final Object _token = Object();

  static late FlutterMqttPlatform _instance;

  /// The default instance of [FlutterMqttPlatform] to use.
  static FlutterMqttPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterMqttPlatform] when
  /// they register themselves.
  static set instance(FlutterMqttPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Returns info on if a notification had been used to launch the application.
  Future<NotificationAppLaunchDetails?>
  getNotificationAppLaunchDetails() async {
    throw UnimplementedError(
        'getNotificationAppLaunchDetails() has not been implemented');
  }

  /// Unsubscribe to notification server
  Future<void> cancelAll() async {
    throw UnimplementedError('cancelAll() has not been implemented');
  }


  Stream<NotificationResponse?> onReceiveNotification(){
    throw UnimplementedError('onReceiveNotification() has not been implemented');
  }
}
