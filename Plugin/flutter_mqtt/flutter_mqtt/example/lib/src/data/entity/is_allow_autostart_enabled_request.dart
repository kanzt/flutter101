// To parse this JSON data, do
//
//     final isAllowAutostartEnabledRequest = isAllowAutostartEnabledRequestFromJson(jsonString);

import 'dart:convert';

import 'package:flutter_mqtt_example/src/core/remote/entity/serializable.dart';

IsAllowAutostartEnabledRequest isAllowAutostartEnabledRequestFromJson(String str) => IsAllowAutostartEnabledRequest.fromJson(json.decode(str));

String isAllowAutostartEnabledRequestToJson(IsAllowAutostartEnabledRequest data) => json.encode(data.toJson());

class IsAllowAutostartEnabledRequest implements Serializable {
  String queueName;

  IsAllowAutostartEnabledRequest({
    required this.queueName,
  });

  factory IsAllowAutostartEnabledRequest.fromJson(Map<String, dynamic> json) => IsAllowAutostartEnabledRequest(
    queueName: json["queueName"],
  );

  Map<String, dynamic> toJson() => {
    "queueName": queueName,
  };
}