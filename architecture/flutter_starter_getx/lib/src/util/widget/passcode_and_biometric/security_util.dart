import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_starter/src/util/shared_preferences/shared_preferences.dart';
import 'package:local_auth/local_auth.dart';

/// SharedPreferences To save passcode
const String kPasscodeValueKey = SharedPreference.KEY_PIN_CODE;

/// SharedPreferences To check user has enabled biometric in biometric_screen.dart
const String kIsEnabledBiometricKey = SharedPreference.KEY_BIO_METRIC;

class SecurityUtil {
  static void authViaBiometric({
    VoidCallback? positiveCallback,
    VoidCallback? negativeCallback,
  }) async {
    final auth = LocalAuthentication();
    if (await auth.canCheckBiometrics && await auth.isDeviceSupported()) {
      final availableBiometrics = await auth.getAvailableBiometrics();
      if (availableBiometrics.contains(BiometricType.face) ||
          availableBiometrics.contains(BiometricType.fingerprint) ||
          availableBiometrics.contains(BiometricType.strong) ||
          availableBiometrics.contains(BiometricType.weak)) {
        try {
          // TODO : Change to text from locale
          final bool didAuthenticate = await auth.authenticate(
              localizedReason: 'พิสูจน์ตัวตนเพื่อเปิดใช้งาน');

          if (didAuthenticate) {
            if (positiveCallback != null) {
              positiveCallback();
              return;
            }
          }
        } catch (e) {
          if (e is PlatformException) {
            if (kDebugMode) {
              print(e.message);
            }
          }

          if (negativeCallback != null) {
            negativeCallback();
            return;
          }
        }
      }

      if (negativeCallback != null) {
        negativeCallback();
      }
    }
  }

  static void disabledBiometric() async {
    AndroidOptions _getAndroidOptions() => const AndroidOptions(
      encryptedSharedPreferences: true,
    );
    await FlutterSecureStorage(aOptions: _getAndroidOptions()).delete(key: kIsEnabledBiometricKey);
  }

  static void enabledBiometric() async {
    AndroidOptions _getAndroidOptions() => const AndroidOptions(
      encryptedSharedPreferences: true,
    );
    await FlutterSecureStorage(aOptions: _getAndroidOptions())
        .write(key: kIsEnabledBiometricKey, value: "true");
  }

  static Future<bool> isEnabledBiometric() async {
    AndroidOptions _getAndroidOptions() => const AndroidOptions(
      encryptedSharedPreferences: true,
    );
    return (await FlutterSecureStorage(aOptions: _getAndroidOptions())
            .read(key: kIsEnabledBiometricKey)) ==
        "true";
  }

  static Future<bool> isBiometricAvailable() async {
    final auth = LocalAuthentication();
    final availableBiometrics = await auth.getAvailableBiometrics();
    if (await auth.canCheckBiometrics && await auth.isDeviceSupported()) {
      if (availableBiometrics.isNotEmpty &&
          (availableBiometrics.contains(BiometricType.face) ||
              availableBiometrics.contains(BiometricType.fingerprint) ||
              availableBiometrics.contains(BiometricType.strong))) {
        return true;
      }
    }

    return false;
  }
}
