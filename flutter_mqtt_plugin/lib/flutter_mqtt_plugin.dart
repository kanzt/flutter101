
import 'flutter_mqtt_plugin_platform_interface.dart';

class FlutterMqttPlugin {
  Future<String?> getPlatformVersion() {
    return FlutterMqttPluginPlatform.instance.getPlatformVersion();
  }

  Stream<String?> getToken() {
    return FlutterMqttPluginPlatform.instance.getToken();
  }

  Stream<String?> onReceivedNotification() {
    return FlutterMqttPluginPlatform.instance.onReceivedNotification();
  }

  Stream<String?> onOpenedNotification() {
    return FlutterMqttPluginPlatform.instance.onOpenedNotification();
  }
}
