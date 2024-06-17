import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_biometric_checker/flutter_biometric_checker.dart';
import 'package:flutter_starter/src/util/widget/passcode_and_biometric/enum/passcode_mode_enum.dart';
import 'package:flutter_starter/src/util/widget/passcode_and_biometric/screen/biometric_screen.dart';
import 'package:flutter_starter/src/util/widget/passcode_and_biometric/security_util.dart';
import 'package:flutter_starter/src/util/widget/passcode_and_biometric/widget/circle.dart';
import 'package:flutter_starter/src/util/widget/passcode_and_biometric/widget/keyboard.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';

/// Installation
/// Package requirement : local_auth, app_settings

@immutable
class PasscodeScreenConfig {
  final int passwordDigits;
  final PasscodeModeEnum passcodeMode;

  /// If the user enters a valid passcode, it will redirect the user to a specific route.
  final String mainFlowRedirectRouteName;

  /// If the user forgets the passcode, we need to redirect the user to a specific route.
  final String logoutRedirectRouteName;

  /// Before changing the passcode, you must first log in.
  /// [securitySettingRouteName] is the routeName after login success.
  final String securitySettingRouteName;

  /// When the user presses the "forget password" button, a callback is triggered.
  final VoidCallback? onForgotPassword;

  const PasscodeScreenConfig({
    required this.passwordDigits,
    required this.passcodeMode,
    required this.mainFlowRedirectRouteName,
    required this.logoutRedirectRouteName,
    required this.securitySettingRouteName,
    this.onForgotPassword,
  });
}

@immutable
class PasscodeScreenStyle {
  final String passcodeValidateLabel;
  final TextStyle? passcodeTextStyle;
  final TextStyle? validateTextStyle;
  final ForgotPasscodeStyle forgotPasscodeStyle;
  final KeyboardUIStyle keyboardUIStyle;
  final CircleUIStyle? circleUIStyle;
  final TextStyle? openAppSettingTextStyle;
  final EdgeInsets circleRowMargin;
  final Widget changePasscodeSuccessDialog;
  final Widget? validateFailedDialog;
  final bool isBackButton;
  final String askConfirmPasscodeLabel;
  final String pleaseSetPinCodeLabel;
  final String pleaseInsertPinCodeLabel;

  const PasscodeScreenStyle({
    this.passcodeValidateLabel = "รหัส PIN ไม่ถูกต้อง",
    this.askConfirmPasscodeLabel = "กรุณายืนยันรหัส PIN",
    this.pleaseSetPinCodeLabel = "กรุณาตั้งรหัส PIN",
    this.pleaseInsertPinCodeLabel = "กรุณาใส่รหัส PIN",
    this.passcodeTextStyle,
    this.validateTextStyle,
    this.forgotPasscodeStyle = const ForgotPasscodeStyle(),
    this.openAppSettingTextStyle,
    this.circleUIStyle,
    this.circleRowMargin = const EdgeInsets.only(top: 20),
    required this.keyboardUIStyle,
    required this.changePasscodeSuccessDialog,
    this.validateFailedDialog,
    this.isBackButton = false,
  });
}

enum ForgotPasscodePosition { aboveKeyboard, belowKeyboard }

@immutable
class ForgotPasscodeStyle {
  final ForgotPasscodePosition? position;
  final String forgotPasscodeLabel;
  final TextStyle? forgotPasscodeTextStyle;

  const ForgotPasscodeStyle({
    this.forgotPasscodeLabel = "ลืมรหัส PIN",
    this.position = ForgotPasscodePosition.aboveKeyboard,
    this.forgotPasscodeTextStyle,
  });
}

class PasscodeScreen extends StatefulWidget {
  const PasscodeScreen({
    Key? key,
    required this.passcodeConfig,
    required this.passcodeScreenStyle,
    this.isBiometricAuth = false,
    this.biometricStyle = const BiometricStyle(),
  })
      : assert(isBiometricAuth == true ? biometricStyle != null : true,
  'biometricStyle is required'),
        super(key: key);

  static const passcodePageModeArg = "passcodePageMode";

  final PasscodeScreenConfig passcodeConfig;

  final PasscodeScreenStyle passcodeScreenStyle;

