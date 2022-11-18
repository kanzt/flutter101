import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_workshop/src/core/config/di/auth_controller.dart';
import 'package:flutter_workshop/src/core/config/flavor/flavor_config.dart';
import 'package:flutter_workshop/src/core/config/locale/languages/languages.dart';
import 'package:flutter_workshop/src/core/constant/shared_preferences_key.dart';
import 'package:flutter_workshop/src/core/service_manager/dto/authentication_request.dart';
import 'package:flutter_workshop/src/core/service_manager/dto/authentication_response.dart';
import 'package:flutter_workshop/src/core/service_manager/http_method.dart';
import 'package:flutter_workshop/src/core/service_manager/request_config.dart';
import 'package:flutter_workshop/src/core/widgets/custom_alert_dialog.dart';
import 'package:get/get.dart' as get_x;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ServiceManager {
  final logger = Logger();
  final Dio _dio = Dio();
  Future<dynamic>? pendingDialog;

  ServiceManager() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        if (!(options.path.startsWith("http://") ||
            options.path.startsWith("https://"))) {
          options.baseUrl = FlavorConfig.instance.values.baseUrl;
        }
        options.connectTimeout = 300000;
        options.receiveTimeout = 100000;

        // Put access token into header
        if (!options.path.endsWith("auth")) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          var token = prefs.getString(SharedPreferenceKey.KEY_ACCESS_TOKEN);
          options.headers['Authorization'] = "Bearer $token";
        }

        logger.i(options.baseUrl + options.path);
        logger.i(options.method);
        if (options.method == "GET") {
          logger.i(options.queryParameters);
        }
        if (options.method == "POST" ||
            options.method == "PUT" &&
                (!options.path.toLowerCase().contains("auth"))) {
          logger.i(options.data);
        }
        return handler.next(options);
      },
      onResponse: (response, handler) async {
        logger.i(response.statusCode);
        logger.i(response.data);
        return handler.next(response);
      },
      onError: (err, handler) async {
        logger.e(err.message);

        // If statusCode == 401 then renew token
        if (err.response?.statusCode == HttpStatus.unauthorized) {
          if (!err.requestOptions.path.endsWith("renew-token") &&
              !err.requestOptions.path.endsWith("auth")) {
            if (await _renewToken()) {
              logger.i("Retrying network request...");
              return handler.resolve(await _retry(err.requestOptions));
            } else {
              get_x.Get.find<AuthController>().endSession();
              handler.reject(err);
            }
          }
        }
        return handler.next(err);
      },
    ));
  }

  Future<bool> _renewToken() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final refreshToken =
          prefs.getString(SharedPreferenceKey.KEY_REFRESH_TOKEN);

      if (refreshToken?.isNotEmpty == true) {
        var data = authenticationRequestToJson(
          AuthenticationRequest(
            request: Request(
              refreshToken: refreshToken,
            ),
          ),
        );

        final response = await _dio.post("auth/renew-token", data: data);

        if (response.statusCode == HttpStatus.ok) {
          String? accessToken =
              authenticationResponseFromJson(json.encode(response.data))
                  .result
                  ?.accessToken;

          if (accessToken?.isNotEmpty == true) {
            await prefs.setString(
                SharedPreferenceKey.KEY_ACCESS_TOKEN, accessToken!);

            return true;
          }
        }
      }

      return false;
    } catch (e) {
      return false;
    }
  }

  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    final options =
        Options(method: requestOptions.method, headers: requestOptions.headers);

    return _dio.request(
      requestOptions.path,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }

  Widget pendingDialogWidget() {
    // TODO : Create Pending dialog
    final language = Languages.of(get_x.Get.context!)!;
    return AlertDialog(
      content: Row(
        children: [
          const CircularProgressIndicator(),
          Container(
              margin: const EdgeInsets.only(left: 7),
              child: Text("${language.loading}...")),
        ],
      ),
    );
  }

  Widget errorDialogWidget(String message) {
    // TODO : Create Error dialog
    return CustomAlertDialog(
      title: message,
      body: '',
      isErrDialog: true,
    );
  }

  void _showPendingDialog() {
    pendingDialog =
        get_x.Get.dialog(pendingDialogWidget(), barrierDismissible: false);
  }

  void _closePendingDialog() {
    Navigator.of(get_x.Get.overlayContext!).pop();
    pendingDialog = null;
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: get_x.Get.context!,
      builder: (ctx) {
        return errorDialogWidget(message);
      },
      barrierDismissible: false,
    );
  }

  Future<dynamic> _handleError(dynamic e, bool isErrorDialog) {
    String errorMessage;
    final language = Languages.of(get_x.Get.context!)!;

    if (e is DioError) {
      switch (e.type) {
        case DioErrorType.connectTimeout:
          errorMessage = language.connectionTimeout;
          break;
        case DioErrorType.response:
          errorMessage = "${language.errorOccurred}  ${language.pleaseContactAdmin}";
          break;
        case DioErrorType.other:
          if (DioErrorType.other.name.contains("SocketException")) {
            errorMessage = language.pleaseConnectToTheInternet;
          } else {
            errorMessage = language.connectionException;
          }
          break;
        default:
          if (e is Exception) {
            errorMessage = e.message;
          } else {
            errorMessage = "${language.errorOccurred}  ${language.pleaseContactAdmin}";
          }
      }
    } else {
      errorMessage = e.message;
    }

    if (isErrorDialog) {
      _showErrorDialog(errorMessage);
    }

    return Future.error(errorMessage);
  }

  Future<bool> _hasInternet() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return await InternetConnectionChecker().hasConnection;
    }

    return false;
  }

  /// request
  /// @httpMethod HttpMethod.GET, HttpMethod.POST, HttpMethod.PUT pr HttpMethod.DELETE
  /// @path ถ้าไม่ต้องการใช้งาน BaseURL ให้ทำการระบุ fullUrlPath เข้ามาเลย
  /// @data ส่งเข้ามาเมื่อเรียกด้วย HttpMethod PUT, POST
  /// @queryParameters ส่งเข้ามาเมื่อเรียกด้วย HttpMethod GET, DELETE
  Future<dynamic> request(
    HttpMethod httpMethod,
    String path, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    bool ignoreHasInternet = false,
    bool isPendingDialog = false,
    bool isErrorDialog = false,
  }) async {
    try {
      final language = Languages.of(get_x.Get.context!)!;
      dynamic responseJson;

      dynamic makeRequest() async {
        final response = await _dio.request(
          path,
          data: data,
          queryParameters: queryParameters,
          options: Options(method: httpMethod.name),
        );

        if (response.statusCode == HttpStatus.ok) {
          return json.encode(response.data);
        }
      }

      if (isPendingDialog && pendingDialog == null) {
        _showPendingDialog();
      }

      if (ignoreHasInternet) {
        responseJson = await makeRequest();
      } else {
        if (await _hasInternet()) {
          responseJson = await makeRequest();
        } else {
          return _handleError(
            Exception(language.pleaseConnectToTheInternet),
            isErrorDialog,
          );
        }
      }

      if (isPendingDialog && pendingDialog != null) {
        _closePendingDialog();
      }

      return responseJson;
    } catch (e) {
      if (isPendingDialog && pendingDialog != null) {
        _closePendingDialog();
      }
      return _handleError(e, isErrorDialog);
    }
  }

  /// Parallel fetch API
  Future<dynamic> requests(
    List<RequestConfig> requests, {
    bool ignoreHasInternet = false,
    bool isPendingDialog = false,
    bool isErrorDialog = false,
  }) async {
    try {
      final language = Languages.of(get_x.Get.context!)!;
      dynamic response;
      dynamic makeRequest() async {
        return Future.wait(requests.map((e) => request(e.httpMethod, e.path)));
      }

      if (isPendingDialog && pendingDialog == null) {
        _showPendingDialog();
      }

      if (ignoreHasInternet) {
        response = await makeRequest();
      } else {
        if (await _hasInternet()) {
          response = await makeRequest();
        } else {
          return _handleError(
            Exception(language.pleaseConnectToTheInternet),
            isErrorDialog,
          );
        }
      }

      if (isPendingDialog && pendingDialog != null) {
        _closePendingDialog();
      }

      return response;
    } catch (e) {
      if (isPendingDialog && pendingDialog != null) {
        _closePendingDialog();
      }
      return _handleError(e, isErrorDialog);
    }
  }
}