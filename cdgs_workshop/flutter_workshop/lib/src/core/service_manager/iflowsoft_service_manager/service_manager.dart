import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iflowsoft/src/core/config/routes.dart';
import 'package:flutter_iflowsoft/src/core/remote/entity/api_request.dart';
import 'package:flutter_iflowsoft/src/core/remote/entity/api_response.dart';
import 'package:flutter_iflowsoft/src/core/remote/enum/http_error.dart';
import 'package:flutter_iflowsoft/src/core/remote/enum/http_method.dart';
import 'package:flutter_iflowsoft/src/core/remote/enum/type_download.dart';
import 'package:flutter_iflowsoft/src/core/remote/interceptor/pretty_dio_logger.dart';
import 'package:flutter_iflowsoft/src/core/remote/request_config.dart';
import 'package:flutter_iflowsoft/src/core/remote/service_api.dart';
import 'package:flutter_iflowsoft/src/data/entity/ip_address.dart';
import 'package:flutter_iflowsoft/src/data/entity/token_request.dart';
import 'package:flutter_iflowsoft/src/data/entity/token_response.dart';
import 'package:flutter_iflowsoft/src/resource/assets/assets.dart';
import 'package:flutter_iflowsoft/src/resource/color/color_assets.dart';
import 'package:flutter_iflowsoft/src/resource/language/language_size.dart';
import 'package:flutter_iflowsoft/src/resource/language/language_type.dart';
import 'package:flutter_iflowsoft/src/util/constant/constant.dart';
import 'package:flutter_iflowsoft/src/util/constant/grant_type.dart';
import 'package:flutter_iflowsoft/src/util/log/log_main.dart';
import 'package:flutter_iflowsoft/src/util/shared_preferences/shared_preferences.dart';
import 'package:flutter_iflowsoft/src/util/widget/dialog/error_dialog.dart';
import 'package:flutter_iflowsoft/src/util/widget/dialog/pending_dialog.dart';
import 'package:flutter_iflowsoft/src/util/widget/text/text_style_show.dart';
import 'package:get/get.dart' as get_x;
import 'package:get/get_connect/http/src/status/http_status.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';

class ServiceManager {
  final Dio _dio = Dio();

