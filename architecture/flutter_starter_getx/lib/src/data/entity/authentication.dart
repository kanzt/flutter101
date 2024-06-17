// To parse this JSON data, do
//
//     final authRequest = authRequestFromJson(jsonString);

import 'dart:convert';

import 'package:flutter_starter/src/core/remote/entity/serializable.dart';

Authentication authenticationFromJson(String str) =>
    Authentication.fromJson(json.decode(str));

String authenticationToJson(Authentication data) => json.encode(data.toJson());

class Authentication implements Serializable {
  Authentication({
    this.operatingSystems,
    this.ipAddress,
    this.deviceToken,
    this.clientId,
    this.clientSecret,
    this.refreshToken,
    this.accessToken,
  });

  String? operatingSystems;
  String? ipAddress;
  String? deviceToken;
  String? clientId;
  String? clientSecret;
  String? refreshToken;
  String? accessToken;


  factory Authentication.fromJson(Map<String, dynamic> json) => Authentication(
        operatingSystems: json["operating_systems"],
        ipAddress: json["ip_address"],
        deviceToken: json["device_token"],
        clientId: json["client_id"],
        clientSecret: json["client_secret"],
        refreshToken: json["refresh_token"],
        accessToken: json["access_token"],
      );

  @override
  Map<String, dynamic> toJson() => {
        "operating_systems": operatingSystems,
        "ip_address": ipAddress,
        "device_token": deviceToken,
        "client_id": clientId,
        "client_secret": clientSecret,
        "refresh_token": refreshToken,
        "access_token": accessToken,
      };
}
