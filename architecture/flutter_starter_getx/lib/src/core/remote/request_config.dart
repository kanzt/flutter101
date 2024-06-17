import 'dart:io';

import 'package:flutter_starter/src/core/remote/enum/http_method.dart';

class RequestConfig {
  String path;
  HttpMethod httpMethod;
  Map<String, dynamic>? data;
  Map<String, dynamic>? queryParameters;
  File? file;
  String? fileName;

  RequestConfig(this.httpMethod, this.path,
      {this.data, this.queryParameters, this.file,this.fileName});

  RequestConfig copyWith({
    String? path,
    HttpMethod? httpMethod,
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    File? file,
    String? fileName,
  }) {
    return RequestConfig(
      httpMethod ?? this.httpMethod,
      path ?? this.path,
      data: data ?? this.data,
      queryParameters: queryParameters ?? this.queryParameters,
      file: file ?? this.file,
      fileName: fileName ?? this.fileName,
    );
  }
}