  ServiceManager() {
    _dio
      ..interceptors.add(InterceptorsWrapper(
        onRequest: (options, handler) async {
          if (!(options.path.startsWith("http://") ||
              options.path.startsWith("https://"))) {
            final serviceProviderUrl = await SharedPreference.read(
                SharedPreference.KEY_SERVICE_PROVIDER_URL);
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

          return handler.next(options);
        },
        onResponse: (response, handler) async {
          final serviceProviderUrl = await SharedPreference.read(
              SharedPreference.KEY_SERVICE_PROVIDER_URL);
          if (response.requestOptions.baseUrl == serviceProviderUrl) {
            // TODO: รอแก้ Service
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
                    unawaited(get_x.Get.offAllNamed(Routes.loginPage));
                    return handler.resolve(response);
                  }
                }
              }
            }
          }
          return handler.next(response);
        },
        onError: (err, handler) async {
          // If statusCode == 401 then renew token

          // if (err.response?.statusCode == HttpStatus.unauthorized) {
          //   if (!err.requestOptions.path.endsWith("renew-token") &&
          //       !err.requestOptions.path.endsWith("auth")) {
          //     if (await _renewToken()) {
          //       _logger.i("Retrying network request...");
          //       return handler.resolve(await _retry(err.requestOptions));
          //     } else {
          //       unawaited(SharedPreference.clearAll());
          //       unawaited(get_x.Get.offAllNamed(Routes.loginPage));
          //       return handler.reject(err);
          //     }
          //   }
          // }
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
                    request: TokenRequest(
                        grantType: GrantType.renew,
                        clientId: Constant.client_id,
                        clientSecret: Constant.client_secret,
                        deviceToken: await SharedPreference.read(SharedPreference.KEY_FCM_TOKEN) ?? "",
                        refreshToken: refreshToken!),
                  ).toJson(),
                ));

        final response = ApiResponse<TokenResponse>.fromJson(
          json.decode(apiResponse),
          (data) => TokenResponse.fromJson(data),
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

  void _showErrorDialog(String message) {
    if (get_x.Get.isDialogOpen == false) {
      get_x.Get.dialog(const ErrorDialog(), barrierDismissible: false);
    }
  }

  Future<bool> _hasInternet() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return await InternetConnectionChecker().hasConnection;
    }

    return false;
  }

  // TODO : Change error message
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

    // String errorMessage = '';
    //
    // if (e is DioError) {
    //   switch (e.type) {
    //     case DioErrorType.connectTimeout:
    //       // TODO : กำหนด Error message หากหมดเวลาการเชื่อมต่อ
    //       break;
    //     case DioErrorType.response:
    //       // TODO : นำ Message จาก ApiResponse มาแสดง
    //       break;
    //     case DioErrorType.other:
    //       if (e.message == "Connection closed while receiving data") {
    //         // TODO : มีปัญหาการเชื่อมต่อเมื่อกดดาวน์โหลดไฟล์แล้วอยู่ๆเกิดปัญหาการเชื่อมต่อ
    //         // มีปัญหาการเชื่อมต่อเมื่อกดดาวน์โหลดไฟล์แล้วอยู่ๆเกิดปัญหาการเชื่อมต่อ
    //         // HttpException
    //         // Connection closed while receiving data
    //       } else if (e.message.contains("Failed host lookup")) {
    //         // TODO : มีปัญหาการเชื่อมต่อเมื่อเรียก API หรือ Download แต่อุปกรณ์ไม่มีการเชื่อมต่ออินเทอร์เน็ต
    //         // มีปัญหาการเชื่อมต่อเมื่อเรียก API หรือ Download แต่อุปกรณ์ไม่มีการเชื่อมต่ออินเทอร์เน็ต
    //         // SocketException
    //         // SocketException: Failed host lookup: 'anywhere.cdgs.co.th' (OS Error: No address associated with hostname, errno = 7)
    //
    //       } else if (e.message.contains("Software caused connection abort")) {
    //         // TODO : มีปัญหาการเชื่อมต่อเมื่อเรียก API ยังไม่ได้รับ Response แล้วอยู่ๆเกิดปัญหาการเชื่อมต่อ
    //         // มีปัญหาการเชื่อมต่อเมื่อเรียก API ยังไม่ได้รับ Response แล้วอยู่ๆเกิดปัญหาการเชื่อมต่อ
    //         // HttpException
    //         // HttpException: Software caused connection abort, uri = https://anywhere.cdgs.co.th/workTimeAPI/getLeaveEmployee/2022/005833
    //       }
    //       break;
    //     default:
    //     // TODO : Default error message
    //   }
    // } else {
    //   errorMessage = e.message;
    // }

    // if (isErrorDialog) {
    //   _showErrorDialog(errorMessage);
    // }

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
          // TODO: รอแก้ Service
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

  Future<void> _attachIpAddressToRequestBody(
      RequestConfig requestConfig) async {
    var ipAddress;
    final ipAddressRes = await _dio.request(
      Constant.ipify,
      options: Options(method: HttpMethod.GET.name),
    );

    if (ipAddressRes.statusCode == HttpStatus.ok) {
      ipAddress = ipAddressFromJson(json.encode(ipAddressRes.data)).ip;
    }

    final request = requestConfig.data!["request"] as Map<String, dynamic>;
    request.addAll({"ip_address": ipAddress});
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

      // TODO: แก้ไข Pending dialog
      unawaited(get_x.Get.dialog(
        WillPopScope(
          onWillPop: () {
            return Future.value(false);
          },
          child: Dialog(
            insetPadding: const EdgeInsets.symmetric(horizontal: 100),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            child: Container(
              width: 198,
              height: 146,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Lottie.asset(Assets.progress, width: 120, height: 120),
                  Positioned(
                    bottom: 16,
                    child: ValueListenableBuilder(
                      valueListenable: loadingStatus,
                      builder:
                          (BuildContext context, String value, Widget? child) {
                        return Container(
                          margin: const EdgeInsets.only(left: 7),
                          child: TextStyleShow(
                            text: value,
                            color: ColorAssets.brightNavyBlue,
                            languageType: LanguageType.bold,
                            languageSize: LanguageSize.size18,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
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
}