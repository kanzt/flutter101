
import 'package:flutter_mqtt_example/src/core/remote/entity/api_response.dart';
import 'package:flutter_mqtt_example/src/data/entity/bool_response.dart';
import 'package:flutter_mqtt_example/src/data/entity/login_response.dart';
import 'package:flutter_mqtt_example/src/data/entity/logout_request.dart';
import 'package:flutter_mqtt_example/src/data/entity/token_request.dart';
import 'package:get/get.dart';

abstract class Repository extends GetxService{
  Future<ApiResponse<LoginResponse>?> login(String email, String password);
  Future<BoolResponse?> token(TokenRequest tokenRequest);
  Future<BoolResponse?> logout(LogoutRequest logoutRequest);
}