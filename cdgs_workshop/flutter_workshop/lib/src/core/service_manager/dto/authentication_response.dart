// To parse this JSON data, do
//
//     final authenticationResponse = authenticationResponseFromJson(jsonString);

import 'dart:convert';

AuthenticationResponse authenticationResponseFromJson(String str) => AuthenticationResponse.fromJson(json.decode(str));

String authenticationResponseToJson(AuthenticationResponse data) => json.encode(data.toJson());

class AuthenticationResponse {
  AuthenticationResponse({
    this.result,
  });

  AuthenticationResult? result;

  factory AuthenticationResponse.fromJson(Map<String, dynamic> json) => AuthenticationResponse(
    result: AuthenticationResult.fromJson(json["result"]),
  );

  Map<String, dynamic> toJson() => {
    "result": result?.toJson(),
  };
}

class AuthenticationResult {
  AuthenticationResult({
    this.username,
    this.password,
    this.refreshToken,
    this.accessToken,
  });

  String? username;
  String? password;
  String? refreshToken;
  String? accessToken;

  factory AuthenticationResult.fromJson(Map<String, dynamic> json) => AuthenticationResult(
    username: json["username"],
    password: json["password"],
    refreshToken: json["refreshToken"],
    accessToken: json["accessToken"],
  );

  Map<String, dynamic> toJson() => {
    "username": username,
    "password": password,
    "refreshToken": refreshToken,
    "accessToken": accessToken,
  };
}