import 'types.dart';

/// Signature of callback triggered on main isolate when receive a notification (Foreground & Background state)
typedef DidReceiveNotificationResponseCallback = void Function(
    NotificationResponse details);


/// Signature of callback triggered on background isolate when receive a notification (Terminated state)
typedef DidReceiveBackgroundNotificationResponseCallback = void Function(
    NotificationResponse details);


/// Signature of callback triggered on main isolate when a user taps on a notification or a notification action.
typedef OnTapNotificationCallback = void Function(NotificationResponse details);


/// Signature of callback triggered on background isolate when a user taps on a notification action.
typedef OnTapActionBackgroundNotification = void Function(NotificationResponse details);
