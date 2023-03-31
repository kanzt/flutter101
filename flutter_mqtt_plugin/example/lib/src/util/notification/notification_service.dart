import 'package:flutter_mqtt_plugin/flutter_mqtt_plugin.dart';
import 'package:flutter_mqtt_plugin_example/src/util/shared_preferences/shared_preferences.dart';

class NotificationService {
  static final _plugin = FlutterMqttPlugin();

  static Future<void> initialized() async {
    _plugin.getToken().listen((event) {
      SharedPreference.write(
        SharedPreference.KEY_TOKEN,
        event,
      );
    });

    _plugin.onReceivedNotification().listen((event) {

    });

    _plugin.onOpenedNotification().listen((event) {

    });
  }
}
