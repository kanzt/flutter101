import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mqtt/flutter_mqtt.dart';

// ignore_for_file: public_member_api_docs, avoid_annotating_with_dynamic
@pragma('vm:entry-point')
void callbackDispatcher() {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  const MethodChannel channel = MethodChannel('th.co.cdgs/flutter_mqtt');

  channel.invokeMethod<int>('getCallbackHandle').then((int? handle) {
    final DidReceiveBackgroundNotificationResponseCallback? callback =
        handle == null
            ? null
            : PluginUtilities.getCallbackFromHandle(
                    CallbackHandle.fromRawHandle(handle))
                as DidReceiveBackgroundNotificationResponseCallback?;

    channel.setMethodCallHandler((call) async {
      switch (call.method) {
        case 'didReceiveNotificationResponse':
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
  });
}
