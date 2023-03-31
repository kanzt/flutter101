import 'dart:convert';

import 'package:flutter_mqtt_plugin_example/src/core/remote/entity/serializable.dart';

ApiResponse apiResponseFromJson(
        String str, Function(Map<String, dynamic>)? create) =>
    ApiResponse.fromJson(json.decode(str), create);

String apiResponseToJson(ApiResponse data) => json.encode(data.toJson());

class ApiResponse<T extends Serializable> {
  bool? isSuccess;
  String? code;
  String? message;
  T? result;

  ApiResponse({
    this.isSuccess,
    this.code,
    this.message,
    this.result,
  });

  factory ApiResponse.fromJson(
      Map<String, dynamic> json, Function(Map<String, dynamic>)? create) {
    return ApiResponse<T>(
      isSuccess: json["isSuccess"],
      code: json["code"],
      message: json["message"],
      result: json["result"] == null
          ? null
          : json["result"] is Map<String, dynamic>
              ? create!(json["result"])
              : json["result"],
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        "isSuccess": isSuccess,
        "code": code,
        "message": message,
        "result": result?.toJson(),
      };
}
