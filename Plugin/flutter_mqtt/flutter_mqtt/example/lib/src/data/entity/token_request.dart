// To parse this JSON data, do
//
//     final tokenRequest = tokenRequestFromJson(jsonString);

import 'dart:convert';

import 'package:flutter_mqtt_example/src/core/remote/entity/serializable.dart';


TokenRequest tokenRequestFromJson(String str) => TokenRequest.fromJson(json.decode(str));

String tokenRequestToJson(TokenRequest data) => json.encode(data.toJson());

class TokenRequest implements Serializable {
  TokenRequest({
    required this.token,
    required this.userId,
    required this.platform,
  });

  String token;
  String userId;
  String platform;

  factory TokenRequest.fromJson(Map<String, dynamic> json) => TokenRequest(
    token: json["token"],
    userId: json["user_id"],
    platform: json["platform"],
  );

  Map<String, dynamic> toJson() => {
    "token": token,
    "user_id": userId,
    "platform": platform,
  };
}
