import 'package:flutter_starter/src/core/remote/entity/api_response.dart';
import 'package:flutter_starter/src/data/entity/authentication.dart';
import 'package:get/get.dart';

abstract class Repository extends GetxService{

  Future<String?> getPublicIpAddress();
  Future<ApiResult<Authentication>?> auth(Authentication authRequest);
}