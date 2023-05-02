// To parse this JSON data, do
//
//     final notificationSettings = notificationSettingsFromJson(jsonString);

import 'dart:convert';

NotificationSettings notificationSettingsFromJson(String str) => NotificationSettings.fromJson(json.decode(str));

String notificationSettingsToJson(NotificationSettings data) => json.encode(data.toJson());

class NotificationSettings {
  AndroidNotificationSetting androidNotificationSetting;

  NotificationSettings({
    required this.androidNotificationSetting,
  });

  factory NotificationSettings.fromJson(Map<String, dynamic> json) => NotificationSettings(
    androidNotificationSetting: AndroidNotificationSetting.fromJson(json["androidNotificationSetting"]),
  );

  Map<String, dynamic> toJson() => {
    "androidNotificationSetting": androidNotificationSetting.toJson(),
  };
}

class AndroidNotificationSetting {
  String channelId;
  String channelName;
  String notificationIcon;

  AndroidNotificationSetting({
    required this.channelId,
    required this.channelName,
    required this.notificationIcon,
  });

  factory AndroidNotificationSetting.fromJson(Map<String, dynamic> json) => AndroidNotificationSetting(
    channelId: json["channelId"],
    channelName: json["channelName"],
    notificationIcon: json["notificationIcon"],
  );

  Map<String, dynamic> toJson() => {
    "channelId": channelId,
    "channelName": channelName,
    "notificationIcon": notificationIcon,
  };
}
