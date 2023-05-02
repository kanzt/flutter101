
import 'package:flutter_mqtt_plugin/src/entity/connection_setting.dart';
import 'package:flutter_mqtt_plugin/src/entity/notification_category.dart';
import 'package:flutter_mqtt_plugin/src/entity/typedefs.dart';


class InitializationSettings {
  const InitializationSettings({
    this.android,
    this.iOS,
  });

  /// Settings for Android.
  ///
  /// It is nullable, because we don't want to force users to specify settings
  /// for platforms that they don't target.
  final AndroidInitializationSettings? android;

  /// Settings for iOS.
  ///
  /// It is nullable, because we don't want to force users to specify settings
  /// for platforms that they don't target.
  final DarwinInitializationSettings? iOS;
}

/// Plugin initialization settings for Android.
class AndroidInitializationSettings {
  /// Constructs an instance of [AndroidInitializationSettings].
  AndroidInitializationSettings({
    required this.connectionSetting,
    required this.defaultIcon,
    required this.channelId,
    required this.channelName,
  });

  /// Specifies the default icon for notifications.
  final ConnectionSetting connectionSetting;
  final String defaultIcon;
  final String channelId;
  final String channelName;
}

/// Plugin initialization settings for Darwin-based operating systems
/// such as iOS and macOS
class DarwinInitializationSettings {
  /// Constructs an instance of [DarwinInitializationSettings].
  const DarwinInitializationSettings({
    this.requestAlertPermission = true,
    this.requestSoundPermission = true,
    this.requestBadgePermission = true,
    this.requestCriticalPermission = false,
    this.defaultPresentAlert = true,
    this.defaultPresentSound = true,
    this.defaultPresentBadge = true,
    this.onDidReceiveLocalNotification,
    this.notificationCategories = const <DarwinNotificationCategory>[],
  });

  /// Request permission to display an alert.
  ///
  /// Default value is true.
  final bool requestAlertPermission;

  /// Request permission to play a sound.
  ///
  /// Default value is true.
  final bool requestSoundPermission;

  /// Request permission to badge app icon.
  ///
  /// Default value is true.
  final bool requestBadgePermission;

  /// Request permission to show critical notifications.
  ///
  /// Subject to specific approval from Apple:
  /// https://developer.apple.com/contact/request/notifications-critical-alerts-entitlement/
  ///
  /// Default value is 'false'.
  final bool requestCriticalPermission;

  /// Configures the default setting on if an alert should be displayed when a
  /// notification is triggered while app is in the foreground.
  ///
  /// Default value is true.
  ///
  /// On iOS, this property is only applicable to iOS 10 or newer.
  /// On macOS, this property is only applicable to macOS 10.14 or newer.

  final bool defaultPresentAlert;

  /// Configures the default setting on if a sound should be played when a
  /// notification is triggered while app is in the foreground by default.
  ///
  /// Default value is true.
  ///
  /// On iOS, this property is only applicable to iOS 10 or newer.
  /// On macOS, this property is only applicable to macOS 10.14 or newer.
  final bool defaultPresentSound;

  /// Configures the default setting on if a badge value should be applied when
  /// a notification is triggered while app is in the foreground by default.
  ///
  /// Default value is true.
  ///
  /// On iOS, this property is only applicable to iOS 10 or newer.
  /// On macOS, this property is only applicable to macOS 10.14 or newer.
  final bool defaultPresentBadge;

  /// Callback for handling when a notification is triggered while the app is
  /// in the foreground.
  ///
  /// This property is only applicable to iOS versions older than 10.
  final DidReceiveLocalNotificationCallback? onDidReceiveLocalNotification;

  /// Configure the notification categories ([DarwinNotificationCategory])
  /// available. This allows for fine-tuning of preview display.
  ///
  /// IMPORTANT: A change to the category actions will either require a full app
  /// uninstall / reinstall or a change to the category identifier. This is
  /// because iOS/macOS configures the categories once per App launch and considers
  /// them immutable while the App is installed.
  ///
  /// Notification actions are configured in each [DarwinNotificationCategory].
  ///
  /// On iOS, this is only applicable to iOS 10 or newer.
  /// On macOS, this is only applicable to macOS 10.14 or newer.
  final List<DarwinNotificationCategory> notificationCategories;
}
