import 'dart:async';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';
import 'package:flutter_starter/src/core/repository/repository.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class PlatformUtil {
  static Future<String?> get ipAddress async =>
      Get.find<Repository>().getPublicIpAddress();

  static String get device => Platform.isIOS == true ? "iOS" : "android";

  static Future<bool> iosDevice14ProOrMax() async{
    if(Platform.isIOS == true ){
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      var iosInfo = await deviceInfo.iosInfo;
      return iosInfo.name?.contains('14 P')==true;
    }else{
      return false;
    }
  }

  static void openStore() async {
    final appId =
        Platform.isAndroid ? 'th.co.cdg.mobile.iflowsoft' : '660625874';

    try {
      if (Platform.isAndroid || Platform.isIOS) {
        final url = Uri.parse(
          Platform.isAndroid
              ? "market://details?id=$appId"
              : "https://apps.apple.com/app/id$appId",
        );
        unawaited(launchUrl(
          url,
          mode: LaunchMode.externalApplication,
        ));
      }
    } on PlatformException catch (_) {
      if (Platform.isAndroid) {
        unawaited(launchUrlString(
            "https://play.google.com/store/apps/details?id=$appId"));
      }
      if (Platform.isIOS) {
        unawaited(launchUrlString("https://apps.apple.com/app/id$appId"));
      }
    } finally {
      if (Platform.isAndroid) {
        unawaited(launchUrlString(
            "https://play.google.com/store/apps/details?id=$appId"));
      }
      if (Platform.isIOS) {
        unawaited(launchUrlString("https://apps.apple.com/app/id$appId"));
      }
    }
  }

}
