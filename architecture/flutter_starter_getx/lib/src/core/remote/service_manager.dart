import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_starter/src/core/config/routes.dart';
import 'package:flutter_starter/src/core/remote/entity/api_request.dart';
import 'package:flutter_starter/src/core/remote/entity/api_response.dart';
import 'package:flutter_starter/src/core/remote/enum/http_error.dart';
import 'package:flutter_starter/src/core/remote/enum/http_method.dart';
import 'package:flutter_starter/src/core/remote/enum/type_download.dart';
import 'package:flutter_starter/src/core/remote/interceptor/pretty_dio_logger.dart';
import 'package:flutter_starter/src/core/remote/request_config.dart';
import 'package:flutter_starter/src/core/remote/service_api.dart';
import 'package:flutter_starter/src/data/entity/authentication.dart';
import 'package:flutter_starter/src/data/entity/ip_address.dart';
import 'package:flutter_starter/src/util/constant/constant.dart';
import 'package:flutter_starter/src/util/log/log_main.dart';
import 'package:flutter_starter/src/util/shared_preferences/shared_preferences.dart';
import 'package:flutter_starter/src/util/widget/dialog/pending_dialog.dart';
import 'package:flutter_starter/src/util/widget/dialog/progress_dialog.dart';
import 'package:get/get.dart' as get_x;
import 'package:get/get_connect/http/src/status/http_status.dart';
import 'package:path_provider/path_provider.dart';

class ServiceManager {
  final Dio _dio = Dio();

