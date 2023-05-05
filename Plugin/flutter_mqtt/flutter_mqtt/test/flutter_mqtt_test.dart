// import 'package:flutter_test/flutter_test.dart';
// import 'package:flutter_mqtt/flutter_mqtt.dart';
// import 'package:flutter_mqtt/flutter_mqtt_platform_interface.dart';
// import 'package:flutter_mqtt/src/flutter_mqtt_method_channel.dart';
// import 'package:plugin_platform_interface/plugin_platform_interface.dart';
//
// class MockFlutterMqttPlatform
//     with MockPlatformInterfaceMixin
//     implements FlutterMqttPlatform {
//
//   @override
//   Future<String?> getPlatformVersion() => Future.value('42');
// }
//
// void main() {
//   final FlutterMqttPlatform initialPlatform = FlutterMqttPlatform.instance;
//
//   test('$MethodChannelFlutterMqtt is the default instance', () {
//     expect(initialPlatform, isInstanceOf<MethodChannelFlutterMqtt>());
//   });
//
//   test('getPlatformVersion', () async {
//     FlutterMqtt flutterMqttPlugin = FlutterMqtt();
//     MockFlutterMqttPlatform fakePlatform = MockFlutterMqttPlatform();
//     FlutterMqttPlatform.instance = fakePlatform;
//
//     expect(await flutterMqttPlugin.getPlatformVersion(), '42');
//   });
// }
