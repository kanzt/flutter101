import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mqtt/flutter_mqtt.dart';

// ignore_for_file: public_member_api_docs, avoid_annotating_with_dynamic
@pragma('vm:entry-point')
void callbackDispatcher() async {
  print("callbackDispatcher is working...");
  WidgetsFlutterBinding.ensureInitialized();

  const MethodChannel workerChannel = MethodChannel(WORKER_METHOD_CHANNEL);

  final handle = await workerChannel.invokeMethod<int>('getReceiveBackgroundNotificationCallbackHandle');
  final DidReceiveBackgroundNotificationResponseCallback? callback =
  handle == null
      ? null
      : PluginUtilities.getCallbackFromHandle(
      CallbackHandle.fromRawHandle(handle))
  as DidReceiveBackgroundNotificationResponseCallback?;

  try {

    /// Handle receive notification in terminated state
    workerChannel.setMethodCallHandler((call) async {
      print("workerChannel.setMethodCallHandler is working...");
      switch (call.method) {
        case 'didReceiveNotificationResponse':
          // TODO : แก้ไข Notification Response
          callback?.call(
            NotificationResponse(
              id: null,
              actionId: null,
              input: null,
              payload: call.arguments['payload'],
              notificationResponseType:
                  NotificationResponseType.selectedNotificationAction,
            ),
          );
          break;
        default:
          return await Future<void>.error('Method not defined');
      }
    });

    // TODO : 25/05/2023 ไม่ได้ใช้งานเตรียมลบออก
    /// EventChannel for action buttons on notification
    const EventChannel actionEvent = EventChannel(ACTION_EVENT_CHANNEL);
    /// Handle notification actions
    actionEvent
        .receiveBroadcastStream()
        .map<Map<dynamic, dynamic>>((dynamic event) => event)
        .map<Map<String, dynamic>>(
            (Map<dynamic, dynamic> event) => Map.castFrom(event))
        .listen((Map<String, dynamic> event) {

      // TODO : แก้ไข Notification Response
      callback?.call(
        NotificationResponse(
          id: event['notificationId'],
          actionId: event['actionId'],
          payload: event['payload'],
          notificationResponseType:
          NotificationResponseType.selectedNotificationAction,
        ),
      );
    });

    workerChannel.invokeMethod("backgroundChannelInitialized");

  } on MissingPluginException catch (e) {
    if (kDebugMode) {
      print(e.message);
    }
  }
}
