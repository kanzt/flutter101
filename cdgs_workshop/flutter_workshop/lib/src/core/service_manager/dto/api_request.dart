import 'dart:convert';

// String apiRequestToJson<T extends BaseModel>(ApiRequest apiRequest) => json.encode(apiRequest.toJson());

/// toJson สำหรับ Convert Object ใน List (results) ไปเป็น json
String buildRequest(ApiRequest apiRequest, Function(dynamic) toJson) =>
    json.encode(apiRequest.toJson(toJson));

class ApiRequest<T> {
  List<T>? requests;
  T? request;

  ApiRequest({this.requests, this.request});

  Map<String, dynamic> toJson(Function(dynamic) toJson) => _mapRequest(toJson);

  Map<String, dynamic> _mapRequest(Function(dynamic) toJson) {
    if (request != null) {
      return {
        "request": toJson(request),
      };
    } else {
      return {
        "requests": List<T>.from((requests ?? []).map((x) => toJson(x))),
      };
    }
  }
}
