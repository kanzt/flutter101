import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingPageController extends GetxController {
  OverlayEntry? overlayEntry;
  final GlobalKey languageButtonKey = GlobalKey();
  bool isLanguageMenuOpened = false;

  late Size buttonSize;
  late Offset buttonPosition;

  void _findLanguageButton() {
    final RenderBox renderBox =
        languageButtonKey.currentContext!.findRenderObject() as RenderBox;
    buttonSize = renderBox.size;
    buttonPosition = renderBox.localToGlobal(Offset.zero);

    update();
  }

  void onMenuOpened(BuildContext ctx, OverlayEntry? overlayEntryBuilder) {
    if(overlayEntryBuilder != null){
      _findLanguageButton();
      overlayEntry = overlayEntryBuilder;
      Overlay.of(ctx)?.insert(overlayEntryBuilder);
      isLanguageMenuOpened = !isLanguageMenuOpened;

      update();
    }
  }

  void onMenuClosed(){
    overlayEntry?.remove();
    overlayEntry = null;
    isLanguageMenuOpened = !isLanguageMenuOpened;

    update();
  }

  void toggleMenu(BuildContext? ctx, OverlayEntry? overlayEntryBuilder) {
    if (isLanguageMenuOpened) {
      onMenuClosed();
    } else {
      onMenuOpened(ctx!, overlayEntryBuilder);
    }
  }

  Future<bool> onWillPop() {
    // if (_isMenuOpen) {
    //   _overlayEntry?.remove();
    //   _isMenuOpen = false;
    //   return Future.value(false);
    // }

    if(isLanguageMenuOpened){
      onMenuClosed();
    }
    return Future.value(true);
  }
}
