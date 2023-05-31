import '../../typedefs.dart';
import 'notification_category.dart';

// TODO : ปรับแต่งเป็นรูปแบบที่ต้องการ
/// Plugin initialization settings for Darwin-based operating systems
/// such as iOS and macOS
class DarwinInitializationSettings {
  /// Constructs an instance of [DarwinInitializationSettings].
  const DarwinInitializationSettings({
    this.requestAlertPermission = true,
    this.requestSoundPermission = true,
    this.requestBadgePermission = true,
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

  Map<String, Object> toMap() => <String, Object>{
    'requestAlertPermission': requestAlertPermission,
    'requestSoundPermission': requestSoundPermission,
    'requestBadgePermission': requestBadgePermission,
    'notificationCategories': notificationCategories
        .map((e) => e.toMap()) // ignore: always_specify_types
        .toList(),
  };
}
