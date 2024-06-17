import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_biometric_checker/flutter_biometric_checker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_starter/src/resource/color/color_assets.dart';
import 'package:flutter_starter/src/resource/language/language_size.dart';
import 'package:flutter_starter/src/resource/language/language_type.dart';
import 'package:flutter_starter/src/util/widget/component/rounded_button.dart';
import 'package:flutter_starter/src/util/widget/passcode_and_biometric/assets/assets.dart';
import 'package:flutter_starter/src/util/widget/passcode_and_biometric/security_util.dart';
import 'package:flutter_starter/src/util/widget/text/text_style_show.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:local_auth/local_auth.dart';

@immutable
class BiometricStyle {
  final String askFaceScanMessage;
  final String askFingerprintMessage;
  final String allowButtonLabel;
  final String askFaceScanAsset;
  final String askFingerprintAsset;
  final String skipLabel;
  final String biometricNotFoundLabel;
  final String authBiometricReasonLabel;

  const BiometricStyle({
    this.askFaceScanMessage =
        'ขออนุญาตเข้าถึงข้อมูล\nการใช้งานระบบสแกนใบหน้า (Face ID)\nที่ท่านได้ทำการบันทึกไว้บนอุปกรณ์นี้\nเพื่อความสะดวกในการเข้าใข้งาน\nแอพพลิเคชั่น\nสารบรรณอิเล็กทรอนิกส์',
    this.askFingerprintMessage =
        'ขออนุญาตเข้าถึงข้อมูล\nการใช้งานระบบสแกนลายนิ้วมือ (Touch ID)\nที่ท่านได้ทำการบันทึก ไว้บนอุปกรณ์นี้\nเพื่อความสะดวกในการเข้าใข้งาน\nแอพพลิเคชั่น\nสารบรรณอิเล็กทรอนิกส์',
    this.biometricNotFoundLabel = "ไม่พบการตั้งค่าข้อมูลไบโอเมตริกซ์, กรุณาเพิ่มข้อมูลไบโอเมตริกซ์ในหน้าการตั้งค่า เพื่อใช้งานการให้สิทธิ์นี้",
    this.authBiometricReasonLabel = "พิสูจน์ตัวตนเพื่อเข้าสู่ระบบ",
    this.askFaceScanAsset = PasscodeAssets.askFaceScan,
    this.askFingerprintAsset = PasscodeAssets.askFingerprint,
    this.allowButtonLabel = 'อนุญาตเข้าถึงข้อมูล',
    this.skipLabel = 'ข้ามขั้นตอนนี้',
  });
}

class BiometricScreen extends StatefulWidget {
  const BiometricScreen({
    Key? key,
    required this.isEnabledBiometricKey,
    required this.mainFlowRedirectRouteName,
    this.biometricStyle = const BiometricStyle(),
  }) : super(key: key);

  final String isEnabledBiometricKey;
  final String mainFlowRedirectRouteName;
  final BiometricStyle biometricStyle;

  @override
  _BiometricScreenState createState() => _BiometricScreenState();
}

class _BiometricScreenState extends State<BiometricScreen> {
  String _biometricSensorText = '';
  String _biometricSensorImage = '';

  @override
  void initState() {
    super.initState();
    _checkBiometricSensor();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: double.infinity,
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _biometricSensorImage.isNotEmpty
                  ? SvgPicture.asset(
                      _biometricSensorImage,
                      width: 141,
                      height: 141,
                    )
                  : const SizedBox(),
              const SizedBox(
                height: 19,
              ),
              TextStyleShow(
                text: _biometricSensorText,
                textAlign: TextAlign.center,
                languageSize: LanguageSize.size18,
                languageType: LanguageType.regular,
              ),
              const SizedBox(
                height: 39,
              ),
              RoundedButton(
                buttonLabel: widget.biometricStyle.allowButtonLabel,
                width: 327,
                height: 48,
                onPressed: () => {_allowBiometric()},
              ),
              const SizedBox(
                height: 19,
              ),
              GestureDetector(
                onTap: () {
                  AndroidOptions _getAndroidOptions() => const AndroidOptions(
                    encryptedSharedPreferences: true,
                  );
                  FlutterSecureStorage(aOptions: _getAndroidOptions())
                      .delete(key: widget.isEnabledBiometricKey);
                  Navigator.pushReplacementNamed(
                      context, widget.mainFlowRedirectRouteName);
                },
                child: TextStyleShow(
                  text: widget.biometricStyle.skipLabel,
                  languageSize: LanguageSize.size16,
                  languageType: LanguageType.regular,
                  color: ColorAssets.mangoOrange,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _checkBiometricSensor() async {
    final auth = LocalAuthentication();

    if (await auth.canCheckBiometrics && await auth.isDeviceSupported()) {
      final availableBiometrics = await auth.getAvailableBiometrics();
      if (availableBiometrics.isNotEmpty) {
        if (availableBiometrics.contains(BiometricType.fingerprint)) {
          displayFingerprint();
        } else if (availableBiometrics.contains(BiometricType.face)) {
          displayFaceScan();
        } else if (availableBiometrics.contains(BiometricType.strong) ||
            availableBiometrics.contains(BiometricType.weak)) {
          if (Platform.isAndroid) {
            if (await FlutterBiometricChecker().isFingerprintAvailable() ==
                true) {
              displayFingerprint();
            } else {
              displayFaceScan();
            }
          }
        }
      } else {
        throw Exception("Biometric not available");
      }
    } else {
      throw Exception("Biometric not available");
    }
  }

  void _allowBiometric() async {
    SecurityUtil.authViaBiometric(positiveCallback: () async {
      AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );
      await  FlutterSecureStorage(aOptions:_getAndroidOptions() )
          .write(key: widget.isEnabledBiometricKey, value: "true");

      if (mounted) {
        await Navigator.pushReplacementNamed(
            context, widget.mainFlowRedirectRouteName);
      }
    }, negativeCallback: () async {
      AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );
      await  FlutterSecureStorage(aOptions:_getAndroidOptions() )
          .delete(key: widget.isEnabledBiometricKey);
    });
  }

  void displayFaceScan() {
    setState(() {
      _biometricSensorText = widget.biometricStyle.askFaceScanMessage;

      _biometricSensorImage = widget.biometricStyle.askFaceScanAsset;
    });
  }

  void displayFingerprint() {
    setState(() {
      _biometricSensorText = widget.biometricStyle.askFingerprintMessage;

      _biometricSensorImage = widget.biometricStyle.askFingerprintAsset;
    });
  }
}
