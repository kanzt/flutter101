import 'dart:ffi';

import 'package:flutter_mqtt_plugin_example/src/core/remote/entity/api_response.dart';
import 'package:flutter_mqtt_plugin_example/src/data/entity/login_response.dart';
import 'package:flutter_mqtt_plugin_example/src/data/entity/token_request.dart';
import 'package:flutter_mqtt_plugin_example/src/data/entity/token_response.dart';
import 'package:get/get.dart';

abstract class Repository extends GetxService{
  Future<ApiResponse<LoginResponse>?> login(String email, String password);
  Future<TokenResponse?> token(TokenRequest tokenRequest);
}