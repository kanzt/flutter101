import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mqtt_plugin_platform_interface/flutter_mqtt_platform_interface.dart';

/// ใช้เป็นตัวเรียก Callback
/// TODO : รอดูว่าจะใช้หรือจะลบออก
// ignore_for_file: public_member_api_docs, avoid_annotating_with_dynamic
@pragma('vm:entry-point')
void callbackDispatcher() {
  WidgetsFlutterBinding.ensureInitialized();

  const EventChannel backgroundChannel =
      EventChannel('dexterous.com/flutter/local_notifications/actions');

  const MethodChannel channel =
      MethodChannel('dexterous.com/flutter/local_notifications');

  channel.invokeMethod<int>('getCallbackHandle').then((int? handle) {
    final DidReceiveBackgroundNotificationResponseCallback? callback =
        handle == null
            ? null
            : PluginUtilities.getCallbackFromHandle(
                    CallbackHandle.fromRawHandle(handle))
                as DidReceiveBackgroundNotificationResponseCallback?;

    backgroundChannel
        .receiveBroadcastStream()
        .map<Map<dynamic, dynamic>>((dynamic event) => event)
        .map<Map<String, dynamic>>(
            (Map<dynamic, dynamic> event) => Map.castFrom(event))
        .listen((Map<String, dynamic> event) {
      final Object notificationId = event['notificationId'];
      final int id;
      if (notificationId is int) {
        id = notificationId;
      } else if (notificationId is String) {
        id = int.parse(notificationId);
      } else {
        id = -1;
      }
      callback?.call(NotificationResponse(
        id: id,
        actionId: event['actionId'],
        input: event['input'],
        payload: event['payload'],
        notificationResponseType:
            NotificationResponseType.selectedNotificationAction,
      ));
    });
  });
}
