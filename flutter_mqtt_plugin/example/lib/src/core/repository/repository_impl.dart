import 'dart:convert';

import 'package:flutter_mqtt_plugin_example/src/core/remote/entity/api_request.dart';
import 'package:flutter_mqtt_plugin_example/src/core/remote/entity/api_response.dart';
import 'package:flutter_mqtt_plugin_example/src/core/remote/service_api.dart';
import 'package:flutter_mqtt_plugin_example/src/core/remote/service_manager.dart';
import 'package:flutter_mqtt_plugin_example/src/core/repository/repository.dart';
import 'package:flutter_mqtt_plugin_example/src/data/entity/login_request.dart';
import 'package:flutter_mqtt_plugin_example/src/data/entity/login_response.dart';
import 'package:flutter_mqtt_plugin_example/src/data/entity/token_request.dart';
import 'package:flutter_mqtt_plugin_example/src/data/entity/token_response.dart';
import 'package:get/get.dart';

class RepositoryImpl extends Repository {
  final ServiceApi serviceApi;

  RepositoryImpl(this.serviceApi);

  @override
  Future<ApiResponse<LoginResponse>?> login(
      String email, String password) async {
    final dynamic response = await Get.find<ServiceManager>().request(
      serviceApi.login.copyWith(
        data: ApiRequest(
          request: LoginRequest(
            email: email,
            password: password,
          ),
        ).toJson(),
      ),
      isPendingDialog: true,
    );

    if (response != null) {
      return ApiResponse<LoginResponse>.fromJson(
        json.decode(response),
        (data) => LoginResponse.fromJson(data),
      );
    }
    return null;
  }

  @override
  Future<TokenResponse?> token(TokenRequest tokenRequest) async {
    final dynamic response = await Get.find<ServiceManager>().request(
      serviceApi.token.copyWith(
        data: ApiRequest(request: tokenRequest).toJson(),
      ),
      isPendingDialog: true,
    );

    if (response != null) {
      return TokenResponse.fromJson(json.decode(response));
    }
    return null;
  }
}