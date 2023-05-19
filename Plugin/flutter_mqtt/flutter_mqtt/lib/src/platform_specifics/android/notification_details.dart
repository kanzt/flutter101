import 'dart:ui';

import 'package:flutter_mqtt/src/platform_specifics/android/bitmap.dart';


/// Mirrors the `Action` class in AndroidX.
///
/// See the offical docs at
/// https://developer.android.com/reference/kotlin/androidx/core/app/NotificationCompat.Action?hl=en
/// for details.
class AndroidNotificationAction {
  /// Constructs a [AndroidNotificationAction] object. The platform will create
  /// this object using `Action.Builder`. See the offical docs
  /// https://developer.android.com/reference/kotlin/androidx/core/app/NotificationCompat.Action.Builder?hl=en
  /// for details.
  const AndroidNotificationAction(
    this.id,
    this.title, {
    this.titleColor,
    this.icon,
    this.contextual = false,
    this.showsUserInterface = false,
    this.cancelNotification = true,
  });

  /// This ID will be sent back in the action handler defined in
  /// [FlutterLocalNotificationsPlugin].
  final String id;

  /// The title of the action
  final String title;

  /// The color of the title of the action
  final Color? titleColor;

  /// Icon to show for this action.
  final AndroidBitmap<Object>? icon;

  /// Sets whether this Action is a contextual action, i.e. whether the action
  /// is dependent on the notification message body. An example of a contextual
  /// action could be an action opening a map application with an address shown
  /// in the notification.
  final bool contextual;

  /// Set whether or not this Action's PendingIntent will open a user interface.
  final bool showsUserInterface;

  /// By default, Android plugin will dismiss the notification when the
  /// user tapped on a action (this mimics the behavior on iOS).
  /// Set whether the notification should be canceled when this action is
  /// selected.
  final bool cancelNotification;
}
