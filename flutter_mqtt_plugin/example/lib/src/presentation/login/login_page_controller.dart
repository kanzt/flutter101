import 'package:flutter/material.dart';
import 'package:flutter_mqtt_plugin_example/src/core/config/routes.dart';
import 'package:flutter_mqtt_plugin_example/src/core/repository/repository.dart';
import 'package:flutter_mqtt_plugin_example/src/data/entity/token_request.dart';
import 'package:flutter_mqtt_plugin_example/src/util/shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

class LoginPageController extends GetxController {
  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();
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
          final token = await SharedPreference.read(SharedPreference.KEY_TOKEN);
          await SharedPreference.write(
              SharedPreference.KEY_USER_ID, loginRes.result!.userId);
          final tokenRes = await _repository.token(
            TokenRequest(
                token: token!,
                userId: loginRes.result!.userId,
                platform: "iOS"),
          );

          if (tokenRes?.result == true) {
            Get.offAllNamed(Routes.consumerPage);
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
}
