import 'package:flutter/foundation.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_workshop/src/core/config/route/routes.dart';
import 'package:flutter_workshop/src/core/constant/shared_preferences_key.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {

  final _appAuth = const FlutterAppAuth();
  final _serviceConfiguration = const AuthorizationServiceConfiguration(
    authorizationEndpoint: 'https://apidcdev.dol.go.th/auth/realms/master/protocol/openid-connect/auth',
    tokenEndpoint: 'https://apidcdev.dol.go.th/auth/realms/master/protocol/openid-connect/token',
    endSessionEndpoint: 'https://apidcdev.dol.go.th/auth/realms/master/protocol/openid-connect/logout',
  );

  // ClientId ที่กำหนดใน Keycloak
  final String _clientId = 'mobile';
  // Redirect หลัง Login
  final String _redirectUrl = 'dolappeal://auth';
  // Redirect หลัง Logout
  final String _postLogoutRedirectUrl = 'dolappeal://auth';
  final List<String> _scopes = <String>[
    'openid', 'email', 'profile'
  ];

  /// Test user : thitima.n
  Future<void> signInWithAutoCodeExchange(
      {bool preferEphemeralSession = false}) async {
    try {

      /// ถ้าเคย Login จะได้ Token กลับมาเลยไม่แสดงหน้า Login ให้ผู้ใช้กรอก User/Pass อีก
      // show that we can also explicitly specify the endpoints rather than getting from the details from the discovery document
      // final AuthorizationTokenResponse? result =
      // await _appAuth.authorizeAndExchangeCode(
      //   AuthorizationTokenRequest(
      //     _clientId,
      //     _redirectUrl,
      //     serviceConfiguration: _serviceConfiguration,
      //     scopes: _scopes,
      //     preferEphemeralSession: preferEphemeralSession,
      //   ),
      // );

      /// แบบนี้จะเป้นการ Force user ไปหน้า Login ถึงแม้ จะเคย Login แล้ว
      // this code block demonstrates passing in values for the prompt parameter. in this case it prompts the user login even if they have already signed in. the list of supported values depends on the identity provider
      final AuthorizationTokenResponse? result = await _appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(_clientId, _redirectUrl,
            serviceConfiguration: _serviceConfiguration,
            scopes: _scopes,
            promptValues: ['login']),
      );

      if (result != null) {
        _processAuthTokenResponse(result);
      }
    } catch (_) {
      // TODO : Do stuff with error
      if (kDebugMode) {
        print(_);
      }
    }
  }

  void _processAuthTokenResponse(AuthorizationTokenResponse result) async {
    final prefs = await SharedPreferences.getInstance();
    if((result.accessToken?.isNotEmpty == true) &&
        (result.refreshToken?.isNotEmpty == true) &&
        (result.idToken?.isNotEmpty == true)) {
      await prefs.setString(SharedPreferenceKey.KEY_ACCESS_TOKEN, result.accessToken!);
      await prefs.setString(SharedPreferenceKey.KEY_REFRESH_TOKEN, result.refreshToken!);
      await prefs.setString(SharedPreferenceKey.KEY_ID_TOKEN, result.idToken!);
      Get.offNamed(Routes.mainPage);
    }
  }

  void endSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? tokenId = prefs.getString(SharedPreferenceKey.KEY_ID_TOKEN);

      if(tokenId?.isNotEmpty == true){
        await _appAuth.endSession(EndSessionRequest(
            idTokenHint: tokenId,
            postLogoutRedirectUrl: _postLogoutRedirectUrl,
            serviceConfiguration: _serviceConfiguration));
      }

      SharedPreferenceKey.clearAll();
      Get.offAllNamed(Routes.loginPage);
    } catch (_) {
      // TODO : do stuff with error
      if (kDebugMode) {
        print(_);
      }
    }
  }

  void bypassLogin(){
    Get.offNamed(Routes.mainPage);
  }
}