
import 'flutter_mqtt_plugin_platform_interface.dart';

class FlutterMqttPlugin {
  Future<String?> getPlatformVersion() {
    return FlutterMqttPluginPlatform.instance.getPlatformVersion();
  }
}
