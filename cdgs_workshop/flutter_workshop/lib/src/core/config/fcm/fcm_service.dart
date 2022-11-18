import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_workshop/src/core/config/route/routes.dart';
import 'package:get/get.dart';

/// There are a few things to keep in mind about your background message handler:
/// 1. It must not be an anonymous function.
/// 2. It must be a top-level function (e.g. not a class method which requires initialization).
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (kDebugMode) {
    print("Background message: ${message.notification!.body}");
  }
}

/// Class นี้สำหรับดูตัวอย่างการใช้งาน API ของ firebase_messaging เท่านั้น
class FCMServiceDoc {
  static init() async {
    /// สำหรับ iOS และ Web จะต้องขอสิทธิ์การส่งแจ้งเตือนก่อน
    if (GetPlatform.isIOS || GetPlatform.isMacOS || GetPlatform.isWeb) {
      NotificationSettings settings =
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

    /// FCM Token
    FirebaseMessaging.instance.getToken().then((value) {
      if (kDebugMode) {
        print("token : $value");
      }
    });

    /// จัดการ FCM เมื่อแอปทำงานอยู่ใน Foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (kDebugMode) {
        print("message recieved");
        print('Foreground message ${message.notification!.body}');
      }
    });

    /// จัดการ FCM เมื่อกดที่ Notification บน Status bar
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      if (kDebugMode) {
        print('Message clicked!');
      }
    });

    /// จัดการ FCM เมื่อแอปทำงานอยู่ใน Background
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }
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

    // Get any messages which caused the application to open from a terminated state.
    // If you want to handle a notification click when the app is terminated, you can use `getInitialMessage`
    // to get the initial message, and depending in the remoteMessage, you can decide to handle the click
    // This function can be called from anywhere in your app, there is an example in main file.
    // TODO : Do stuff with Background notification click (Terminated state)
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if(initialMessage != null){
      initialMessage.data['type'] = "nearbyStore";
    }
    _onNotificationClicked(initialMessage);

    // TODO : View FCM Token
    FirebaseMessaging.instance.getToken().then((value) {
      if (kDebugMode) {
        print("token : $value");
      }
    });

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    // This function is called when the app is in the background and user clicks on the notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // TODO : Do stuff with Background notification click (Background state)
      if(message != null){
        message.data['type'] = "cart";
      }
      _onNotificationClicked(message);
    });
    await enableIOSNotifications();
    await registerNotificationListeners();
  }

  registerNotificationListeners() async {
    AndroidNotificationChannel channel = androidNotificationChannel();
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    var androidSettings =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOSSettings = const IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );

    RemoteMessage? recentMessage;

    // TODO : Do stuff with Foreground notification received (Foreground state)
    // onMessage is called when the app is in foreground and a notification is received
    FirebaseMessaging.onMessage.listen((RemoteMessage? message) {
      recentMessage = message;
      _showNotification(
          flutterLocalNotificationsPlugin, channel, recentMessage);
    });

    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
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
    flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onSelectNotification: (message) async {
        // TODO : Do stuff with Foreground notification click (Foreground state)
        // TODO : ข้อสังเกตจากการทดสอบเองคือใน iOS ไม่ว่าจะเป็นการทำงาน Background / Foreground จะไม่เข้าฟังก์ชันนี้แต่จะเข้า FirebaseMessaging.onMessageOpenedApp แทน | ใน Android ทำงานปกติ
        // This function handles the click in the notification when the app is in foreground
        if(recentMessage != null){
          recentMessage!.data['type'] = "setting";
        }
        _onNotificationClicked(recentMessage);
      },
    );
  }

  _onNotificationClicked(RemoteMessage? message) {
    if(message != null){
      switch( message.data['type']) {
        case 'nearbyStore': {
          Get.toNamed(Routes.nearbyStorePage);
        }
        break;
        case 'cart': {
          Get.toNamed(Routes.shoppingCartPage);
        }
        break;
        case 'setting': {
          Get.toNamed(Routes.settingPage);
        }
        break;
      }
    }
  }

  _showNotification(
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
    AndroidNotificationChannel channel,
    RemoteMessage? message,
  ) {
    // Get.find<HomeController>().getNotificationsNumber();
    if (kDebugMode) {
      print(message);
    }
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
  enableIOSNotifications() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );
  }

  androidNotificationChannel() => const AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        description: 'This channel is used for important notifications.',
        // description
        importance: Importance.max,
      );
}
