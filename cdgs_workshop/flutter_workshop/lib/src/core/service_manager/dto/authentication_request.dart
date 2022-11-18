// To parse this JSON data, do
//
//     final authenticationRequest = authenticationRequestFromJson(jsonString);

import 'dart:convert';

AuthenticationRequest authenticationRequestFromJson(String str) => AuthenticationRequest.fromJson(json.decode(str));

String authenticationRequestToJson(AuthenticationRequest data) => json.encode(data.toJson());

class AuthenticationRequest {
  AuthenticationRequest({
    this.request,
  });

  Request? request;

  factory AuthenticationRequest.fromJson(Map<String, dynamic> json) => AuthenticationRequest(
    request: Request.fromJson(json["request"]),
  );

  Map<String, dynamic> toJson() => {
    "request": request?.toJson(),
  };
}

class Request {
  Request({
    this.username,
    this.password,
    this.refreshToken,
  });

  String? username;
  String? password;
  String? refreshToken;

  factory Request.fromJson(Map<String, dynamic> json) => Request(
    username: json["username"],
    password: json["password"],
    refreshToken: json["refreshToken"],
  );

  Map<String, dynamic> toJson() => {
    "username": username,
    "password": password,
    "refreshToken": refreshToken,
  };
}
