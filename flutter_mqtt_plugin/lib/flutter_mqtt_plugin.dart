
import 'package:flutter_mqtt_plugin/entity/config.dart';

import 'flutter_mqtt_plugin_platform_interface.dart';

class FlutterMqttPlugin {
  Stream<String?> getToken() {
    return FlutterMqttPluginPlatform.instance.getToken();
  }

  Stream<String?> onReceivedNotification() {
    return FlutterMqttPluginPlatform.instance.onReceivedNotification();
  }

  Stream<String?> onOpenedNotification() {
    return FlutterMqttPluginPlatform.instance.onOpenedNotification();
  }

  Future<String?> getPendingNotification() {
    return FlutterMqttPluginPlatform.instance.getPendingNotification();
  }

  void connectMQTT(Config config) {
     FlutterMqttPluginPlatform.instance.connectMQTT(config);
  }
}
