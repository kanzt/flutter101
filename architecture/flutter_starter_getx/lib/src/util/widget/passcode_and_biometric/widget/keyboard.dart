import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_starter/src/util/widget/passcode_and_biometric/assets/assets.dart';
import 'package:flutter_svg/flutter_svg.dart';

typedef KeyboardTapCallback = void Function(String text);

enum BiometricTypeEnum { fingerprint, faceScan, none }

@immutable
class KeyboardUIStyle {
  //Digits have a round thin borders, [digitBorderWidth] define their thickness
  final double digitBorderWidth;
  final Color digitBorderColor;
  final TextStyle digitTextStyle;
  final TextStyle deleteButtonTextStyle;
  final Color digitFillColor;
  final Color? splashColor;
  final Color? highlightColor;
  final bool isShowDeleteButton;
  final bool isShowBiometricButton;
  final BiometricTypeEnum biometricType;

  //Size for the keyboard can be define and provided from the app.
  //If it will not be provided the size will be adjusted to a screen size.
  final Size? keyboardSize;

  const KeyboardUIStyle({
    this.digitBorderWidth = 1,
    this.digitBorderColor = Colors.transparent,
    this.digitFillColor = Colors.transparent,
    this.digitTextStyle = const TextStyle(fontSize: 30, color: Colors.white),
    this.deleteButtonTextStyle =
        const TextStyle(fontSize: 16, color: Colors.white),
    this.keyboardSize,
    this.isShowDeleteButton = true,
    this.isShowBiometricButton = true,
    this.biometricType = BiometricTypeEnum.none,
    this.splashColor,
    this.highlightColor,
  });

  KeyboardUIStyle copyWith(
      {double? digitBorderWidth,
      Color? digitBorderColor,
      TextStyle? digitTextStyle,
      TextStyle? deleteButtonTextStyle,
      Color? digitFillColor,
      Color? splashColor,
      Size? keyboardSize,
      Color? highlightColor,
      bool? isShowDeleteButton,
      bool? isShowBiometricButton,
      BiometricTypeEnum? biometricType}) {
    return KeyboardUIStyle(
      digitBorderWidth: digitBorderWidth ?? this.digitBorderWidth,
      digitBorderColor: digitBorderColor ?? this.digitBorderColor,
      digitTextStyle: digitTextStyle ?? this.digitTextStyle,
      deleteButtonTextStyle:
          deleteButtonTextStyle ?? this.deleteButtonTextStyle,
      digitFillColor: digitFillColor ?? this.digitFillColor,
      isShowDeleteButton: isShowDeleteButton ?? this.isShowDeleteButton,
      isShowBiometricButton:
          isShowBiometricButton ?? this.isShowBiometricButton,
      biometricType: biometricType ?? this.biometricType,
      splashColor: splashColor ?? this.splashColor,
      highlightColor: highlightColor ?? this.highlightColor,
      keyboardSize: keyboardSize ?? this.keyboardSize,
    );
  }
}

class Keyboard extends StatelessWidget {
  final KeyboardUIStyle keyboardUIConfig;
  final KeyboardTapCallback onKeyboardTap;
  final _focusNode = FocusNode();
  static String deleteButton = 'keyboard_delete_button';
  static String biometricButton = 'keyboard_biometric_button';

  //should have a proper order [1...9, 0]
  final List<String>? digits;

