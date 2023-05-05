// import 'package:flutter/services.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:flutter_mqtt/src/flutter_mqtt_method_channel.dart';
//
// void main() {
//   MethodChannelFlutterMqtt platform = MethodChannelFlutterMqtt();
//   const MethodChannel channel = MethodChannel('flutter_mqtt');
//
//   TestWidgetsFlutterBinding.ensureInitialized();
//
//   setUp(() {
//     channel.setMockMethodCallHandler((MethodCall methodCall) async {
//       return '42';
//     });
//   });
//
//   tearDown(() {
//     channel.setMockMethodCallHandler(null);
//   });
//
//   test('getPlatformVersion', () async {
//     expect(await platform.getPlatformVersion(), '42');
//   });
// }
