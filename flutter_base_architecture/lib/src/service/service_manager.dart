import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_architecture/src/config/app_route.dart';
import 'package:flutter_architecture/src/config/service_locator.dart';
import 'package:flutter_architecture/src/constants/constants.dart';
import 'package:flutter_architecture/src/model/authentication_request.dart';
import 'package:flutter_architecture/src/model/authentication_response.dart';
import 'package:flutter_architecture/src/model/lov_response.dart';
import 'package:flutter_architecture/src/widget/progress_dialog.dart';
import 'package:logger/logger.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ServiceManager {

  static final Dio _dio = Dio()
    ..interceptors.add(InterceptorsWrapper(
      onRequest: (RequestOptions options) async {
        final _logger = Logger();
        showDialog(context: locator<NavigationService>().context, builder: (context) => ProgressDialog(
          progress: Lottie.asset("assets/loading.json"),
          decoration: BoxDecoration(
              color: Colors.transparent
          ),
        ));
        options.baseUrl = Constants.API_BASE;
        options.connectTimeout = 5000;
        options.receiveTimeout = 3000;
        if (options.path.endsWith("auth")) {
        } else {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          var token = prefs.getString(Constants.PREF_KEY_ACCESS_TOKEN);
          options.headers[Constants.HEADER_AUTHORIZATION] =
              "${Constants.HEADER_BEARER}$token";
        }
        _logger.i(options.baseUrl);
        _logger.i(options.path);
        return options;
      },
      onResponse: (Response response) async {
        final _logger = Logger();
        _logger.i(response.statusCode);
        Navigator.of(locator<NavigationService>().context).pop();
        return response;
      },
      onError: (DioError err) async {
        final _logger = Logger();
        _logger.e(err.message);
        Navigator.of(locator<NavigationService>().context).pop();
        if (err.response?.statusCode == Constants.HTTP_UNAUTHORIZED) {
          if (!err.request.path.endsWith("renew-token") && !err.request.path.endsWith("auth")) {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            var data = authenticationRequestToJson(AuthenticationRequest(
                request: Request(
                    refreshToken:
                        prefs.getString(Constants.PREF_KEY_REFRESH_TOKEN))));
            Response response = await _dio.post("auth/renew-token", data: data);
            await prefs.setString(
                Constants.PREF_KEY_ACCESS_TOKEN,
                authenticationResponseFromJson(json.encode(response.data))
                    .result
                    .accessToken);
            RequestOptions options = err.response.request;
            options.headers.update(Constants.HEADER_AUTHORIZATION,
                (value) => prefs.getString(Constants.PREF_KEY_ACCESS_TOKEN));
            return _dio.request(options.path, options: options);
          } else if (err.request.path.endsWith("renew-token")) {
            locator<NavigationService>().navigateToUtil(AppRoute.loginRoute);
            return err;
          }
        }
        return err;
      },
    ));

  Future<dynamic> get(String path, {Map<String, dynamic> queryParameter}) async {
    dynamic responseJson;
    try {
      final response = await _dio.get(path, queryParameters: queryParameter);
      if(response.statusCode == Constants.HTTP_OK){
        responseJson = json.encode(response.data);
      }
    } on Exception {
      throw Exception('Network failed');
    }
    return responseJson;
  }

  Future<dynamic> post(String path, {dynamic data}) async {
    dynamic responseJson;
    try {
      final response = await _dio.post(path, data: data);
      if(response.statusCode == Constants.HTTP_OK){
        responseJson = json.encode(response.data);
      }
    } on Exception {
      throw Exception('Network failed');
    }
    return responseJson;
  }
}
