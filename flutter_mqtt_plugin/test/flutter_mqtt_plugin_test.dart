import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_mqtt_plugin/flutter_mqtt_plugin.dart';
import 'package:flutter_mqtt_plugin/flutter_mqtt_plugin_platform_interface.dart';
import 'package:flutter_mqtt_plugin/flutter_mqtt_plugin_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterMqttPluginPlatform
    with MockPlatformInterfaceMixin
    implements FlutterMqttPluginPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterMqttPluginPlatform initialPlatform = FlutterMqttPluginPlatform.instance;

  test('$MethodChannelFlutterMqttPlugin is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterMqttPlugin>());
  });

  test('getPlatformVersion', () async {
    FlutterMqttPlugin flutterMqttPlugin = FlutterMqttPlugin();
    MockFlutterMqttPluginPlatform fakePlatform = MockFlutterMqttPluginPlatform();
    FlutterMqttPluginPlatform.instance = fakePlatform;

    expect(await flutterMqttPlugin.getPlatformVersion(), '42');
  });
}
