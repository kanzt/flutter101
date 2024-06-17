import 'package:flutter/material.dart';
import 'package:flutter_starter/src/resource/assets/assets.dart';
import 'package:lottie/lottie.dart';

class PendingDialog extends StatelessWidget {
  const PendingDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Container(

        height: 50,
        padding: const EdgeInsets.all(130),
        child: Lottie.asset(Assets.loadingLottie),
      ),
      onWillPop: () {
        return Future(() {
          return false;
        });
      },
    );
  }
}
