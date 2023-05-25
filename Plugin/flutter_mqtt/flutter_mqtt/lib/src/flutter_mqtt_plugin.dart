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
  /// The [onDidReceiveNotificationResponse] is fired when a notification is received in Foreground and Background state
  /// The [onDidReceiveBackgroundNotificationResponse] is fired when a notification is received in Terminated state, You can't touch UI or navigation in this callback, callback need to be annotated with the `@pragma('vm:entry-point')`
  /// The [onTapNotification] is fired when user tap on notification in Foreground and Background state
  /// The [onTapBackgroundNotification] is fired when user tap on notification action in Terminated state and set AndroidNotificationAction.showsUserInterface = false, callback need to be annotated with the `@pragma('vm:entry-point')`
  /// Call this method on application before using the plugin further.
  Future<bool?> initialize(
    InitializationSettings initializationSettings, {
    DidReceiveNotificationResponseCallback? onDidReceiveNotificationResponse,
    DidReceiveBackgroundNotificationResponseCallback?
        onDidReceiveBackgroundNotificationResponse,
    OnTapNotificationCallback? onTapNotification,
    OnTapNotificationCallback? onTapBackgroundNotification,
  }) async {
    if (!_isSupportPlatform()) {
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
        onTapNotification: onTapNotification,
        onTapBackgroundNotification : onTapBackgroundNotification,
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

  /// Returns info on if a notification created from this plugin had been used
  /// to launch the application.
  ///
  /// An example of how this could be used is to change the initial route of
  /// your application when it starts up. If the plugin isn't running on either
  /// Android, iOS then an instance of the
  /// `NotificationAppLaunchDetails` class is returned with
  /// `didNotificationLaunchApp` set to false.
  Future<NotificationAppLaunchDetails?>
      getNotificationAppLaunchDetails() async {
    if (!_isSupportPlatform()) {
      throw Exception('This plugin is not support this platform');
    }

    if (defaultTargetPlatform == TargetPlatform.android) {
      return await resolvePlatformSpecificImplementation<
              AndroidFlutterMqttPlugin>()
          ?.getNotificationAppLaunchDetails();
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      // TODO : เปิดใช้งาน iOS
      // return await resolvePlatformSpecificImplementation<
      //         IOSFlutterLocalNotificationsPlugin>()
      //     ?.getNotificationAppLaunchDetails();
    }
  }

  /// Cancels/removes all notifications.
  /// // TODO : ปรับแก้ Logic ก่อนเรียกให้ทำงาน
  ///
  Future<void> cancelAll() async {
    await FlutterMqttPlatform.instance.cancelAll();
  }

  bool _isSupportPlatform() {
    return (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.android);
  }
}
