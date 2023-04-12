// To parse this JSON data, do
//
//     final config = configFromJson(jsonString);

import 'dart:convert';

Config configFromJson(String str) => Config.fromJson(json.decode(str));

String configToJson(Config data) => json.encode(data.toJson());

class Config {
  Config({
    required this.isRequiredSsl,
    required this.hostname,
    required this.password,
    required this.username,
    required this.clientId,
    required this.topic,
  });

  bool isRequiredSsl;
  String hostname;
  String password;
  String username;
  String clientId;
  String topic;

  factory Config.fromJson(Map<String, dynamic> json) => Config(
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
