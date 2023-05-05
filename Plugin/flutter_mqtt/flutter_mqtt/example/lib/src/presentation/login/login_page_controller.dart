import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_mqtt_example/src/core/config/routes.dart';
import 'package:flutter_mqtt_example/src/core/repository/repository.dart';
import 'package:flutter_mqtt_example/src/data/entity/token_request.dart';
import 'package:flutter_mqtt_example/src/util/enum/platform.dart';
import 'package:flutter_mqtt_example/src/util/shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class LoginPageController extends GetxController {
  final TextEditingController username = TextEditingController(text: "admin");
  final TextEditingController password =
  TextEditingController(text: "P@ssw0rd");
  final Repository _repository = Get.find();

  void onLogin() async {
    if (username.text.isEmpty || password.text.isEmpty) {
      Get.dialog(
        AlertDialog(
          title: const Text('แจ้งเตือน'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('กรุณาระบุอีเมล์และรหัสผ่าน'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Get.back();
              },
            ),
          ],
        ),
      );
    } else {
      final loginRes = await _repository.login(username.text, password.text);
      if (loginRes != null) {
        if (loginRes.result?.userId.isNotEmpty == true) {
          bool? isSaveTokenSuccess;

          if (Platform.isIOS) {
            isSaveTokenSuccess = await saveTokenIos(loginRes.result!.userId);
          } else if (Platform.isAndroid) {
            isSaveTokenSuccess = await saveTokenAndroid(loginRes.result!.userId);
          }

          if (isSaveTokenSuccess != null) {
            if (isSaveTokenSuccess) {
              Get.offAllNamed(Routes.consumerPage);
            }
          } else {
            throw Exception("Platform is not support");
          }
        } else {
          Get.dialog(
            AlertDialog(
              title: const Text('แจ้งเตือน'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: const <Widget>[
                    Text('อีเมล์หรือรหัสผ่านไม่ถูกต้อง'),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Get.back();
                  },
                ),
              ],
            ),
          );
        }
      }
    }
  }

  @override
  void onClose() {
    username.dispose();
    password.dispose();

    super.onClose();
  }

  Future<bool> saveTokenAndroid(String userId) async {
    // Generate Topic for Android
    final topic = "$userId-${const Uuid().v4()}";
    final request = TokenRequest(
        token: topic, userId: userId, platform: PlatformEnum.Android.value!);

    final tokenRes = await _repository.token(
      request,
    );

    if (tokenRes?.result == true) {
      await SharedPreference.write(SharedPreference.KEY_USER_ID, userId);
      await SharedPreference.write(SharedPreference.KEY_TOKEN, topic);
      await SharedPreference.write(SharedPreference.KEY_CLIENT_ID, topic);
      await SharedPreference.write(
          SharedPreference.KEY_QUEUE_NAME, "mqtt-subscription-${topic}qos1");
    }

    return tokenRes?.result == true;
  }

  Future<bool> saveTokenIos(String userId) async {
    final token = await SharedPreference.read(SharedPreference.KEY_TOKEN);
    final request = TokenRequest(
        token: token!, userId: userId, platform: PlatformEnum.iOS.value!);

    final tokenRes = await _repository.token(
      request,
    );

    if (tokenRes?.result == true) {
      await SharedPreference.write(SharedPreference.KEY_USER_ID, userId);
    }

    return tokenRes?.result == true;
  }
}
