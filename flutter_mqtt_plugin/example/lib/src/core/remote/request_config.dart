
import 'package:flutter_mqtt_plugin_example/src/core/remote/enum/http_method.dart';

class RequestConfig {
  String path;
  HttpMethod httpMethod;
  Map<String, dynamic>? data;
  Map<String, dynamic>? queryParameters;

  RequestConfig(this.httpMethod, this.path, {this.data, this.queryParameters});

  RequestConfig copyWith({
    String? path,
    HttpMethod? httpMethod,
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
  }) {
    return RequestConfig(
        httpMethod ?? this.httpMethod,
        path ?? this.path,
        data : data ?? this.data,
        queryParameters : queryParameters ?? this.queryParameters,
    );
  }
}
