// To parse this JSON data, do
//
//     final tokenResponse = tokenResponseFromJson(jsonString);

import 'dart:convert';

import 'package:flutter_mqtt_example/src/core/remote/entity/serializable.dart';


BoolResponse boolResponseFromJson(String str) => BoolResponse.fromJson(json.decode(str));

String boolResponseToJson(BoolResponse data) => json.encode(data.toJson());

class BoolResponse extends Serializable {
  BoolResponse({
    required this.result,
  });

  bool result;

  factory BoolResponse.fromJson(Map<String, dynamic> json) => BoolResponse(
    result: json["result"],
  );

  @override
  Map<String, dynamic> toJson() => {
    "result": result,
  };
}
