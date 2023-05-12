import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mqtt/flutter_mqtt.dart';

// ignore_for_file: public_member_api_docs, avoid_annotating_with_dynamic
@pragma('vm:entry-point')
void callbackDispatcher() async {
  print("callbackDispatcher is working...");
  WidgetsFlutterBinding.ensureInitialized();

  const MethodChannel workerChannel = MethodChannel(WORKER_METHOD_CHANNEL);

  final handle = await workerChannel.invokeMethod<int>('getCallbackHandle');
  final DidReceiveBackgroundNotificationResponseCallback? callback =
      handle == null
          ? null
          : PluginUtilities.getCallbackFromHandle(
                  CallbackHandle.fromRawHandle(handle))
              as DidReceiveBackgroundNotificationResponseCallback?;

  workerChannel.setMethodCallHandler((call) async {
    print("workerChannel.setMethodCallHandler is working...");
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

  workerChannel.invokeMethod("backgroundChannelInitialized");
}
