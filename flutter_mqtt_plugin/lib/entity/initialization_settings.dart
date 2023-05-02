
import 'dart:convert';

import 'package:flutter_mqtt_plugin/entity/connection_setting.dart';
import 'package:flutter_mqtt_plugin/entity/notification_settings.dart';

InitializationSettings initializationSettingsFromJson(String str) => InitializationSettings.fromJson(json.decode(str));

String initializationSettingsToJson(InitializationSettings data) => json.encode(data.toJson());


class InitializationSettings {
  const InitializationSettings({
    required this.connectionSetting,
    required this.notificationSettings,
  });

  final ConnectionSetting connectionSetting;

  final NotificationSettings notificationSettings;

  factory InitializationSettings.fromJson(Map<String, dynamic> json) => InitializationSettings(
    connectionSetting: ConnectionSetting.fromJson(json["connectionSetting"]),
    notificationSettings: NotificationSettings.fromJson(json["notificationSettings"]),
  );

  Map<String, dynamic> toJson() => {
    "connectionSetting": connectionSetting.toJson(),
    "notificationSettings": notificationSettings.toJson(),
  };
}
