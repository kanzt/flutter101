import 'dart:convert';

import 'package:flutter_mqtt_plugin_example/src/core/remote/entity/serializable.dart';

LoginResponse loginResponseFromJson(String str) =>
    LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse implements Serializable {
  LoginResponse({
    required this.userId,
  });

  String userId;

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        userId: json["user_id"],
      );

  @override
  Map<String, dynamic> toJson() => {
        "user_id": userId,
      };
}
