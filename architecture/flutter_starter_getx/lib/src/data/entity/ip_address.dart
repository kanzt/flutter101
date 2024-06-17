// To parse this JSON data, do
//
//     final ipAddress = ipAddressFromJson(jsonString);

import 'dart:convert';

IpAddress ipAddressFromJson(String str) => IpAddress.fromJson(json.decode(str));

String ipAddressToJson(IpAddress data) => json.encode(data.toJson());

class IpAddress {
  IpAddress({
    required this.ip,
  });

  String ip;

  factory IpAddress.fromJson(Map<String, dynamic> json) => IpAddress(
    ip: json["ip"],
  );

  Map<String, dynamic> toJson() => {
    "ip": ip,
  };
}
