import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mqtt/flutter_mqtt.dart';
import 'package:flutter_mqtt_plugin_platform_interface/flutter_mqtt_platform_interface.dart';

// ignore_for_file: public_member_api_docs, avoid_annotating_with_dynamic
@pragma('vm:entry-point')
void callbackDispatcher() async {
  if (kDebugMode) {
    print("callbackDispatcher is working...");
  }

  WidgetsFlutterBinding.ensureInitialized();

  const MethodChannel workerChannel = MethodChannel(WORKER_METHOD_CHANNEL);

  final handleReceiveBackgroundNotification = await workerChannel
      .invokeMethod<int>('getReceiveBackgroundNotificationCallbackHandle');
  final DidReceiveBackgroundNotificationResponseCallback?
      receiveBackgroundNotificationCallback =
      handleReceiveBackgroundNotification == null
          ? null
          : PluginUtilities.getCallbackFromHandle(CallbackHandle.fromRawHandle(
                  handleReceiveBackgroundNotification))
              as DidReceiveBackgroundNotificationResponseCallback?;

  final handleTapActionBackgroundNotification = await workerChannel
      .invokeMethod<int>('getTapActionBackgroundNotificationCallbackHandle');
  final OnTapNotificationCallback? tapActionBackgroundNotificationCallback =
      handleTapActionBackgroundNotification == null
          ? null
          : PluginUtilities.getCallbackFromHandle(CallbackHandle.fromRawHandle(
                  handleTapActionBackgroundNotification))
              as OnTapNotificationCallback?;

  try {
    /// Handle receive notification in terminated state
    workerChannel.setMethodCallHandler((call) async {
      print("workerChannel.setMethodCallHandler is working...");
      switch (call.method) {
        case 'didReceiveNotificationResponse':
          receiveBackgroundNotificationCallback?.call(
            buildNotificationResponse(call.arguments),
          );
          break;
      /// Handle tap notification action in terminated state
        case 'onTapNotification':
          tapActionBackgroundNotificationCallback?.call(
            buildNotificationResponse(call.arguments),
          );
          break;
        default:
          return await Future<void>.error('Method not defined');
      }
    });

    workerChannel.invokeMethod("backgroundChannelInitialized");

  } on MissingPluginException catch (e) {
    if (kDebugMode) {
      print("callback_dispatcher : Error");
      print(e.message);
    }
  }
}
