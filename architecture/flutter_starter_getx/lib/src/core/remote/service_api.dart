import 'package:flutter_starter/src/core/remote/enum/http_method.dart';
import 'package:flutter_starter/src/core/remote/request_config.dart';
import 'package:get/get.dart';

class ServiceApi extends GetxService{
  // final testOk200 = RequestConfig(HttpMethod.GET, "https://run.mocky.io/v3/6dda2d4d-17fc-4dfb-9bac-d6db62018457");
  final testOk200 = RequestConfig(HttpMethod.GET, "https://anywhere.cdgs.co.th/workTimeAPI/getLeaveEmployee/2022/005833");
  final testOk200PNG = RequestConfig(HttpMethod.POST, "http://saraban-flowsoft.cdgs.co.th/archiveTest/rest/api/mobile/settings",data: { "request": {"grant_type":"query_image_signature"}} );
  final testFailed500 = RequestConfig(HttpMethod.GET, "https://run.mocky.io/v3/fc5dced6-e1e8-412d-a689-400f6d2a9094");
  final testFailed401 = RequestConfig(HttpMethod.GET, "https://run.mocky.io/v3/d1cab95e-1ec8-48f5-9520-c3bb63e6c75e");
  // final testDownloadPDF = RequestConfig(HttpMethod.GET, "https://speed.hetzner.de/10GB.bin");
  // final testDownloadPDF = RequestConfig(HttpMethod.GET, "https://research.nhm.org/pdfs/10592/10592.pdf");
  final testDownloadPDF = RequestConfig(HttpMethod.GET, "https://www.africau.edu/images/default/sample.pdf");




  final getPublicIpAddress = RequestConfig(HttpMethod.GET, "https://api64.ipify.org/?format=json");
  final register = RequestConfig(HttpMethod.POST, "/rest/api/mobile/register");
  final serverInfo = RequestConfig(HttpMethod.POST, "/rest/api/mobile/serverInfo");
  final getQRCodeScan = RequestConfig(HttpMethod.POST, "/rest/api/mobile/qrcodescan");
  final token = RequestConfig(HttpMethod.POST, "/rest/api/mobile/token");
  final auth = RequestConfig(HttpMethod.POST, "/rest/api/mobile/oauth2/v2/auth");
  final roleUser = RequestConfig(HttpMethod.POST, "/rest/api/mobile/roleuser");
  final book = RequestConfig(HttpMethod.POST, "/rest/api/mobile/book");
  final settings = RequestConfig(HttpMethod.POST, "/rest/api/mobile/settings");
  final logout = RequestConfig(HttpMethod.POST, "/rest/api/mobile/logout");
  final bookRevision = RequestConfig(HttpMethod.POST, "/rest/api/mobile/bookRevision");

}