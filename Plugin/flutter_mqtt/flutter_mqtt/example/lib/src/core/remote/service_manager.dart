import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mqtt_example/src/core/flavor/flavor_config.dart';
import 'package:flutter_mqtt_example/src/core/remote/enum/http_method.dart';
import 'package:flutter_mqtt_example/src/core/remote/interceptor/pretty_dio_logger.dart';
import 'package:flutter_mqtt_example/src/core/remote/request_config.dart';
import 'package:get/get.dart' as get_x;
import 'package:get/get_connect/http/src/status/http_status.dart';

class ServiceManager {
  final Dio _dio = Dio();

  ServiceManager() {
    _dio
      ..interceptors.add(InterceptorsWrapper(
        onRequest: (options, handler) async {
          if (!(options.path.startsWith("http://") ||
              options.path.startsWith("https://"))) {
            options.baseUrl = FlavorConfig.instance.values.baseURL;
          }
          options.connectTimeout = const Duration(milliseconds: 30000);

          if (options.responseType != ResponseType.stream) {
            options.receiveTimeout = const Duration(milliseconds: 6000);
          }

          // Put access token into header
          // if (!options.path.endsWith("auth") &&
          //     options.path != Constant.ipify &&
          //     !options.path.endsWith("token")) {
          //   final String? token =
          //       await SharedPreference.read(SharedPreference.KEY_ACCESS_TOKEN);
          //   options.headers['Authorization'] = "Bearer $token";
          // }

          // Filter null value
          if (options.method != HttpMethod.GET.name) {
            _ignoreNullField(options.data);
          } else {
            _ignoreNullField(options.queryParameters);
          }

          return handler.next(options);
        },
        onResponse: (response, handler) async {
          return handler.next(response);
        },
        onError: (err, handler) async {
          return handler.next(err);
        },
      ))
      ..interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: true,
        compact: false,
      ));
  }

  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    final options =
        Options(method: requestOptions.method, headers: requestOptions.headers);

    return _dio.request(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }

  void _showPendingDialog() {
    if (get_x.Get.isDialogOpen == false) {
      get_x.Get.dialog(
        AlertDialog(
          content: Row(
            children: [
              const CircularProgressIndicator(),
              Container(
                margin: const EdgeInsets.only(left: 7),
                child: const Text("Loading..."),
              ),
            ],
          ),
        ),
        barrierDismissible: false,
      );
    }
  }

  void _closePendingDialog() {
    if (get_x.Get.isDialogOpen == true) {
      get_x.Get.back();
    }
  }

  Future<DioError?> _handleError(DioError err, bool isHandleErrorManually) {
    final errorDialog = AlertDialog(
      title: const Text('แจ้งเตือน'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text(err.message ?? "เกิดข้อผิดพลาด"),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('OK'),
          onPressed: () {
            get_x.Get.back();
          },
        ),
      ],
    );
    if (err.response?.statusCode == HttpStatus.serviceUnavailable ||
        err.response?.statusCode == HttpStatus.notFound ||
        err.response == null) {
      if (!isHandleErrorManually) {
        get_x.Get.dialog(errorDialog);
        return Future.value(null);
      }
    } else if (err.response?.statusCode == HttpStatus.internalServerError ||
        (err.error is SocketException &&
            err.message?.contains("Failed host lookup") == true)) {
      if (!isHandleErrorManually) {
        get_x.Get.dialog(errorDialog);
        return Future.value(null);
      }
    }

    return Future.error(err);
  }

  /// request
  /// [httpMethod] HttpMethod.GET, HttpMethod.POST, HttpMethod.PUT pr HttpMethod.DELETE
  /// [path] Path ของ Service ถ้าไม่ต้องการใช้งาน BaseURL ให้ทำการระบุ fullUrlPath เข้ามาเลย
  /// [data] RequestBody ส่งเข้ามาเมื่อเรียกด้วย HttpMethod PUT, POST
  /// [queryParameters] ส่งเข้ามาเมื่อเรียกด้วย HttpMethod GET, DELETE
  /// [isHandleErrorManually] true = ตีเข้าหน้า ErrorPage อัตโนมัติ
  Future<dynamic> request(
    RequestConfig requestConfig, {
    bool isPendingDialog = false,
    bool isHandleErrorManually = false,
    bool isRequiredIpAddress = false,
  }) async {
    try {
      dynamic responseJson;

      dynamic makeRequest() async {
        final response = await _dio.request(
          requestConfig.path,
          data: requestConfig.data,
          queryParameters: requestConfig.queryParameters,
          options: Options(method: requestConfig.httpMethod.name),
        );

        if (response.statusCode == HttpStatus.ok) {
          final jsonString =
              (response.headers['Content-Type'] ?? []).contains('text/plain')
                  ? response.data
                  : json.encode(response.data);
          return jsonString;
        }
      }

      if (isPendingDialog) {
        _showPendingDialog();
      }

      responseJson = await makeRequest();
      if (isPendingDialog) {
        _closePendingDialog();
      }

      return responseJson;
    } on DioError catch (e) {
      if (isPendingDialog) {
        _closePendingDialog();
      }
      return _handleError(e, isHandleErrorManually);
    }
  }

  /// Parallel fetch API
  /// [isHandleErrorManually] true = ตีเข้าหน้า ErrorPage อัตโนมัติ
  Future<dynamic> requests(
    List<RequestConfig> requests, {
    bool isPendingDialog = false,
    bool isHandleErrorManually = false,
  }) async {
    try {
      // final language = Languages.of(get_x.Get.context!)!;
      dynamic response;
      dynamic makeRequest() async {
        return Future.wait(requests.map((e) => request(e)));
      }

      if (isPendingDialog) {
        _showPendingDialog();
      }
      response = await makeRequest();
      if (isPendingDialog) {
        _closePendingDialog();
      }

      return response;
    } on DioError catch (e) {
      if (isPendingDialog) {
        _closePendingDialog();
      }
      return _handleError(e, isHandleErrorManually);
    }
  }

  void _ignoreNullField(dynamic data) {
    if (data is Map) {
      if (data.isEmpty == true) return;
      data.removeWhere((key, value) => value == null);
      data.forEach((dynamic key, dynamic value) {
        _ignoreNullField(value);
      });
    }
  }
}
