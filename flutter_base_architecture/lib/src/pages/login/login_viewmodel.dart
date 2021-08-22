
import 'package:flutter/material.dart';
import 'package:flutter_architecture/src/model/authentication_response.dart';
import 'package:flutter_architecture/src/repository/repository.dart';

class LoginViewModel{
  final _repository = Repository();

  TextEditingController usernameController;
  TextEditingController passwordController;

  Future<AuthenticationResult> auth() {
    final username = usernameController.text ?? "chantiki";
    final password = passwordController.text ?? "Wood*1475428";
    return  _repository.auth("chantiki", "Wood*1475428");
  }
}