import 'package:flutter_workshop/src/core/service_manager/http_method.dart';
import 'package:flutter_workshop/src/core/service_manager/request_config.dart';
import 'package:flutter_workshop/src/core/service_manager/service_manager.dart';
import 'package:get/get.dart';

class Repository{
  final ServiceManager _serviceManager = Get.find<ServiceManager>();

  // Future<List<Product>?> getProductList() async {
  //   dynamic response = await _serviceManager.get('getProductList');
  //
  //   return buildResponse<Product>(
  //       response, (data) => Product.fromJson(data)).results;
  // }

  Future<List<dynamic>> getAll() async {
    dynamic response = await _serviceManager.requests(
      [
        RequestConfig(HttpMethod.GET, "https://anywhere.cdgs.co.th/workTimeAPI/datatable/getsidework/005833"),
        RequestConfig(HttpMethod.GET, "https://anywhere.cdgs.co.th/workTimeAPI/holiday/2022/005833"),
        RequestConfig(HttpMethod.GET, "https://anywhere.cdgs.co.th/workTimeAPI/getLeaveEmployee/2022/005833"),
        RequestConfig(HttpMethod.GET, "https://anywhere.cdgs.co.th/workTimeAPI/getEmployee/005833"),
      ],
      isErrorDialog: true,
      isPendingDialog: true,
    );

    return response;
  }

  Future<dynamic> get() async {
    dynamic response = await _serviceManager.request(
      HttpMethod.GET,
      "https://anywhere.cdgs.co.th/workTimeAPI/datatable/getsidewor/005833",
      // "https://httpstat.us/500",
      isErrorDialog: true,
      isPendingDialog: true,
    );

    return response;
  }
}