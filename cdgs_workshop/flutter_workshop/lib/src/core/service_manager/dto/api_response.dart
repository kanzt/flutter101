import 'dart:convert';

import 'package:flutter_workshop/src/core/service_manager/dto/api_message.dart';


ApiResponse buildResponse<T>(
        String str, Function(dynamic) fromJson) =>
    ApiResponse<T>.fromJson(json.decode(str), fromJson);

class ApiResponse<T> {
  List<T>? results;
  T? result;
  List<Message>? messages;
  String? message;
  bool? statusClosed;

  ApiResponse({this.results, this.result, this.messages, this.message, this.statusClosed,});

  factory ApiResponse.fromJson(
          Map<String, dynamic> json, Function(dynamic) fromJson) =>
      ApiResponse(
        result: json["result"] == null ? null : fromJson(json["result"]),
        results: json["results"] == null
            ? null
            : List<T>.from(json["results"].map((x) => fromJson(x))),
        messages: json["messages"],
        message: json["message"],
        statusClosed: json["statusClosed"],
      );
}
