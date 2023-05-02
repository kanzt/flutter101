import 'package:flutter/foundation.dart';
import 'package:flutter_mqtt_plugin/src/entity/initialization_settings.dart';
import 'package:flutter_mqtt_plugin/src/flutter_mqtt_plugin_platform_interface.dart';
import 'package:flutter_mqtt_plugin/src/platform_flutter_mqtt_plugin.dart';

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
      FlutterMqttPluginPlatform.instance = AndroidFlutterMqttPlugin();
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      FlutterMqttPluginPlatform.instance = IOSFlutterMqttPlugin();
    }
  }

  /// Returns the underlying platform-specific implementation of given type [T],
  /// which must be a concrete subclass of [FlutterMqttPluginPlatform]
  ///
  /// Requires running on the appropriate platform that matches the specified
  /// type for a result to be returned. For example, when the specified type
  /// argument is of type [AndroidFlutterMqttPlugin], this will
  /// only return a result of that type when running on Android.
  T? resolvePlatformSpecificImplementation<
      T extends FlutterMqttPluginPlatform>() {
    if (T == FlutterMqttPluginPlatform) {
      throw ArgumentError.value(
          T,
          'The type argument must be a concrete subclass of '
          'FlutterMqttPluginPlatform');
    }
    if (kIsWeb ||
        defaultTargetPlatform == TargetPlatform.macOS ||
        defaultTargetPlatform == TargetPlatform.linux) {
      return null;
    }

    if (defaultTargetPlatform == TargetPlatform.android &&
        T == AndroidFlutterMqttPlugin &&
        FlutterMqttPluginPlatform.instance is AndroidFlutterMqttPlugin) {
      return FlutterMqttPluginPlatform.instance as T?;
    } else if (defaultTargetPlatform == TargetPlatform.iOS &&
        T == IOSFlutterMqttPlugin &&
        FlutterMqttPluginPlatform.instance is IOSFlutterMqttPlugin) {
      return FlutterMqttPluginPlatform.instance as T?;
    }

    return null;
  }

  /// Initializes the plugin.
  ///
  /// Call this method on application before using the plugin further.
  ///
  /// Will return a [bool] value to indicate if initialization succeeded.
  /// On iOS this is dependent on if permissions have been granted to show
  /// notification When running in environment that is neither Android and
  /// iOS (e.g. when running tests), this will be a no-op and return true.
  ///
  /// Note that on iOS, initialisation may also request notification
  /// permissions where users will see a permissions prompt. This may be fine
  /// in cases where it's acceptable to do this when the application runs for
  /// the first time. However, if your application needs to do this at a later
  /// point in time, set the
  /// [DarwinInitializationSettings.requestAlertPermission],
  /// [DarwinInitializationSettings.requestBadgePermission] and
  /// [DarwinInitializationSettings.requestSoundPermission] values to false.
  /// [IOSFlutterLocalNotificationsPlugin.requestPermissions] can then be called
  /// to request permissions when needed.
  ///
  /// The [onDidReceiveNotificationResponse] callback is fired when the user
  /// selects a notification or notification action that should show the
  /// application/user interface.
  /// application was running. To handle when a notification launched an
  /// application, use [getNotificationAppLaunchDetails]. For notification
  /// actions that don't show the application/user interface, the
  /// [onDidReceiveBackgroundNotificationResponse] callback is invoked on
  /// a background isolate. Functions passed to the
  /// [onDidReceiveBackgroundNotificationResponse]
  /// callback need to be annotated with the `@pragma('vm:entry-point')`
  /// annotation to ensure they are not stripped out by the Dart compiler.
  Future<bool?> initialize(
    InitializationSettings initializationSettings, {
    DidReceiveNotificationResponseCallback? onDidReceiveNotificationResponse,
    DidReceiveBackgroundNotificationResponseCallback?
        onDidReceiveBackgroundNotificationResponse,
  }) async {
    if (kIsWeb ||
        defaultTargetPlatform == TargetPlatform.macOS ||
        defaultTargetPlatform == TargetPlatform.linux) {
      return true;
    }

    if (defaultTargetPlatform == TargetPlatform.android) {
      if (initializationSettings.android == null) {
        throw ArgumentError(
            'Android settings must be set when targeting Android platform.');
      }

      return resolvePlatformSpecificImplementation<
              AndroidFlutterMqttPlugin>()
          ?.initialize(
        initializationSettings.android!,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
        onDidReceiveBackgroundNotificationResponse:
            onDidReceiveBackgroundNotificationResponse,
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      if (initializationSettings.iOS == null) {
        throw ArgumentError(
            'iOS settings must be set when targeting iOS platform.');
      }

      return await resolvePlatformSpecificImplementation<
              IOSFlutterMqttPlugin>()
          ?.initialize(
        initializationSettings.iOS!,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
        onDidReceiveBackgroundNotificationResponse:
            onDidReceiveBackgroundNotificationResponse,
      );
    }

    return true;
  }

// Stream<String?> getToken() {
//   return FlutterMqttPluginPlatform.instance.getToken();
// }
//
// Stream<String?> onReceivedNotification() {
//   return FlutterMqttPluginPlatform.instance.onReceivedNotification();
// }
//
// Stream<String?> onOpenedNotification() {
//   return FlutterMqttPluginPlatform.instance.onOpenedNotification();
// }
//
// Future<String?> getPendingNotification() {
//   return FlutterMqttPluginPlatform.instance.getPendingNotification();
// }
//
// void connectMQTT(InitializationSettings initializationSettings) {
//    FlutterMqttPluginPlatform.instance.connectMQTT(initializationSettings);
// }
//
// Future<bool?> disconnectMQTT() {
//   return FlutterMqttPluginPlatform.instance.disconnectMQTT();
// }
}
