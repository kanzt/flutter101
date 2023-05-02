import 'package:flutter_mqtt_plugin_example/src/core/remote/enum/http_method.dart';
import 'package:flutter_mqtt_plugin_example/src/core/remote/request_config.dart';
import 'package:get/get.dart';

class ServiceApi extends GetxService{
  final login = RequestConfig(HttpMethod.POST, "/auth/login");
  final token = RequestConfig(HttpMethod.POST, "/notification/token");
  final logout = RequestConfig(HttpMethod.POST, "/auth/logout");
}