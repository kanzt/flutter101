
import 'package:flutter_starter/src/core/remote/entity/serializable.dart';

// https://stackoverflow.com/questions/64595975/dart-flutter-generic-api-response-class-dynamic-class-data-type
class ApiRequest<T extends Serializable> {
  T? request;

  ApiRequest({this.request});

  factory ApiRequest.fromJson(Map<String, dynamic> json, Function(Map<String, dynamic>) create) {
    return ApiRequest<T>(
      request: create(json["request"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "request": request?.toJson(),
  };
}
