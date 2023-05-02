// To parse this JSON data, do
//
//     final notificationSettings = notificationSettingsFromJson(jsonString);

import 'dart:convert';

NotificationSettings notificationSettingsFromJson(String str) =>
    NotificationSettings.fromJson(json.decode(str));

String notificationSettingsToJson(NotificationSettings data) =>
    json.encode(data.toJson());

class NotificationSettings {
  AndroidNotificationSetting androidNotificationSetting;
  IOSNotificationSetting iosNotificationSetting;

  NotificationSettings({
    required this.androidNotificationSetting,
    required this.iosNotificationSetting,
  });

  factory NotificationSettings.fromJson(Map<String, dynamic> json) =>
      NotificationSettings(
        androidNotificationSetting: AndroidNotificationSetting.fromJson(
            json["androidNotificationSetting"]),
        iosNotificationSetting:
            IOSNotificationSetting.fromJson(json["iosNotificationSetting"]),
      );

  Map<String, dynamic> toJson() => {
        "androidNotificationSetting": androidNotificationSetting.toJson(),
        "iosNotificationSetting": iosNotificationSetting.toJson(),
      };
}

class AndroidNotificationSetting {
  String channelId;
  String channelName;
  String notificationIcon;
  String? sound;

  AndroidNotificationSetting({
    required this.channelId,
    required this.channelName,
    required this.notificationIcon,
    this.sound,
  });

  factory AndroidNotificationSetting.fromJson(Map<String, dynamic> json) =>
      AndroidNotificationSetting(
        channelId: json["channelId"],
        channelName: json["channelName"],
        notificationIcon: json["notificationIcon"],
        sound: json["sound"],
      );

  Map<String, dynamic> toJson() => {
        "channelId": channelId,
        "channelName": channelName,
        "notificationIcon": notificationIcon,
        "sound": sound,
      };
}

class IOSNotificationSetting {
  String? sound;

  IOSNotificationSetting({this.sound});

  factory IOSNotificationSetting.fromJson(Map<String, dynamic> json) =>
      IOSNotificationSetting(
        sound: json["sound"],
      );

  Map<String, dynamic> toJson() => {
        "sound": sound,
      };
}
