
import 'package:flutter_mqtt/flutter_mqtt.dart';

/// Settings for initializing the plugin for each platform.
class InitializationSettings {
  /// Constructs an instance of [InitializationSettings].
  const InitializationSettings({
    this.android,
    this.iOS,
  });

  /// Settings for Android.
  ///
  /// It is nullable, because we don't want to force users to specify settings
  /// for platforms that they don't target.
  final AndroidInitializationSettings? android;

  /// Settings for iOS.
  ///
  /// It is nullable, because we don't want to force users to specify settings
  /// for platforms that they don't target.
  final DarwinInitializationSettings? iOS;
}
