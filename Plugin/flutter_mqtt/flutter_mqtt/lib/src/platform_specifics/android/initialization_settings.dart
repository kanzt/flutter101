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

  Map<String, Object> toMap() => <String, Object>{
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

  factory MQTTConnectionSetting.fromJson(Map<String, dynamic> json) =>
      MQTTConnectionSetting(
        isRequiredSsl: json["isRequiredSSL"],
        hostname: json["hostname"],
        password: json["password"],
        username: json["username"],
        clientId: json["clientId"],
        topic: json["topic"],
      );

  Map<String, dynamic> toJson() => {
        "isRequiredSSL": isRequiredSsl,
        "hostname": hostname,
        "password": password,
        "username": username,
        "clientId": clientId,
        "topic": topic,
      };

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
  });

  /// Specifies the default icon for notifications.
  final String notificationIcon;

  /// Notification channel
  final String channelId;
  final String channelName;

  factory PlatformNotificationSetting.fromJson(Map<String, dynamic> json) =>
      PlatformNotificationSetting(
        notificationIcon: json["notificationIcon"],
        channelId: json["channelId"],
        channelName: json["channelName"],
      );

  Map<String, dynamic> toJson() => {
        "notificationIcon": notificationIcon,
        "channelId": channelId,
        "channelName": channelName,
      };

  Map<String, Object> toMap() => <String, Object>{
        'notificationIcon': notificationIcon,
        "channelId": channelId,
        "channelName": channelName,
      };
}