  /// If set to true, after user created passcode then redirect user to biometric_screen.dart
  /// If set to true, after user has entered passcode_screen.dart as loginWithPasscode mode it will try to login with biometric data first
  final bool isBiometricAuth;

  final BiometricStyle? biometricStyle;

  @override
  _PasscodeScreenState createState() => _PasscodeScreenState();
}

class _PasscodeScreenState extends State<PasscodeScreen>
    with WidgetsBindingObserver {
  late String _passcodeTitle;
  late PasscodeModeEnum _passcodeMode;

  late bool _isValidateFailed = false;
  late String _enteredPasscode = '';
  late String _enteredPasscodePersist = '';
  late bool _isBiometricEnabled = false;
  late BiometricTypeEnum _biometricType = BiometricTypeEnum.none;

  @override
  void initState() {
    super.initState();
    // Register lifecycle
    WidgetsBinding.instance.addObserver(this);

    _initPasscodeMode();
    _initPasscodeTitle();

    if (widget.isBiometricAuth) {
      _checkBiometricSensor().then((value) => {_shouldLoginViaBiometric()});
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setState(() {
        _initPasscodeTitle();

        if (widget.isBiometricAuth) {
          _checkBiometricSensor();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: ((_passcodeMode == PasscodeModeEnum.authChangePasscode) ||
                (_passcodeMode == PasscodeModeEnum.changePasscode) ||
                (_passcodeMode == PasscodeModeEnum.confirmChangePasscode)) &&
                widget.passcodeScreenStyle.isBackButton
                ? AppBar(
              elevation: 0,
              centerTitle: true,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
            )
                : const SizedBox(),
          ),
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _passcodeTitle,
                    style: widget.passcodeScreenStyle.passcodeTextStyle,
                  ),
                  Container(
                    margin: widget.passcodeScreenStyle.circleRowMargin,
                    height: 40,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _buildCircles(
                          circleUIConfig:
                          widget.passcodeScreenStyle.circleUIStyle),
                    ),
                  ),
                  Visibility(
                    visible:
                    widget.passcodeScreenStyle.validateFailedDialog == null,
                    child: _isValidateFailed
                        ? SizedBox(
                      height: 40,
                      child: Text(
                        widget.passcodeScreenStyle.passcodeValidateLabel,
                        style:
                        widget.passcodeScreenStyle.validateTextStyle,
                      ),
                    )
                        : const SizedBox(
                      height: 40,
                    ),
                  ),
                  _buildKeyboardContainer(child: _buildKeyboard()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeyboardContainer({Widget? child}) {
    return Column(
      children: [
        _passcodeMode == PasscodeModeEnum.loginWithPasscode &&
            widget.passcodeScreenStyle.forgotPasscodeStyle.position ==
                ForgotPasscodePosition.aboveKeyboard
            ? _buildForgotPasswordText()
            : const SizedBox(),
        if (child != null) child,
        _passcodeMode == PasscodeModeEnum.loginWithPasscode &&
            widget.passcodeScreenStyle.forgotPasscodeStyle.position ==
                ForgotPasscodePosition.belowKeyboard
            ? _buildForgotPasswordText()
            : const SizedBox(),
      ],
    );
  }

  Widget _buildForgotPasswordText() {
    return Center(
      child: GestureDetector(
        onTap: widget.passcodeConfig.onForgotPassword ?? () {
          _clearStorage();
          Navigator.pushNamedAndRemoveUntil(
            context,
            widget.passcodeConfig.logoutRedirectRouteName,
                (route) => false,
          );
        },
        child: Text(
          widget.passcodeScreenStyle.forgotPasscodeStyle.forgotPasscodeLabel,
          style: widget
              .passcodeScreenStyle.forgotPasscodeStyle.forgotPasscodeTextStyle,
        ),
      ),
    );
  }

  List<Widget> _buildCircles({CircleUIStyle? circleUIConfig}) {
    var list = <Widget>[];
    var config = circleUIConfig ??
        CircleUIStyle(
          borderColor: Theme
              .of(context)
              .primaryColor,
          fillColor: Theme
              .of(context)
              .primaryColor,
        );
    for (int i = 0; i < widget.passcodeConfig.passwordDigits; i++) {
      list.add(
        Container(
          margin: const EdgeInsets.all(8),
          child: Circle(
            filled: i < _enteredPasscode.length,
            circleUIConfig: config,
            extraSize: 0,
          ),
        ),
      );
    }
    return list;
  }

  Widget _buildKeyboard() =>
      Keyboard(
          onKeyboardTap: _updateEnteredPassword,
          keyboardUIConfig: widget.passcodeScreenStyle.keyboardUIStyle.copyWith(
              isShowBiometricButton:
              ((_passcodeMode == PasscodeModeEnum.loginWithPasscode) ||
                  (_passcodeMode == PasscodeModeEnum.authChangePasscode)) &&
                  (_isBiometricEnabled == true) &&
                  (_biometricType != BiometricTypeEnum.none),
              biometricType: _biometricType));

  void _updateEnteredPassword(String text) {
    if (text == Keyboard.deleteButton) {
      _onDeleteCancelButtonPressed();
      return;
    }

    if (text == Keyboard.biometricButton) {
      _onBiometricButtonPressed();
      return;
    }

    if (_enteredPasscode.length < widget.passcodeConfig.passwordDigits) {
      _setEnteredPasscode(_enteredPasscode + text);

      if (_enteredPasscode.length == widget.passcodeConfig.passwordDigits) {
        _validatePasscode();
      }
    }
  }

  void _onDeleteCancelButtonPressed() {
    if (_enteredPasscode.isNotEmpty) {
      setState(() {
        _enteredPasscode =
            _enteredPasscode.substring(0, _enteredPasscode.length - 1);
      });
    }
  }

  void _validatePasscode() {
    if (_passcodeMode == PasscodeModeEnum.createPasscode) {
      Future.delayed(const Duration(milliseconds: 500)).then((value) {
        setState(() {
          _passcodeMode = PasscodeModeEnum.confirmCreatePasscode;
          _enteredPasscodePersist = _enteredPasscode;
          _passcodeTitle = widget.passcodeScreenStyle.askConfirmPasscodeLabel;
          _isValidateFailed = false;
          _enteredPasscode = '';
        });
      });
    } else if (_passcodeMode == PasscodeModeEnum.confirmCreatePasscode) {
      if (_enteredPasscodePersist == _enteredPasscode) {
        Future.delayed(const Duration(milliseconds: 500)).then((value) async {
          setState(() {
            _isValidateFailed = false;
          });
          AndroidOptions _getAndroidOptions() => const AndroidOptions(
            encryptedSharedPreferences: true,
          );
          await FlutterSecureStorage(aOptions: _getAndroidOptions())
              .write(key: kPasscodeValueKey, value: _enteredPasscodePersist);

          if (widget.isBiometricAuth) {
            final auth = LocalAuthentication();

            // ตรวจสอบว่าอุปกรณ์รองรับ biometric หรือไม่
            if (await auth.canCheckBiometrics &&
                await auth.isDeviceSupported()) {
              final availableBiometrics = await auth.getAvailableBiometrics();
              if (availableBiometrics.isNotEmpty &&
                  (availableBiometrics.contains(BiometricType.face) ||
                      availableBiometrics.contains(BiometricType.fingerprint) ||
                      availableBiometrics.contains(BiometricType.strong))) {
                // อุปกรณ์มีการลงทะเบียน Biometric แล้ว นำไปหน้าสอบถามว่าต้องการเปิด Biometric หรือไม่
                if (mounted) {
                  await Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            BiometricScreen(
                              mainFlowRedirectRouteName: widget
                                  .passcodeConfig.mainFlowRedirectRouteName,
                              isEnabledBiometricKey: kIsEnabledBiometricKey,
                            )),
                  );

                  return;
                }
              }
            }
          }
          // อุปกรณ์ยังไม่มีการลงทะเบียน Biometric ให้นำ User ไปหน้าหลักการทำงานได้เลย
          if (mounted) {
            await Navigator.pushReplacementNamed(
                context, widget.passcodeConfig.mainFlowRedirectRouteName);
          }
        });
      } else {
        Future.delayed(const Duration(milliseconds: 500)).then((value) {
          setState(() {
            _showErrorValidation();
          });
        });
      }
    } else if (_passcodeMode == PasscodeModeEnum.loginWithPasscode) {
      Future.delayed(const Duration(milliseconds: 500)).then((value) async {
        AndroidOptions _getAndroidOptions() => const AndroidOptions(
          encryptedSharedPreferences: true,
        );
        final passcode =
        await  FlutterSecureStorage(aOptions: _getAndroidOptions()).read(key: kPasscodeValueKey);

        setState(() {
          if (passcode == _enteredPasscode) {
            _isValidateFailed = false;
            Navigator.pushReplacementNamed(
                context, widget.passcodeConfig.mainFlowRedirectRouteName);
          } else {
            _showErrorValidation();
          }
        });
      });
    } else if (_passcodeMode == PasscodeModeEnum.authChangePasscode) {
      Future.delayed(const Duration(milliseconds: 500)).then((value) async {
        AndroidOptions _getAndroidOptions() => const AndroidOptions(
          encryptedSharedPreferences: true,
        );
        final passcode =
        await  FlutterSecureStorage(aOptions:_getAndroidOptions()).read(key: kPasscodeValueKey);

        setState(() {
          if (passcode == _enteredPasscode) {
            _isValidateFailed = false;
            if (mounted) {
              Navigator.pushReplacementNamed(
                  context, widget.passcodeConfig.securitySettingRouteName);
            }
          } else {
            _showErrorValidation();
          }
        });
      });
    } else if (_passcodeMode == PasscodeModeEnum.changePasscode) {
      Future.delayed(const Duration(milliseconds: 500)).then((value) {
        setState(() {
          _passcodeMode = PasscodeModeEnum.confirmChangePasscode;
          _enteredPasscodePersist = _enteredPasscode;
          _passcodeTitle = widget.passcodeScreenStyle.askConfirmPasscodeLabel;
          _isValidateFailed = false;
          _enteredPasscode = '';
        });
      });
    } else if (_passcodeMode == PasscodeModeEnum.confirmChangePasscode) {
      if (_enteredPasscodePersist == _enteredPasscode) {
        Future.delayed(const Duration(milliseconds: 500)).then((value) async {
          setState(() {
            _isValidateFailed = false;
          });
          AndroidOptions _getAndroidOptions() => const AndroidOptions(
            encryptedSharedPreferences: true,
          );

          await  FlutterSecureStorage(aOptions:_getAndroidOptions())
              .write(key: kPasscodeValueKey, value: _enteredPasscodePersist);

          await showDialog(
              context: context,
              builder: (ctx) {
                return widget.passcodeScreenStyle.changePasscodeSuccessDialog;
              });

          Navigator.of(context).pop();
        });
      } else {
        Future.delayed(const Duration(milliseconds: 500)).then((value) {
          setState(() {
            _showErrorValidation();
          });
        });
      }
    }
  }

  void _initPasscodeMode() {
    _passcodeMode = widget.passcodeConfig.passcodeMode;
  }

  void _initPasscodeTitle() {
    if (_passcodeMode == PasscodeModeEnum.createPasscode ||
        _passcodeMode == PasscodeModeEnum.changePasscode) {
      _passcodeTitle = widget.passcodeScreenStyle.pleaseSetPinCodeLabel;
    } else if (_passcodeMode == PasscodeModeEnum.confirmChangePasscode ||
        _passcodeMode == PasscodeModeEnum.confirmCreatePasscode) {
      _passcodeTitle = widget.passcodeScreenStyle.askConfirmPasscodeLabel;
    } else {
      _passcodeTitle = widget.passcodeScreenStyle.pleaseInsertPinCodeLabel;
    }
  }

  Future<void> _checkBiometricSensor() async {
    final auth = LocalAuthentication();
    if (await auth.canCheckBiometrics && await auth.isDeviceSupported()) {
      final availableBiometrics = await auth.getAvailableBiometrics();
      if (availableBiometrics.contains(BiometricType.fingerprint) ||
          availableBiometrics.contains(BiometricType.strong) ||
          availableBiometrics.contains(BiometricType.weak)) {
        if (Platform.isAndroid) {
          if (await FlutterBiometricChecker().isFingerprintAvailable() ==
              true) {
            _biometricType = BiometricTypeEnum.fingerprint;
          } else {
            _biometricType = BiometricTypeEnum.faceScan;
          }
        } else if (Platform.isIOS) {
          _biometricType = BiometricTypeEnum.fingerprint;
        }
      } else if (availableBiometrics.contains(BiometricType.face)) {
        _biometricType = BiometricTypeEnum.faceScan;
      } else {
        _biometricType = BiometricTypeEnum.none;
      }
    } else {
      _biometricType = BiometricTypeEnum.none;
    }

    setState(() {});
  }

  void _shouldLoginViaBiometric() async {
    AndroidOptions _getAndroidOptions() => const AndroidOptions(
      encryptedSharedPreferences: true,
    );
    _isBiometricEnabled = (await  FlutterSecureStorage(aOptions: _getAndroidOptions()).read(
      key: kIsEnabledBiometricKey,
    )) !=
        null;

    setState(() {});

    if ((_passcodeMode == PasscodeModeEnum.loginWithPasscode ||
        _passcodeMode == PasscodeModeEnum.authChangePasscode) &&
        _isBiometricEnabled == true) {
      // Passcode with LoginMode and Biometric is enabled then login via Biometric

      switch (_biometricType) {
        case BiometricTypeEnum.faceScan:
        case BiometricTypeEnum.fingerprint:
          _loginViaBiometric();
          break;
        case BiometricTypeEnum.none:
          _navigateUserToDeviceSetting();
          break;
      }
    }
  }

  void _loginViaBiometric() async {
    final auth = LocalAuthentication();
    try {
      final bool didAuthenticate = await auth.authenticate(
          localizedReason: widget.biometricStyle?.authBiometricReasonLabel ?? "");

      if (didAuthenticate) {
        switch (_passcodeMode) {
          case PasscodeModeEnum.loginWithPasscode:
            {
              if (mounted) {
                await Navigator.pushReplacementNamed(
                    context, widget.passcodeConfig.mainFlowRedirectRouteName);
              }
            }
            break;

          case PasscodeModeEnum.authChangePasscode:
            {
              if (mounted) {
                await Navigator.pushReplacementNamed(
                    context, widget.passcodeConfig.securitySettingRouteName);
              }
            }
            break;
          default:
        }
      }
    } catch (e) {
      if (e is PlatformException) {
        if (kDebugMode) {
          print(e.message);
        }
      }
    }
  }

  void _navigateUserToDeviceSetting() {
    showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
          backgroundColor: Colors.white,
          child: Padding(
            padding:
            const EdgeInsets.only(bottom: 8, left: 20, top: 20, right: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.biometricStyle?.biometricNotFoundLabel ?? "",
                  style: widget.passcodeScreenStyle.openAppSettingTextStyle,
                ),
                const SizedBox(
                  height: 30.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        textStyle:
                        widget.passcodeScreenStyle.openAppSettingTextStyle,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text("ยกเลิก"),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        textStyle:
                        widget.passcodeScreenStyle.openAppSettingTextStyle,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        AppSettings.openAppSettings();
                      },
                      child: const Text('ตั้งค่า'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
      barrierDismissible: false,
    );
  }

  void _onBiometricButtonPressed() {
    _checkBiometricSensor().then((value) => {_shouldLoginViaBiometric()});
  }

  void _setEnteredPasscode(String s) {
    setState(() {
      _enteredPasscode = s;
    });
  }

  void _showErrorValidation() {
    _isValidateFailed = true;
    _enteredPasscode = '';

    if (widget.passcodeScreenStyle.validateFailedDialog != null) {
      showDialog(
        context: context,
        builder: (ctx) {
          return widget.passcodeScreenStyle.validateFailedDialog!;
        },
      );
    }
  }

  void _clearStorage() async {
    AndroidOptions _getAndroidOptions() => const AndroidOptions(
      encryptedSharedPreferences: true,
    );
    var fss = FlutterSecureStorage(aOptions: _getAndroidOptions());
    await Future.wait([
      fss.delete(key: kPasscodeValueKey),
      fss.delete(key: kIsEnabledBiometricKey)
    ]);
  }
}
