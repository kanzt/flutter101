import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_starter/src/util/log/log_main.dart';
import 'package:flutter_starter/src/util/shared_preferences/shared_preferences.dart';

/// There are a few things to keep in mind about your background message handler:
/// 1. It must not be an anonymous function.
/// 2. It must be a top-level function (e.g. not a class method which requires initialization).
// @pragma('vm:entry-point')
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   if (kDebugMode) {
//     print("Background message: ${message.notification!.body}");
//   }
// }

/// Class นี้สำหรับดูตัวอย่างการใช้งาน API ของ firebase_messaging เท่านั้น
// class FCMServiceDoc {
//   static Future<void> init() async {
//     /// สำหรับ iOS และ Web จะต้องขอสิทธิ์การส่งแจ้งเตือนก่อน
//     if (GetPlatform.isIOS || GetPlatform.isMacOS || GetPlatform.isWeb) {
//       NotificationSettings settings =
//           await FirebaseMessaging.instance.requestPermission(
//         alert: true,
//         announcement: false,
//         badge: true,
//         carPlay: false,
//         criticalAlert: false,
//         provisional: false,
//         sound: true,
//       );
//     }
//
//     /// FCM Token
//     FirebaseMessaging.instance.getToken().then((value) {
//       if (kDebugMode) {
//         print("token : $value");
//       }
//     });
//
//     /// จัดการ FCM เมื่อแอปทำงานอยู่ใน Foreground
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       if (kDebugMode) {
//         print("message recieved");
//         print('Foreground message ${message.notification!.body}');
//       }
//     });
//
//     /// จัดการ FCM เมื่อกดที่ Notification บน Status bar
//     FirebaseMessaging.onMessageOpenedApp.listen((message) {
//       if (kDebugMode) {
//         print('Message clicked!');
//       }
//     });
//
//     /// จัดการ FCM เมื่อแอปทำงานอยู่ใน Background
//     FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//   }
// }

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  Log.i("Received Background message (Background State)");
  PushNotificationService.updateAppBader(message);
}

// ignore: slash_for_doc_comments
/**
 * Documents added by Alaa, enjoy ^-^:
 * There are 3 major things to consider when dealing with push notification :
 * - Creating the notification
 * - Hanldle notification click
 * - App status (foreground/background and killed(Terminated))
 *
 * Creating the notification:
 *
 * - When the app is killed or in background state, creating the notification is handled through the back-end services.
 *   When the app is in the foreground, we have full control of the notification. so in this case we build the notification from scratch.
 *
 * Handle notification click:
 *
 * - When the app is killed, there is a function called getInitialMessage which
 *   returns the remoteMessage in case we receive a notification otherwise returns null.
 *   It can be called at any point of the application (Preferred to be after defining GetMaterialApp so that we can go to any screen without getting any errors)
 * - When the app is in the background, there is a function called onMessageOpenedApp which is called when user clicks on the notification.
 *   It returns the remoteMessage.
 * - When the app is in the foreground, there is a function flutterLocalNotificationsPlugin, is passes a future function called onSelectNotification which
 *   is called when user clicks on the notification.
 *
 * */
class PushNotificationService {
  // It is assumed that all messages contain a data field with the key 'type'
  Future<void> setupInteractedMessage() async {
    // We need to initialize Firebase before using it
    // await Firebase.initializeApp();

    if (Platform.isIOS) {
      NotificationSettings _ =
          await FirebaseMessaging.instance.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
    }

    // Get any messages which caused the application to open from a terminated state.
    // If you want to handle a notification click when the app is terminated, you can use `getInitialMessage`
    // to get the initial message, and depending in the remoteMessage, you can decide to handle the click
    // This function can be called from anywhere in your app, there is an example in main file.
    // TODO : Do stuff with Background notification click (Terminated state)
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    // If the message also contains a data property then update Badger
    if (initialMessage != null) {
      Log.i("Received Background message (Terminated State)");
      updateAppBader(initialMessage);
    }

    // TODO : View FCM Token
    await FirebaseMessaging.instance.getToken().then((value) {
        Log.i("token : $value");
        print("token : $value");
        SharedPreference.write(
          SharedPreference.KEY_FCM_TOKEN,
          value,
        );
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    // Also handle any interaction when the app is in the background via a
    // Stream listener
    // This function is called when the app is in the background and user clicks on the notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? message) {
      // TODO : Do stuff with Background notification click (Background state)
      Log.i("Background message clicked");
    });
    await enableIOSNotifications();
    await registerNotificationListeners();
  }

  Future<void> registerNotificationListeners() async {
    AndroidNotificationChannel channel = androidNotificationChannel();
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    var androidSettings =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOSSettings = const DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );

    RemoteMessage? recentMessage;

    // TODO : Do stuff with Foreground notification received (Foreground state)
    // onMessage is called when the app is in foreground and a notification is received
    FirebaseMessaging.onMessage.listen((RemoteMessage? message) {
      recentMessage = message;
      Log.i("Received Foreground message");
      _showNotification(
          flutterLocalNotificationsPlugin, channel, recentMessage);
    });

    RemoteMessage? initialMessage = await getInitialMessage();
    if (initialMessage != null) {
      // TODO : Do stuff with Background notification received (Terminated state)
      // App received a notification when it was killed
      // If initialMessage != null , construct our own
      // local notification to show to users using the created channel.
      _showNotification(
          flutterLocalNotificationsPlugin, channel, initialMessage);
    }

    var initSettings =
        InitializationSettings(android: androidSettings, iOS: iOSSettings);
    await flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (message) async {
        // TODO : Do stuff with Foreground notification click (Foreground state)
        // TODO : ข้อสังเกตจากการทดสอบเองคือใน iOS ไม่ว่าจะเป็นการทำงาน Background / Foreground จะไม่เข้าฟังก์ชันนี้แต่จะเข้า FirebaseMessaging.onMessageOpenedApp แทน | ใน Android ทำงานปกติ
        // This function handles the click in the notification when the app is in foreground
        // if(recentMessage != null){
        //   recentMessage!.data['type'] = "setting";
        // }
        Log.i("Foreground message clicked");
      },
    );
  }

  void _showNotification(
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
    AndroidNotificationChannel channel,
    RemoteMessage? message,
  ) {
    updateAppBader(message);

    RemoteNotification? notification = message!.notification;
    AndroidNotification? android = message.notification?.android;

    // If `onMessage` is triggered with a notification, construct our own
    // local notification to show to users using the created channel.
    if (notification != null && android != null) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            icon: android.smallIcon,
            playSound: true,
          ),
        ),
      );
    }
  }

  /// In iOS, macOS and Web need these permissions
  Future<void> enableIOSNotifications() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );
  }

  AndroidNotificationChannel androidNotificationChannel() =>
      const AndroidNotificationChannel(
        'iflowsoft_notification__channel', // id
        'iFlowSoft Notifications', // title
        description:
            'This channel is used for important iFlowSoft notifications.',
        // description
        importance: Importance.high,
      );

  static void updateAppBader(RemoteMessage? message) {
    if (message != null) {
      try {
        final String? notificationCount = message.data['count'];
        Log.i(notificationCount);
        if (notificationCount != null) {
          FlutterAppBadger.updateBadgeCount(int.parse(notificationCount));
        }
      } on Error catch (_, e) {
        Log.e(e.toString());
      }
    }
  }

  static Future<RemoteMessage?> getInitialMessage() {
    return FirebaseMessaging.instance.getInitialMessage();
  }
}
