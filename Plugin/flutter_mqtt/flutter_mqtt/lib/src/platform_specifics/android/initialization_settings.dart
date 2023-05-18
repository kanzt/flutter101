import 'package:flutter_mqtt/src/platform_specifics/android/notification_details.dart';

/// Plugin initialization settings for Android.
class AndroidInitializationSettings {
  /// Constructs an instance of [AndroidInitializationSettings].
  const AndroidInitializationSettings({
    required this.platformNotificationSetting,
    required this.mqttConnectionSetting,
  });

  /// Specifies the default icon for notifications.
  final PlatformNotificationSetting platformNotificationSetting;

  /// MQTT configuration
  final MQTTConnectionSetting mqttConnectionSetting;


  Map<String, dynamic> toMap() => <String, dynamic>{
        'platformNotificationSetting': platformNotificationSetting.toMap(),
        "mqttConnectionSetting": mqttConnectionSetting.toMap(),
      };
}

class MQTTConnectionSetting {
  MQTTConnectionSetting({
    required this.isRequiredSsl,
    required this.hostname,
    required this.password,
    required this.username,
    this.clientId,
    this.topic,
  });

  bool isRequiredSsl;
  String hostname;
  String password;
  String username;
  String? clientId;
  String? topic;

  Map<String, Object> toMap() => <String, Object>{
        'isRequiredSSL': isRequiredSsl,
        "hostname": hostname,
        "password": password,
        "username": username,
        "clientId": clientId ?? "",
        "topic": topic ?? "",
      };
}

class PlatformNotificationSetting {
  const PlatformNotificationSetting({
    required this.notificationIcon,
    required this.channelId,
    required this.channelName,
    this.actions,
  });

  /// Specifies the default icon for notifications.
  final String notificationIcon;

  /// Notification channel
  final String channelId;
  final String channelName;

  /// Notification action
  final List<AndroidNotificationAction>? actions;


  Map<String, dynamic> toMap() => <String, dynamic>{
        'notificationIcon': notificationIcon,
        "channelId": channelId,
        "channelName": channelName,
      }..addAll(_convertActionsToMap(actions));

  Map<String, Object> _convertActionsToMap(
      List<AndroidNotificationAction>? actions) {
    if (actions == null) {
      return <String, Object>{};
    }
    return <String, Object>{
      'actions': actions
          .map(
            (AndroidNotificationAction e) => <String, dynamic>{
          'id': e.id,
          'title': e.title,
          'titleColorAlpha': e.titleColor?.alpha,
          'titleColorRed': e.titleColor?.red,
          'titleColorGreen': e.titleColor?.green,
          'titleColorBlue': e.titleColor?.blue,
          if (e.icon != null) ...<String, Object>{
            'icon': e.icon!.data,
            'iconBitmapSource': e.icon!.source.index,
          },
          'contextual': e.contextual,
          'showsUserInterface': e.showsUserInterface,
          'cancelNotification': e.cancelNotification,
        },
      )
          .toList(),
    };
  }
}
