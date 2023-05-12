import 'types.dart';

// TODO : แก้ไข Comment และชื่อ typedef
/// Signature of callback triggered on main isolate when a user taps on a
/// notification or a notification action.
typedef DidReceiveNotificationResponseCallback = void Function(
    NotificationResponse details);

// TODO : แก้ไข Comment และชื่อ typedef
/// Signature of callback triggered on background isolate when a user taps on a
/// notification or a notification action.
typedef DidReceiveBackgroundNotificationResponseCallback = void Function(
    NotificationResponse details);


/// Signature of callback triggered on main and background isolate when a user taps on a notification
typedef OnOpenedNotificationCallback = void Function(NotificationResponse details);