  Keyboard({
    Key? key,
    required this.keyboardUIConfig,
    required this.onKeyboardTap,
    this.digits,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => _buildKeyboard(context);

  Widget _buildKeyboard(BuildContext context) {
    List<String> keyboardItems = List.filled(10, '0');
    if (digits == null || digits!.isEmpty) {
      keyboardItems = ['1', '2', '3', '4', '5', '6', '7', '8', '9'];
      if (keyboardUIConfig.isShowBiometricButton &&
          keyboardUIConfig.biometricType != BiometricTypeEnum.none) {
        if (keyboardUIConfig.biometricType == BiometricTypeEnum.fingerprint) {
          keyboardItems.add(PasscodeAssets.fingerprint);
        } else if (keyboardUIConfig.biometricType ==
            BiometricTypeEnum.faceScan) {
          keyboardItems.add(PasscodeAssets.faceScan);
        }
      }

      keyboardItems.add("0");

      if (keyboardUIConfig.isShowDeleteButton) {
        keyboardItems.add(PasscodeAssets.deleteButton);
      }
    } else {
      keyboardItems = digits!;
    }
    final screenSize = MediaQuery.of(context).size;
    final keyboardHeight = screenSize.height > screenSize.width
        ? screenSize.height / 2
        : screenSize.height - 80;
    final keyboardWidth = keyboardHeight * 3 / 4;
    final keyboardSize = keyboardUIConfig.keyboardSize != null
        ? keyboardUIConfig.keyboardSize!
        : Size(keyboardWidth, keyboardHeight);
    return Container(
      width: keyboardSize.width,
      height: keyboardSize.height,
      margin: const EdgeInsets.only(top: 16),
      child: RawKeyboardListener(
        focusNode: _focusNode,
        autofocus: true,
        onKey: (event) {
          if (event is RawKeyUpEvent) {
            if (keyboardItems.contains(event.data.keyLabel)) {
              onKeyboardTap(event.logicalKey.keyLabel);
              return;
            }
            if (event.logicalKey.keyLabel == 'Backspace' ||
                event.logicalKey.keyLabel == 'Delete') {
              onKeyboardTap(Keyboard.deleteButton);
              return;
            }
          }
        },
        child: AlignedGrid(
          keyboardSize: keyboardSize,
          warpAlignment: keyboardUIConfig.isShowDeleteButton &&
                  !keyboardUIConfig.isShowBiometricButton
              ? WrapAlignment.end
              : WrapAlignment.center,
          children: List.generate(keyboardItems.length, (index) {
            return _buildKeyboardDigit(keyboardItems[index]);
          }),
        ),
      ),
    );
  }

  Widget _buildKeyboardDigit(String text) {
    return Container(
      margin: const EdgeInsets.all(8),
      child: ClipOval(
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            splashColor: keyboardUIConfig.splashColor,
            highlightColor: keyboardUIConfig.highlightColor,
            onTap: () {
              if (text == PasscodeAssets.deleteButton) {
                onKeyboardTap(Keyboard.deleteButton);
              } else if (text == PasscodeAssets.faceScan ||
                  text == PasscodeAssets.fingerprint) {
                onKeyboardTap(Keyboard.biometricButton);
              } else {
                onKeyboardTap(text);
              }
            },
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
                border: Border.all(
                    color: keyboardUIConfig.digitBorderColor,
                    width: keyboardUIConfig.digitBorderWidth),
              ),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: keyboardUIConfig.digitFillColor,
                ),
                child: Center(
                  child: text == PasscodeAssets.deleteButton ||
                          text == PasscodeAssets.faceScan ||
                          text == PasscodeAssets.fingerprint
                      ? SvgPicture.asset(
                          text,
                          width: 31,
                          height: 31,
                        )
                      : Text(
                          text,
                          style: keyboardUIConfig.digitTextStyle,
                          semanticsLabel: text,
                        ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AlignedGrid extends StatelessWidget {
  final double runSpacing = 4;
  final double spacing = 4;
  final int listSize;
  final columns = 3;
  final List<Widget> children;
  final Size keyboardSize;
  final WrapAlignment warpAlignment;

  const AlignedGrid(
      {Key? key,
      required this.children,
      required this.keyboardSize,
      required this.warpAlignment})
      : listSize = children.length,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final primarySize = keyboardSize.width > keyboardSize.height
        ? keyboardSize.height
        : keyboardSize.width;
    final itemSize = (primarySize - runSpacing * (columns - 1)) / columns;
    return Wrap(
      runSpacing: runSpacing,
      spacing: spacing,
      alignment: warpAlignment,
      children: children
          .map((item) => SizedBox(
                width: itemSize,
                height: itemSize,
                child: item,
              ))
          .toList(growable: false),
    );
  }
}
