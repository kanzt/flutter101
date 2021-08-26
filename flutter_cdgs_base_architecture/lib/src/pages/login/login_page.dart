import 'package:flutter/material.dart';
import 'package:flutter_architecture/src/config/app_route.dart';
import 'package:flutter_architecture/src/constants/constants.dart';
import 'package:flutter_architecture/src/pages/login/login_viewmodel.dart';
import 'package:flutter_architecture/src/widget/custom_text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  LoginViewModel viewModel;

  @override
  void initState() {
    viewModel = LoginViewModel();
    viewModel.usernameController = TextEditingController();
    viewModel.passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    viewModel.usernameController?.dispose();
    viewModel.passwordController?.dispose();
    viewModel = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: new Theme(
            data: new ThemeData(
              primaryColor: Colors.redAccent,
              primaryColorDark: Colors.red,
            ),
            child: Column(
              children: [
                CustomTextField(
                  viewModel.usernameController,
                  labelText: 'Username',
                  hintText: 'Username',
                  fontSize: 20.0,
                  icon: Icons.person,
                  textColor: Colors.green,
                ),
                CustomTextField(
                  viewModel.passwordController,
                  labelText: 'Password',
                  hintText: 'Password',
                  fontSize: 20.0,
                  icon: Icons.lock,
                  textColor: Colors.green,
                  isPassword: true,
                ),
                ElevatedButton(
                  onPressed: () async {
                    FocusScope.of(context).unfocus();
                    final response = await viewModel.auth();
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.setString(
                        Constants.PREF_KEY_ACCESS_TOKEN, response.accessToken);
                    prefs.setString(Constants.PREF_KEY_REFRESH_TOKEN,
                        response.refreshToken);
                    if (response.accessToken.isNotEmpty &&
                        response.refreshToken.isNotEmpty) {
                      Navigator.pushNamed(context, AppRoute.listPage);
                    }
                  },
                  child: Text('Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
