


import 'package:flutter_mqtt_example/src/core/remote/entity/serializable.dart';

class Message implements Serializable{
  String? businessCode;
  String? message;
  String? level;

  Message({this.businessCode, this.message, this.level});

  @override
  @override
  Map<String, dynamic> toJson() => {
    "businessCode": businessCode,
    "message": message,
    "level": level,
  };
}