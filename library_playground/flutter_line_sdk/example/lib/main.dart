import 'package:flutter/material.dart';
import 'package:flutter_line_sdk/flutter_line_sdk.dart';

import 'src/app.dart';

const CHANNEL_ID = "Mobile login";

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  LineSDK.instance.setup(CHANNEL_ID).then((_) {
    print('LineSDK Prepared');
  });
  runApp(App());
}
