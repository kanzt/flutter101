import 'package:flutter/material.dart';
import 'package:flutter_mqtt_plugin_example/src/presentation/login/login_page_controller.dart';
import 'package:flutter_mqtt_plugin_example/src/util/extensions/size_util.dart';
import 'package:get/get.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  final LoginPageController loginPageController =
      Get.put(LoginPageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Welcome Back!",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const Text(
                "Login to continue",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(
                height: 52,
              ),
              TextField(
                controller: loginPageController.username,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'E-mail',
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              TextField(
                controller: loginPageController.password,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Pasword',
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: loginPageController.onLogin,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
