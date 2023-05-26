import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mqtt/flutter_mqtt.dart';

// ignore_for_file: public_member_api_docs, avoid_annotating_with_dynamic
@pragma('vm:entry-point')
void callbackDispatcher() async {
  if (kDebugMode) {
    print("callbackDispatcher is working...");
  }
  WidgetsFlutterBinding.ensureInitialized();

  const MethodChannel workerChannel = MethodChannel(BACKGROUND_METHOD_CHANNEL);

  final handleReceiveBackgroundNotification =
      await workerChannel.invokeMethod<int>(
          METHOD_GET_RECEIVE_BACKGROUND_NOTIFICATION_CALLBACK_HANDLE);
  final DidReceiveBackgroundNotificationResponseCallback?
      receiveBackgroundNotificationCallback =
      handleReceiveBackgroundNotification == null
          ? null
          : PluginUtilities.getCallbackFromHandle(CallbackHandle.fromRawHandle(
                  handleReceiveBackgroundNotification))
              as DidReceiveBackgroundNotificationResponseCallback?;

  final handleTapActionBackgroundNotification =
      await workerChannel.invokeMethod<int>(
          METHOD_GET_TAP_ACTION_BACKGROUND_NOTIFICATION_CALLBACK_HANDLE);
  final OnTapNotificationCallback? tapActionBackgroundNotificationCallback =
      handleTapActionBackgroundNotification == null
          ? null
          : PluginUtilities.getCallbackFromHandle(CallbackHandle.fromRawHandle(
                  handleTapActionBackgroundNotification))
              as OnTapNotificationCallback?;

  try {
    workerChannel.setMethodCallHandler((call) async {
      if (kDebugMode) {
        print("workerChannel.setMethodCallHandler is working...");
      }
      switch (call.method) {
        /// Handle receive notification in terminated state
        case METHOD_DID_RECEIVE_NOTIFICATION_RESPONSE:
          receiveBackgroundNotificationCallback?.call(
            buildNotificationResponse(call.arguments),
          );
          break;

        /// Handle tap notification action in terminated state
        case METHOD_ON_TAP_NOTIFICATION:
          tapActionBackgroundNotificationCallback?.call(
            buildNotificationResponse(call.arguments),
          );
          break;
        default:
          return await Future<void>.error('Method not defined');
      }
    });

    workerChannel.invokeMethod(METHOD_BACKGROUND_CHANNEL_INITIALIZED);
  } on MissingPluginException catch (e) {
    if (kDebugMode) {
      print("callback_dispatcher : Error");
      print(e.message);
    }
  }
}
