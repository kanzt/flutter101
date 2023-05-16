import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mqtt/flutter_mqtt.dart';
import 'package:flutter_mqtt/src/callback_dispatcher.dart';
import 'package:flutter_mqtt_plugin_platform_interface/flutter_mqtt_platform_interface.dart';

/// Constants
const NOTIFICATION_EVENT_CHANNEL = "th.co.cdgs/flutter_mqtt/notification";
const METHOD_CHANNEL = "th.co.cdgs/flutter_mqtt";
const WORKER_METHOD_CHANNEL = "th.co.cdgs/flutter_mqtt/worker";

/// Arguments
const NOTIFICATION_PAYLOAD = "payload";
const NOTIFICATION_ID = "notificationId";
const DISPATCHER_HANDLE = "dispatcher_handle";
const CALLBACK_HANDLE = "callback_handle";

/// MethodChannel & EventChannel
const MethodChannel _channel = MethodChannel(METHOD_CHANNEL);
const notificationEventChannel = EventChannel(NOTIFICATION_EVENT_CHANNEL);

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
            // TODO : ปรับเป็น Response ที่ต้องการ
                :

            NotificationResponse(
              id: null,
              actionId: null,
              input: null,
              payload: notificationResponse.containsKey('payload')
                  ? notificationResponse['payload']
                  : null,
              notificationResponseType:
              NotificationResponseType.selectedNotificationAction,
            ),
          )
        : null;
  }
}

/// Android implementation of the Flutter MQTT plugin.
class AndroidFlutterMqttPlugin extends MethodChannelFlutterMqttPlugin {
  DidReceiveNotificationResponseCallback? _onDidReceiveNotificationResponse;
  OnOpenedNotificationCallback? _onOpenedNotification;

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
    OnOpenedNotificationCallback? onOpenedNotification,
    DidReceiveBackgroundNotificationResponseCallback?
        onDidReceiveBackgroundNotificationResponse,
  }) async {
    _onDidReceiveNotificationResponse = onDidReceiveNotificationResponse;
    _onOpenedNotification = onOpenedNotification;

    _channel.setMethodCallHandler(_handleMethod);

    final Map<String, Object> arguments = initializationSettings.toMap();

    _evaluateBackgroundNotificationCallback(
        onDidReceiveBackgroundNotificationResponse, arguments);

    return await _channel.invokeMethod('initialize', arguments);
  }

  // TODO : ปรับ NotificationResponse ไปเป็นรูปแบบที่ต้องการใช้งาน
  Future<void> _handleMethod(MethodCall call) async {
    if (kDebugMode) {
      print("_handleMethod is working");
    }

    switch (call.method) {
      case 'didReceiveNotificationResponse':
        _onDidReceiveNotificationResponse?.call(
          NotificationResponse(
            id: call.arguments[NOTIFICATION_ID],
            actionId: null,
            input: null,
            payload: call.arguments[NOTIFICATION_PAYLOAD],
            notificationResponseType:
                NotificationResponseType.selectedNotification,
          ),
        );
        break;
      case 'onMessageOpenedApp':
        _onOpenedNotification?.call(
          NotificationResponse(
            id: call.arguments[NOTIFICATION_ID],
            actionId: null,
            input: null,
            payload: call.arguments[NOTIFICATION_PAYLOAD],
            notificationResponseType:
                NotificationResponseType.selectedNotification,
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
  OnOpenedNotificationCallback? _onOpenedNotification;
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

    arguments[DISPATCHER_HANDLE] = dispatcher!.toRawHandle();
    arguments[CALLBACK_HANDLE] = callback!.toRawHandle();
  }
}
