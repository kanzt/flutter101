import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter101/src/config/app_route.dart';
import 'package:flutter101/src/constants/app_setting.dart';
import 'package:flutter101/src/constants/asset.dart';
import 'package:flutter101/src/pages/login/background_theme.dart';
import 'package:flutter101/src/view_models/sso_viewmodels.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();

  final _passwordController = TextEditingController();

  /// อารมณ์เหมือน onDestroy
  @override
  void dispose() {
    _usernameController?.dispose();
    _passwordController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: BackGroundTheme.gradient
                // gradient: LinearGradient(
                //     colors: [
                //       Color(0XFF36D1Dc),
                //       Color(0XFF5B86E5),
                //     ],
                //     begin: Alignment.topCenter,
                //     end: Alignment.bottomCenter,
                //     stops: [0.0, 1.0])
            ),
          ),
          SingleChildScrollView(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(Asset.logoImage, width: 200),
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Card(
                      margin: EdgeInsets.only(
                          left: 22, top: 22, right: 22, bottom: 24),
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: 22, top: 22, right: 22, bottom: 62),
                        child: Column(
                          children: [
                            TextField(
                              keyboardType: TextInputType.emailAddress,
                              controller: _usernameController,
                              decoration: InputDecoration(
                                  hintText: 'example@gmail.com',
                                  labelText: 'username',
                                  icon: Icon(Icons.person),
                                  border: InputBorder.none),
                            ),
                            Divider(
                              height: 28,
                              indent: 22,
                              endIndent: 22,
                            ),
                            TextField(
                              controller: _passwordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                  labelText: 'password',
                                  icon: Icon(Icons.lock),
                                  border: InputBorder.none),
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      decoration: _boxDecoration(),
                      width: 280,
                      height: 52,
                      child: TextButton(
                          onPressed: () async {
                            final username = _usernameController.text;
                            final password = _passwordController.text;
                            if(username == "user@user.com" && password == "1234"){
                              SharedPreferences prefs = await SharedPreferences.getInstance();
                              var token = "This is token";
                              await prefs.setString(AppSetting.tokenSetting, token);
                              await prefs.setString(AppSetting.usernameString, username);


                              // Navigator.pushNamed(context, AppRoute.homeRoute);
                              /// pushReplacementNamed ทำให้ไม่มีกดปุ่ม Back เมื่อไปยังหน้า HomePage แล้ว
                              Navigator.pushReplacementNamed(context, AppRoute.homeRoute);
                            }
                          },
                          child: Text(
                            'Login',
                            style: TextStyle(
                                color: Colors.white,fontSize: 22, fontWeight: FontWeight.bold),
                          )),
                    )
                  ],
                ),
                _buidTextButton(
                  'Forget Password',
                  onPressed: (){

                  }
                ),
                SSOButton(),
                _buidTextButton(
                    'Register',
                    onPressed: (){

                    }
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// {} เป็นการบอกว่า Parameter นี้ optional
  Container _buidTextButton(String text, {VoidCallback onPressed = null}) {
    return Container(
                child: TextButton(
                  child: Text(
                    text,
                    style: TextStyle(color: Colors.white70),
                  ),
                  onPressed: (){
                    // TODO
                  },
                ),
              );
  }

  BoxDecoration _boxDecoration() {
    final gradientStart = BackGroundTheme().gradientStart;
    final gradientEnd = BackGroundTheme().gradientEnd;

    final boxShadowItem = (Color color) => BoxShadow(
      color: color,
      offset: Offset(1.0, 6.0),
      blurRadius: 20.0,
    );

    return BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(15.0)),
      boxShadow: <BoxShadow>[
        boxShadowItem(gradientStart),
        boxShadowItem(gradientEnd),
      ],
      gradient: LinearGradient(
        colors: [
          gradientEnd,
          gradientStart,
        ],
        begin: const FractionalOffset(0, 0),
        end: const FractionalOffset(1.0, 1.0),
        stops: [0.0, 1.0],
      ),
    );
  }
}

class SSOButton extends StatelessWidget {
  const SSOButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: SSOViewModel().item.map((e) => FloatingActionButton(
          heroTag: e.backgroundColor.toString(),
          onPressed: e.onPressed,
          child: FaIcon(
            e.icon
          ),
          backgroundColor: e.backgroundColor,
        )).toList(),
      ),
    );
  }
}
