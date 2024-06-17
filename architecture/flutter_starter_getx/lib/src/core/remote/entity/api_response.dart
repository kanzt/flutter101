import 'dart:convert';

import 'package:flutter_starter/src/core/remote/entity/serializable.dart';

ApiResponse apiResponseFromJson(String str, Function(Map<String, dynamic>)? create) => ApiResponse.fromJson(json.decode(str), create);

String apiResponseToJson(ApiResponse data) => json.encode(data.toJson());

// https://stackoverflow.com/questions/64595975/dart-flutter-generic-api-response-class-dynamic-class-data-type
class ApiResponse<T extends Serializable> {
  ApiResult<T>? response;

  ApiResponse({
    this.response,
  });

  factory ApiResponse.fromJson(
      Map<String, dynamic> json, Function(Map<String, dynamic>)? create) {
    return ApiResponse(
      response: json["response"] == null ? null : ApiResult.fromJson(json["response"], create),
    );
  }

  Map<String, dynamic> toJson() => {
    "response": response?.toJson(),
  };
}

class ApiResult<T extends Serializable> {
  bool? status;
  String? code;
  String? message;
  T? result;

  ApiResult({
    this.status,
    this.code,
    this.message,
    this.result,
  });

  factory ApiResult.fromJson(
      Map<String, dynamic> json, Function(Map<String, dynamic>)? create) {
    return ApiResult<T>(
      status: json["status"],
      code: json["code"],
      message: json["message"],
      result: json["result"] == null || create == null ? null : create(json["result"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "status": status,
    "code": code,
    "message": message,
    "result" : result?.toJson(),
  };
}
