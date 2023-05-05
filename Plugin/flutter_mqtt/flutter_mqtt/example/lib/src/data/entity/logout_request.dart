// To parse this JSON data, do
//
//     final logoutRequest = logoutRequestFromJson(jsonString);

import 'dart:convert';

import 'package:flutter_mqtt_example/src/core/remote/entity/serializable.dart';

LogoutRequest logoutRequestFromJson(String str) => LogoutRequest.fromJson(json.decode(str));

String logoutRequestToJson(LogoutRequest data) => json.encode(data.toJson());

class LogoutRequest implements Serializable {
  String token;
  String queueName;

  LogoutRequest({
    required this.token,
    required this.queueName,
  });

  factory LogoutRequest.fromJson(Map<String, dynamic> json) => LogoutRequest(
    token: json["token"],
    queueName: json["queueName"],
  );

  @override
  Map<String, dynamic> toJson() => {
    "token": token,
    "queueName": queueName,
  };
}
