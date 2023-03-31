import 'dart:convert';

import 'package:flutter_mqtt_plugin_example/src/core/remote/entity/serializable.dart';

LoginRequest loginRequestFromJson(String str) => LoginRequest.fromJson(json.decode(str));

String loginRequestToJson(LoginRequest data) => json.encode(data.toJson());

class LoginRequest implements Serializable {
  LoginRequest({
    required this.email,
    required this.password,
  });

  String email;
  String password;

  factory LoginRequest.fromJson(Map<String, dynamic> json) => LoginRequest(
    email: json["email"],
    password: json["password"],
  );

  @override
  Map<String, dynamic> toJson() => {
    "email": email,
    "password": password,
  };
}
