import 'package:flutter_workshop/src/core/service_manager/http_method.dart';

class RequestConfig {
  String path;
  HttpMethod httpMethod;
  Map<String, dynamic>? data;
  Map<String, dynamic>? queryParameters;

  RequestConfig(this.httpMethod, this.path, {this.data, this.queryParameters});
}
