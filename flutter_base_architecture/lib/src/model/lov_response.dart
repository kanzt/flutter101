// To parse this JSON data, do
//
//     final lovOrgResult = lovOrgResultFromJson(jsonString);

import 'dart:convert';

LovOrgResult lovOrgResultFromJson(String str) => LovOrgResult.fromJson(json.decode(str));

String lovOrgResultToJson(LovOrgResult data) => json.encode(data.toJson());

class LovOrgResult {
  LovOrgResult({
    this.results,
  });

  List<Org> results;

  factory LovOrgResult.fromJson(Map<String, dynamic> json) => LovOrgResult(
    results: List<Org>.from(json["results"].map((x) => Org.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "results": List<dynamic>.from(results.map((x) => x.toJson())),
  };
}

class Org {
  Org({
    this.orgAbbrWbs,
    this.orgName,
    this.orgSerial,
    this.orgEngName,
  });

  String orgAbbrWbs;
  String orgName;
  String orgSerial;
  String orgEngName;

  factory Org.fromJson(Map<String, dynamic> json) => Org(
    orgAbbrWbs: json["orgAbbrWbs"],
    orgName: json["orgName"],
    orgSerial: json["orgSerial"],
    orgEngName: json["orgEngName"],
  );

  Map<String, dynamic> toJson() => {
    "orgAbbrWbs": orgAbbrWbs,
    "orgName": orgName,
    "orgSerial": orgSerial,
    "orgEngName": orgEngName,
  };
}
