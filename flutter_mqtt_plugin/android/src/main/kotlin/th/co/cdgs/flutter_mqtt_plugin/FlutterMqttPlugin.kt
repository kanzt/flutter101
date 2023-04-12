package th.co.cdgs.flutter_mqtt_plugin

import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

const val tokenChannelName  = "th.co.cdgs.flutter_mqtt_plugin/token";
const val messageChannelName = "th.co.cdgs.flutter_mqtt_plugin/onReceivedMessage";
const val openNotificationChannelName = "th.co.cdgs.flutter_mqtt_plugin/onOpenedNotification";
const val initialNotificationChannelName = "th.co.cdgs.flutter_mqtt_plugin/initialNotification";

// PreferenceKeys
const val keyIsAppInTerminatedState = "th.co.cdgs.flutter_mqtt_plugin/is_app_in_terminated_state"
const val keyRecentNotification = "th.co.cdgs.flutter_mqtt_plugin/recent_notification"
/** FlutterMqttPlugin */
class FlutterMqttPlugin: FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel

  // Streaming data from Native side
  private var onTokenUpdateEventSink: EventChannel.EventSink? = null
  private var onReceivedNotificationEventSink: EventChannel.EventSink? = null
  private var onOpenedNotificationEventSink: EventChannel.EventSink? = null

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_mqtt_plugin")

    val tokenUpdateEventChannel = EventChannel(flutterPluginBinding.binaryMessenger, tokenChannelName)
    val messageEventChannel = EventChannel(flutterPluginBinding.binaryMessenger, messageChannelName)
    val openNotificationEventChannel = EventChannel(flutterPluginBinding.binaryMessenger, messageChannelName)

    val streamHandler = object : EventChannel.StreamHandler {
      override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        if ((arguments as String?) == tokenChannelName) {
          onTokenUpdateEventSink = events
        }else if (arguments == messageChannelName) {
          onReceivedNotificationEventSink = events
        }else if (arguments == openNotificationChannelName) {
          onOpenedNotificationEventSink = events
        }
      }

      override fun onCancel(arguments: Any?) {
        if ((arguments as String?) == tokenChannelName){
          onTokenUpdateEventSink = null
        }else if (arguments == messageChannelName) {
          onReceivedNotificationEventSink = null
        }else if (arguments == openNotificationChannelName) {
          onOpenedNotificationEventSink = null
        }
      }
    }

    tokenUpdateEventChannel.setStreamHandler(streamHandler)
    messageEventChannel.setStreamHandler(streamHandler)
    openNotificationEventChannel.setStreamHandler(streamHandler)

    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    if (call.method == "getPlatformVersion") {
      result.success("Android ${android.os.Build.VERSION.RELEASE}")
    } else {
      result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}
