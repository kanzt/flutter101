import 'dart:convert';

import 'package:flutter_starter/src/core/remote/entity/api_request.dart';
import 'package:flutter_starter/src/core/remote/entity/api_response.dart';
import 'package:flutter_starter/src/core/remote/service_api.dart';
import 'package:flutter_starter/src/core/remote/service_manager.dart';
import 'package:flutter_starter/src/core/repository/repository.dart';
import 'package:flutter_starter/src/data/entity/authentication.dart';
import 'package:flutter_starter/src/data/entity/ip_address.dart';
import 'package:get/get.dart';

class RepositoryImpl extends Repository {
  final ServiceApi serviceApi;

  RepositoryImpl(this.serviceApi);

  @override
  Future<String?> getPublicIpAddress() async {
    final dynamic response = await Get.find<ServiceManager>().request(
      serviceApi.getPublicIpAddress,
    );
    return ipAddressFromJson(response).ip;
  }

  @override
  Future<ApiResult<Authentication>?> auth(Authentication authRequest) async {
    final dynamic response = await Get.find<ServiceManager>().request(
      serviceApi.auth.copyWith(
        data: ApiRequest(request: authRequest).toJson(),
      ),
      isPendingDialog: true,
      isRequiredIpAddress: true,
    );

    return ApiResponse<Authentication>.fromJson(
      json.decode(response),
      (data) => Authentication.fromJson(data),
    ).response;
  }

}
