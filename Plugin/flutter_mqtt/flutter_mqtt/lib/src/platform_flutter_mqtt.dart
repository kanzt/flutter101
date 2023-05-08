import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:flutter_mqtt/flutter_mqtt.dart';
import 'package:flutter_mqtt/src/callback_dispatcher.dart';
import 'package:flutter_mqtt_plugin_platform_interface/flutter_mqtt_platform_interface.dart';

const MethodChannel _channel = MethodChannel("th.co.cdgs/flutter_mqtt");
const MethodChannel _workerChannel = MethodChannel("th.co.cdgs/flutter_mqtt/worker");

/// An implementation of a local notifications platform using method channels.
class MethodChannelFlutterMqttPlugin extends FlutterMqttPlatform {
  @override
  Future<void> cancelAll() => _channel.invokeMethod('cancelAll');

  @override
  Future<NotificationAppLaunchDetails?>
      getNotificationAppLaunchDetails() async {
    final Map<dynamic, dynamic>? result =
        await _channel.invokeMethod('getNotificationAppLaunchDetails');
    final Map<dynamic, dynamic>? notificationResponse =
        result != null && result.containsKey('notificationResponse')
            ? result['notificationResponse']
            : null;
    return result != null
        ? NotificationAppLaunchDetails(
            result['notificationLaunchedApp'],
            notificationResponse: notificationResponse == null
                ? null
                : NotificationResponse(
                    id: notificationResponse['notificationId'],
                    actionId: notificationResponse['actionId'],
                    input: notificationResponse['input'],
                    notificationResponseType: NotificationResponseType.values[
                        notificationResponse['notificationResponseType']],
                    payload: notificationResponse.containsKey('payload')
                        ? notificationResponse['payload']
                        : null,
                  ),
          )
        : null;
  }
}

/// Android implementation of the Flutter MQTT plugin.
class AndroidFlutterMqttPlugin extends MethodChannelFlutterMqttPlugin {
  DidReceiveNotificationResponseCallback? _ondidReceiveNotificationResponse;

  /// Initializes the plugin.
  ///
  /// Call this method on application before using the
  /// plugin further.
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
  Future<bool> initialize(
    AndroidInitializationSettings initializationSettings, {
    DidReceiveNotificationResponseCallback? onDidReceiveNotificationResponse,
    DidReceiveBackgroundNotificationResponseCallback?
        onDidReceiveBackgroundNotificationResponse,
  }) async {
    _ondidReceiveNotificationResponse = onDidReceiveNotificationResponse;
    _workerChannel.setMethodCallHandler(_handleMethod);

    final Map<String, Object> arguments = initializationSettings.toMap();

    _evaluateBackgroundNotificationCallback(
        onDidReceiveBackgroundNotificationResponse, arguments);

    return await _channel.invokeMethod('initialize', arguments);
  }

  Future<void> _handleMethod(MethodCall call) async {
    print("OK");
    switch (call.method) {
      case 'didReceiveNotificationResponse':
        _ondidReceiveNotificationResponse?.call(
          NotificationResponse(
            id: call.arguments['notificationId'],
            actionId: call.arguments['actionId'],
            input: call.arguments['input'],
            payload: call.arguments['payload'],
            notificationResponseType: NotificationResponseType
                .values[call.arguments['notificationResponseType']],
          ),
        );
        break;
      default:
        return await Future<void>.error('Method not defined');
    }
  }
}

/// iOS implementation of the Flutter MQTT plugin.
class IOSFlutterMqttPlugin extends MethodChannelFlutterMqttPlugin {
  DidReceiveNotificationResponseCallback? _ondidReceiveNotificationResponse;
}

/// Checks [didReceiveBackgroundNotificationResponseCallback], if not `null`,
/// for eligibility to be used as a background callback.
///
/// If the method is `null`, no further action will be taken.
///
/// This will add a `dispatcher_handle` and `callback_handle` argument to the
/// [arguments] map when the config is correct.
void _evaluateBackgroundNotificationCallback(
  DidReceiveBackgroundNotificationResponseCallback?
      didReceiveBackgroundNotificationResponseCallback,
  Map<String, Object> arguments,
) {
  if (didReceiveBackgroundNotificationResponseCallback != null) {
    final CallbackHandle? callback = PluginUtilities.getCallbackHandle(
        didReceiveBackgroundNotificationResponseCallback);
    assert(callback != null, '''
          The backgroundHandler needs to be either a static function or a top 
          level function to be accessible as a Flutter entry point.''');

    final CallbackHandle? dispatcher =
        PluginUtilities.getCallbackHandle(callbackDispatcher);

    arguments['dispatcher_handle'] = dispatcher!.toRawHandle();
    arguments['callback_handle'] = callback!.toRawHandle();
  }
}