  ServiceManager() {
    _dio
      ..interceptors.add(InterceptorsWrapper(
        onRequest: (options, handler) async {
          if (!(options.path.startsWith("http://") ||
              options.path.startsWith("https://"))) {
            const serviceProviderUrl = "[URL_Service]";
            options.baseUrl = serviceProviderUrl ?? '';
          }
          options.connectTimeout = 30000;

          if (options.responseType != ResponseType.stream) {
            options.receiveTimeout = 60000;
          }

          // Put access token into header
          if (!options.path.endsWith("auth") &&
              options.path != Constant.ipify &&
              !options.path.endsWith("token")) {
            final String? token =
                await SharedPreference.read(SharedPreference.KEY_ACCESS_TOKEN);
            options.headers['Authorization'] = "Bearer $token";
          }

          // Filter null value
          if (options.method != HttpMethod.GET.name) {
            _ignoreNullField(options.data);
          } else {
            _ignoreNullField(options.queryParameters);
          }

          return handler.next(options);
        },
        onResponse: (response, handler) async {
          const serviceProviderUrl = "[URL_Service]";
          if (response.requestOptions.baseUrl == serviceProviderUrl) {
            final contentType = response.headers['Content-Type'] ?? [];
            if ((contentType.contains('text/plain') ||
                    contentType.contains('application/json')) &&
                response.requestOptions.responseType != ResponseType.stream) {
              final jsonString = (response.headers['Content-Type'] ?? [])
                      .contains('text/plain')
                  ? response.data
                  : json.encode(response.data);

              final responseData = apiResponseFromJson(jsonString, null);

              if (responseData.response?.status == false) {
                if (responseData.response?.code == HttpError.C_00_003.code ||
                    responseData.response?.code == HttpError.C_00_004.code) {
                  if (await _renewToken()) {
                    Log.d("Retrying network request...");
                    return handler
                        .resolve(await _retry(response.requestOptions));
                  } else {
                    unawaited(SharedPreference.clearLogoutAll());
                    // unawaited(get_x.Get.offAllNamed(Routes.loginPage));
                    return handler.resolve(response);
                  }
                }
              }
            }
          }
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

  Future<bool> _renewToken() async {
    try {
      final refreshToken =
          await SharedPreference.read(SharedPreference.KEY_REFRESH_TOKEN);

      if (refreshToken?.isNotEmpty == true) {
        final apiResponse =
            await request(get_x.Get.find<ServiceApi>().token.copyWith(
                  data: ApiRequest(
                    request: Authentication(
                        deviceToken: await SharedPreference.read(
                                SharedPreference.KEY_FCM_TOKEN) ??
                            "",
                        refreshToken: refreshToken!),
                  ).toJson(),
                ));

        final response = ApiResponse<Authentication>.fromJson(
          json.decode(apiResponse),
          (data) => Authentication.fromJson(data),
        ).response;

        await Future.wait([
          SharedPreference.write(
            SharedPreference.KEY_ACCESS_TOKEN,
            response?.result?.accessToken,
          ),
          SharedPreference.write(
            SharedPreference.KEY_REFRESH_TOKEN,
            response?.result?.refreshToken,
          )
        ]);

        return true;
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
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }

  void _showPendingDialog() {
    if (get_x.Get.isDialogOpen == false) {
      get_x.Get.dialog(const PendingDialog(), barrierDismissible: false);
    }
  }

  void _closePendingDialog() {
    if (get_x.Get.isDialogOpen == true) {
      get_x.Get.back();
    }
  }

  Future<DioError?> _handleError(DioError err, bool isHandleErrorManually) {
    if (err.response?.statusCode == HttpStatus.serviceUnavailable ||
        err.response?.statusCode == HttpStatus.notFound ||
        err.response == null) {
      if (!isHandleErrorManually) {
        unawaited(get_x.Get.offAllNamed(Routes.errorPage));
        return Future.value(null);
      }
    } else if (err.response?.statusCode == HttpStatus.internalServerError ||
        (err.error is SocketException &&
            err.error.message.contains("Failed host lookup"))) {
      if (!isHandleErrorManually) {
        unawaited(get_x.Get.toNamed(Routes.errorNoConnectionPage));
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

      if (isRequiredIpAddress && requestConfig.data != null) {
        await _attachIpAddressToRequestBody(requestConfig);
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

  Future<void> _attachIpAddressToRequestBody(RequestConfig requestConfig,
      {bool isApiRequest = true}) async {
    var ipAddress;
    final ipAddressRes = await _dio.request(
      Constant.ipify,
      options: Options(method: HttpMethod.GET.name),
    );

    if (ipAddressRes.statusCode == HttpStatus.ok) {
      ipAddress = ipAddressFromJson(json.encode(ipAddressRes.data)).ip;
    }

    if (isApiRequest == true) {
      final request = requestConfig.data!["request"] as Map<String, dynamic>;
      request.addAll({"ip_address": ipAddress});
    } else {
      final request = requestConfig.data!;
      request.addAll({"ip_address": ipAddress});
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

  Future<dynamic> upload(
    RequestConfig requestConfig, {
    bool isPendingDialog = false,
    bool isHandleErrorManually = false,
    bool isRequiredIpAddress = false,
  }) async {
    try {
      if (isPendingDialog) {
        _showPendingDialog();
      }

      if (isRequiredIpAddress && requestConfig.data != null) {
        await _attachIpAddressToRequestBody(requestConfig, isApiRequest: false);
      }

      final formData = FormData.fromMap({
        'request': json.encode(requestConfig.data),
        'file_comment': await MultipartFile.fromFile(
            requestConfig.file?.path ?? "",
            filename:requestConfig.fileName?.replaceAll(RegExp(Constant.regExpOnlyThai), "_")),
      });

      var request = await _dio.request(
        requestConfig.path,
        data: formData,
        options: Options(
          method: requestConfig.httpMethod.name,
          headers: {'Content-Type': 'multipart/form-data'},
        ),
      );

      if (isPendingDialog) {
        _closePendingDialog();
      }

      if (request.statusCode == HttpStatus.ok) {
        return json.encode(request.data);
      }
    } on DioError catch (e) {
      return _handleError(e, isHandleErrorManually);
    }
  }

  /// [requestConfig]
  Future<dynamic> download(RequestConfig requestConfig,
      {bool isHandleErrorManually = false,
      required TypeDownload typeDownload}) async {
    try {
      // App-specific storage (Private storage)
      final fileDirectory = await getTemporaryDirectory();
      final filePath = fileDirectory.path;
      final fileName = typeDownload.value;
      final savePath = "$filePath$fileName";
      Log.d("File -> $savePath");

      ValueNotifier<String> loadingStatus = ValueNotifier<String>("0 %");

      unawaited(get_x.Get.dialog(
        ValueListenableBuilder(
          valueListenable: loadingStatus,
          builder: (BuildContext context, String value, Widget? child) {
            return ProgressDialog(
              value: value,
            );
          },
        ),
        barrierDismissible: false,
      ));

      var download = await _dio.download(
        requestConfig.path,
        data: requestConfig.data,
        queryParameters: requestConfig.queryParameters,
        savePath,
        deleteOnError: true,
        options: Options(method: requestConfig.httpMethod.name),
        onReceiveProgress: (int count, int total) {
          if (total < 0) {
            loadingStatus.value = "100 %";
          } else {
            loadingStatus.value = "${((count / total) * 100).ceil()} %";
          }
        },
      );

      loadingStatus.dispose();

      if (download.statusCode == HttpStatus.ok) {
        if (download.headers.map["content-type"]?.first.contains("json") ==
            true) {
          if (await File(savePath).exists() == true) {
            await File(savePath).delete();
          }
          throw Error();
        }
      }

      _closePendingDialog();
      return File(savePath);
    } on DioError catch (e) {
      return _handleError(e, isHandleErrorManually);
    } on Error catch (e) {
      _closePendingDialog();
      if (!isHandleErrorManually) {
        unawaited(get_x.Get.toNamed(Routes.errorNoConnectionPage));
      }
      return Future.value(e);
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
