import 'package:flutter/material.dart';
import 'package:flutter_starter/src/util/widget/dialog/warning_dialog.dart';

class ErrorDialog extends StatelessWidget {
  const ErrorDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WarningDialog();
  }
}
