import 'package:flutter/foundation.dart';
import 'package:flutter_mqtt/flutter_mqtt.dart';
import 'package:flutter_mqtt_plugin_platform_interface/flutter_mqtt_platform_interface.dart';

/// Provides cross-platform functionality for receiving push notification.
///
/// The plugin will check the platform that is running on to use the appropriate
/// platform-specific implementation of the plugin. The plugin methods will be a
/// no-op when the platform can't be detected.
///
/// Use [resolvePlatformSpecificImplementation] and pass the platform-specific
/// type of the plugin to get the underlying platform-specific implementation
/// if access to platform-specific APIs are needed.
class FlutterMqttPlugin {
  /// Factory for create an instance of [FlutterMqttPlugin].
  factory FlutterMqttPlugin() => _instance;

  static final FlutterMqttPlugin _instance = FlutterMqttPlugin._();

  FlutterMqttPlugin._() {
    if (kIsWeb ||
        defaultTargetPlatform == TargetPlatform.macOS ||
        defaultTargetPlatform == TargetPlatform.linux) {
      return;
    }
    if (defaultTargetPlatform == TargetPlatform.android) {
      FlutterMqttPlatform.instance = AndroidFlutterMqttPlugin();
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      FlutterMqttPlatform.instance = IOSFlutterMqttPlugin();
    }
  }

  /// Returns the underlying platform-specific implementation of given type [T],
  /// which must be a concrete subclass of [FlutterMqttPlatform]
  ///
  /// Requires running on the appropriate platform that matches the specified
  /// type for a result to be returned. For example, when the specified type
  /// argument is of type [AndroidFlutterMqttPlugin], this will
  /// only return a result of that type when running on Android.
  T? resolvePlatformSpecificImplementation<T extends FlutterMqttPlatform>() {
    if (T == FlutterMqttPlatform) {
      throw ArgumentError.value(
          T,
          'The type argument must be a concrete subclass of '
          'FlutterMqttPlatform');
    }
    if (kIsWeb ||
        defaultTargetPlatform == TargetPlatform.macOS ||
        defaultTargetPlatform == TargetPlatform.linux) {
      return null;
    }

    if (defaultTargetPlatform == TargetPlatform.android &&
        T == AndroidFlutterMqttPlugin &&
        FlutterMqttPlatform.instance is AndroidFlutterMqttPlugin) {
      return FlutterMqttPlatform.instance as T?;
    } else if (defaultTargetPlatform == TargetPlatform.iOS &&
        T == IOSFlutterMqttPlugin &&
        FlutterMqttPlatform.instance is IOSFlutterMqttPlugin) {
      return FlutterMqttPlatform.instance as T?;
    }

    return null;
  }

  /// Initializes the plugin.
  ///
  /// Call this method on application before using the plugin further.
  Future<bool?> initialize(
    InitializationSettings initializationSettings, {
    DidReceiveNotificationResponseCallback? onDidReceiveNotificationResponse,
    DidReceiveBackgroundNotificationResponseCallback?
        onDidReceiveBackgroundNotificationResponse,
  }) async {
    if (kIsWeb ||
        defaultTargetPlatform == TargetPlatform.macOS ||
        defaultTargetPlatform == TargetPlatform.linux) {
      throw Exception('This plugin is not support this platform');
    }

    if (defaultTargetPlatform == TargetPlatform.android) {
      if (initializationSettings.android == null) {
        throw ArgumentError(
            'Android settings must be set when targeting Android platform.');
      }

      return resolvePlatformSpecificImplementation<AndroidFlutterMqttPlugin>()
          ?.initialize(
        initializationSettings.android!,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
        onDidReceiveBackgroundNotificationResponse:
            onDidReceiveBackgroundNotificationResponse,
      );
    }
    // TODO : เปิดใช้งาน iOS
    // else if (defaultTargetPlatform == TargetPlatform.iOS) {
    //   if (initializationSettings.iOS == null) {
    //     throw ArgumentError(
    //         'iOS settings must be set when targeting iOS platform.');
    //   }
    //
    //   return await resolvePlatformSpecificImplementation<IOSFlutterMqttPlugin>()
    //       ?.initialize(
    //     initializationSettings.iOS!,
    //     onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
    //     onDidReceiveBackgroundNotificationResponse:
    //         onDidReceiveBackgroundNotificationResponse,
    //   );
    // }
    return true;
  }

  Stream<NotificationResponse?> onReceivedNotification() {
    if (kIsWeb ||
        defaultTargetPlatform == TargetPlatform.macOS ||
        defaultTargetPlatform == TargetPlatform.linux) {
      throw Exception('This plugin is not support this platform');
    }

    return FlutterMqttPlatform.instance.onReceiveNotification();
  }

  /// Cancels/removes all notifications.
  ///
  Future<void> cancelAll() async {
    await FlutterMqttPlatform.instance.cancelAll();
  }
}
