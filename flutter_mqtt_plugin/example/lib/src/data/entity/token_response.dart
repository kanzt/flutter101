// To parse this JSON data, do
//
//     final tokenResponse = tokenResponseFromJson(jsonString);

import 'dart:convert';

import 'package:flutter_mqtt_plugin_example/src/core/remote/entity/serializable.dart';

TokenResponse tokenResponseFromJson(String str) => TokenResponse.fromJson(json.decode(str));

String tokenResponseToJson(TokenResponse data) => json.encode(data.toJson());

class TokenResponse extends Serializable {
  TokenResponse({
    required this.result,
  });

  bool result;

  factory TokenResponse.fromJson(Map<String, dynamic> json) => TokenResponse(
    result: json["result"],
  );

  @override
  Map<String, dynamic> toJson() => {
    "result": result,
  };
}
