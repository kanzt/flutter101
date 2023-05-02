// To parse this JSON data, do
//
//     final config = configFromJson(jsonString);

import 'dart:convert';

ConnectionSetting connectionSettingFromJson(String str) => ConnectionSetting.fromJson(json.decode(str));

String connectionSettingToJson(ConnectionSetting data) => json.encode(data.toJson());

class ConnectionSetting {
  ConnectionSetting({
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

  factory ConnectionSetting.fromJson(Map<String, dynamic> json) => ConnectionSetting(
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
}
