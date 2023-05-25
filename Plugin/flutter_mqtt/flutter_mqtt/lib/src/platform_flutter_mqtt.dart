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
const ACTION_EVENT_CHANNEL = "th.co.cdgs/flutter_mqtt/actions";

/// Arguments
const NOTIFICATION_PAYLOAD = "payload";
const NOTIFICATION_ID = "notificationId";
const ACTION_ID = "actionId";
const DISPATCHER_HANDLE = "dispatcher_handle";
const RECEIVE_BACKGROUND_NOTIFICATION_CALLBACK_HANDLE = "receive_background_notification_callback_handle";

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
                : NotificationResponse(
                    id: notificationResponse[NOTIFICATION_ID],
                    actionId: notificationResponse[ACTION_ID],
                    input: null,
                    payload:
                        notificationResponse.containsKey(NOTIFICATION_PAYLOAD)
                            ? notificationResponse[NOTIFICATION_PAYLOAD]
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
  OnTapNotificationCallback? _onTapNotification;

  /// Initializes the plugin.
  ///
  /// Call this method on application before using the
  /// plugin further.
  ///
  /// The [onDidReceiveNotificationResponse] callback is fired when a notification is received in Foreground and Background state
  /// The [onDidReceiveBackgroundNotificationResponse] is fired when a notification is received in Terminated state, callback need to be annotated with the `@pragma('vm:entry-point')`
  /// The [onTapNotification] is fired when user tap on notification in Foreground and Background state
  /// The [onTapBackgroundNotification] is fired when user tap on notification action in Terminated state and set AndroidNotificationAction.showsUserInterface = false, callback need to be annotated with the `@pragma('vm:entry-point')`
  /// annotation to ensure they are not stripped out by the Dart compiler.
  ///
  /// To handle when a notification launched an
  /// application, use [getNotificationAppLaunchDetails].
  Future<bool> initialize(
    AndroidInitializationSettings initializationSettings, {
    DidReceiveNotificationResponseCallback? onDidReceiveNotificationResponse,
    DidReceiveBackgroundNotificationResponseCallback?
        onDidReceiveBackgroundNotificationResponse,
    OnTapNotificationCallback? onTapNotification,
    OnTapNotificationCallback? onTapBackgroundNotification,
  }) async {
    _onDidReceiveNotificationResponse = onDidReceiveNotificationResponse;
    _onTapNotification = onTapNotification;

    _channel.setMethodCallHandler(_handleMethod);

    final Map<String, dynamic> arguments = initializationSettings.toMap();

    _evaluateBackgroundNotificationCallback(
        onDidReceiveBackgroundNotificationResponse, arguments);

    return await _channel.invokeMethod('initialize', arguments);
  }

  // TODO : ปรับ NotificationResponse ไปเป็นรูปแบบที่ต้องการใช้งาน
  NotificationResponse _buildNotificationResponse(dynamic arguments) {
    return NotificationResponse(
      id: arguments[NOTIFICATION_ID],
      actionId: arguments[ACTION_ID],
      input: null,
      payload: arguments[NOTIFICATION_PAYLOAD],
      notificationResponseType: NotificationResponseType.selectedNotification,
    );
  }

  Future<void> _handleMethod(MethodCall call) async {
    if (kDebugMode) {
      print("_handleMethod is working");
    }

    switch (call.method) {
      case 'didReceiveNotificationResponse':
        _onDidReceiveNotificationResponse
            ?.call(_buildNotificationResponse(call.arguments));
        break;
      case 'onTapNotification':
        _onTapNotification?.call(_buildNotificationResponse(call.arguments));
        break;
      case 'onActionTap':
        print("Dart: onActionTap is working");
        break;
      default:
        return await Future<void>.error('Method not defined');
    }
  }
}

/// iOS implementation of the Flutter MQTT plugin.
class IOSFlutterMqttPlugin extends MethodChannelFlutterMqttPlugin {
  DidReceiveNotificationResponseCallback? _ondidReceiveNotificationResponse;
  OnTapNotificationCallback? _onTapNotification;
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
  Map<String, dynamic> arguments,
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
    arguments[RECEIVE_BACKGROUND_NOTIFICATION_CALLBACK_HANDLE] = callback!.toRawHandle();
  }
}
