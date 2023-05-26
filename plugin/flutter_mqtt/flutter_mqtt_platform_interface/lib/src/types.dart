/// Details of a Notification Action that was triggered.
class NotificationResponse {
  /// Constructs an instance of [NotificationResponse]
  const NotificationResponse({
    this.id,
    this.actionId,
    this.payload,
  });

  /// The notification's id.
  ///
  /// This is nullable as support for this only supported for notifications
  /// created using version 10 or newer of this plugin.
  final int? id;

  /// The id of the action that was triggered.
  final String? actionId;

  /// The notification's payload.
  final String? payload;

}

/// Contains details on the notification that launched the application.
class NotificationAppLaunchDetails {
  /// Constructs an instance of [NotificationAppLaunchDetails].
  const NotificationAppLaunchDetails(
    this.didNotificationLaunchApp, {
    this.notificationResponse,
  });

  /// Indicates if the app was launched via notification.
  final bool didNotificationLaunchApp;

  /// Contains details of the notification that launched the app.
  final NotificationResponse? notificationResponse;
}
