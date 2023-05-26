import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mqtt/flutter_mqtt.dart';
import 'package:flutter_mqtt/src/callback_dispatcher.dart';
import 'package:flutter_mqtt_plugin_platform_interface/flutter_mqtt_platform_interface.dart';

/// Arguments
const ARG_NOTIFICATION_PAYLOAD = "payload";
const ARG_NOTIFICATION_ID = "notificationId";
const ARG_ACTION_ID = "actionId";
const ARG_DISPATCHER_HANDLE = "dispatcher_handle";
const ARG_RECEIVE_BACKGROUND_NOTIFICATION_CALLBACK_HANDLE =
    "receive_background_notification_callback_handle";
const ARG_TAP_ACTTION_BACKGROUND_NOTIFICATION_CALLBACK_HANDLE =
    "tap_action_background_notification_callback_handle";
const ARG_NOTIFICATION_RESPONSE_TYPE = "notificationResponseType";
const ARG_NOTIFICATION_RESPONSE = "notificationResponse";
const ARG_NOTIFICATION_LAUNCH_APP = "notificationLaunchedApp";

/// MethodChannel & EventChannel
const METHOD_CHANNEL = "th.co.cdgs/flutter_mqtt";
const BACKGROUND_METHOD_CHANNEL = "th.co.cdgs/flutter_mqtt/background";
const MethodChannel _channel = MethodChannel(METHOD_CHANNEL);

/// Possible method
const METHOD_INITIALIZE = "initialize";
const METHOD_CANCEL_ALL = "cancelAll";
const METHOD_GET_NOTIFICATION_APP_LAUNCH_DETAILS =
    "getNotificationAppLaunchDetails";
const METHOD_DID_RECEIVE_NOTIFICATION_RESPONSE =
    "didReceiveNotificationResponse";
const METHOD_ON_TAP_NOTIFICATION = "onTapNotification";
const METHOD_GET_RECEIVE_BACKGROUND_NOTIFICATION_CALLBACK_HANDLE = "getReceiveBackgroundNotificationCallbackHandle";
const METHOD_GET_TAP_ACTION_BACKGROUND_NOTIFICATION_CALLBACK_HANDLE = "getTapActionBackgroundNotificationCallbackHandle";
const METHOD_BACKGROUND_CHANNEL_INITIALIZED = "backgroundChannelInitialized";

NotificationResponse buildNotificationResponse(dynamic arguments) {
  return NotificationResponse(
    id: arguments[ARG_NOTIFICATION_ID],
    actionId: arguments[ARG_ACTION_ID],
    payload: arguments[ARG_NOTIFICATION_PAYLOAD],
  );
}

/// An implementation of a local notifications platform using method channels.
class MethodChannelFlutterMqttPlugin extends FlutterMqttPlatform {
  @override
  Future<void> cancelAll() => _channel.invokeMethod(METHOD_CANCEL_ALL);

  @override
  Future<NotificationAppLaunchDetails?>
      getNotificationAppLaunchDetails() async {
    final Map<dynamic, dynamic>? result =
        await _channel.invokeMethod(METHOD_GET_NOTIFICATION_APP_LAUNCH_DETAILS);
    final Map<dynamic, dynamic>? notificationResponse =
        result != null && result.containsKey(ARG_NOTIFICATION_RESPONSE)
            ? result[ARG_NOTIFICATION_RESPONSE]
            : null;
    return result != null
        ? NotificationAppLaunchDetails(
            result[ARG_NOTIFICATION_LAUNCH_APP],
            notificationResponse: notificationResponse == null
                ? null
                : buildNotificationResponse(notificationResponse),
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
  /// The [onTapActionBackgroundNotification] is fired when user tap on notification action in Terminated state and set AndroidNotificationAction.showsUserInterface = false, callback need to be annotated with the `@pragma('vm:entry-point')`
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
    OnTapActionBackgroundNotification? onTapActionBackgroundNotification,
  }) async {
    _onDidReceiveNotificationResponse = onDidReceiveNotificationResponse;
    _onTapNotification = onTapNotification;

    _channel.setMethodCallHandler(_handleMethod);

    final Map<String, dynamic> arguments = initializationSettings.toMap();

    _evaluateBackgroundNotificationCallback(
        onDidReceiveBackgroundNotificationResponse, arguments);

    _evaluateBackgroundTapActionCallback(
        onTapActionBackgroundNotification, arguments);

    return await _channel.invokeMethod(METHOD_INITIALIZE, arguments);
  }

  Future<void> _handleMethod(MethodCall call) async {
    if (kDebugMode) {
      print("_handleMethod is working");
    }

    switch (call.method) {
      case METHOD_DID_RECEIVE_NOTIFICATION_RESPONSE:
        _onDidReceiveNotificationResponse
            ?.call(buildNotificationResponse(call.arguments));
        break;
      case METHOD_ON_TAP_NOTIFICATION:
        _onTapNotification?.call(buildNotificationResponse(call.arguments));
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
/// This will add a `dispatcher_handle` and `receive_background_notification_callback_handle` argument to the
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

    arguments[ARG_DISPATCHER_HANDLE] = dispatcher!.toRawHandle();
    arguments[ARG_RECEIVE_BACKGROUND_NOTIFICATION_CALLBACK_HANDLE] =
        callback!.toRawHandle();
  }
}

/// Checks [onTapActionBackgroundNotification], if not `null`,
/// for eligibility to be used as a background callback.
///
/// If the method is `null`, no further action will be taken.
///
/// This will add a `dispatcher_handle` and `tap_action_background_notification_callback_handle` argument to the
/// [arguments] map when the config is correct.
void _evaluateBackgroundTapActionCallback(
  OnTapActionBackgroundNotification? onTapActionBackgroundNotification,
  Map<String, dynamic> arguments,
) {
  if (onTapActionBackgroundNotification != null) {
    final CallbackHandle? callback =
        PluginUtilities.getCallbackHandle(onTapActionBackgroundNotification);
    assert(callback != null, '''
          The backgroundHandler needs to be either a static function or a top 
          level function to be accessible as a Flutter entry point.''');

    final CallbackHandle? dispatcher =
        PluginUtilities.getCallbackHandle(callbackDispatcher);

    arguments[ARG_DISPATCHER_HANDLE] = dispatcher!.toRawHandle();
    arguments[ARG_TAP_ACTTION_BACKGROUND_NOTIFICATION_CALLBACK_HANDLE] =
        callback!.toRawHandle();
  }
}
