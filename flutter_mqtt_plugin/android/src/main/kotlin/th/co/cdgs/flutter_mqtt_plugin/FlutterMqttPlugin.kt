package th.co.cdgs.flutter_mqtt_plugin

import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodChannel

/** FlutterMqttPlugin */
class FlutterMqttPlugin : FlutterPlugin {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private lateinit var flutterMqttCallHandler: FlutterMqttCallHandler
    private lateinit var flutterMqttStreamHandler: FlutterMqttStreamHandler

    companion object {
        private val TAG = FlutterMqttPlugin::class.java.simpleName
    }

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        flutterMqttCallHandler = FlutterMqttCallHandler(flutterPluginBinding.applicationContext)
        flutterMqttStreamHandler = FlutterMqttStreamHandler(flutterPluginBinding.binaryMessenger)
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_mqtt_plugin")
        channel.setMethodCallHandler(flutterMqttCallHandler)

    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
