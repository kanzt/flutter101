package th.co.cdgs.flutter_mqtt

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.util.Log
import androidx.core.app.NotificationManagerCompat
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry.NewIntentListener
import th.co.cdgs.flutter_mqtt.util.NotificationHelper.ACTION_ID
import th.co.cdgs.flutter_mqtt.util.NotificationHelper.CANCEL_NOTIFICATION
import th.co.cdgs.flutter_mqtt.util.NotificationHelper.NOTIFICATION_ID
import th.co.cdgs.flutter_mqtt.util.NotificationHelper.NOTIFICATION_PAYLOAD
import th.co.cdgs.flutter_mqtt.util.NotificationHelper.NOTIFICATION_RESPONSE_TYPE
import th.co.cdgs.flutter_mqtt.util.NotificationHelper.SELECT_FOREGROUND_NOTIFICATION_ACTION
import th.co.cdgs.flutter_mqtt.util.NotificationHelper.SELECT_NOTIFICATION
import th.co.cdgs.flutter_mqtt.util.NotificationHelper.extractNotificationResponseMap
import th.co.cdgs.flutter_mqtt.util.SharedPreferenceHelper

/** FlutterMqttPlugin */
class FlutterMqttPlugin : FlutterPlugin, ActivityAware, NewIntentListener {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private var mainActivity: Activity? = null
    private lateinit var context: Context
    private lateinit var flutterMqttCallHandler: FlutterMqttCallHandler
    private lateinit var flutterMqttStreamHandler: FlutterMqttStreamHandler

    companion object {
        private val TAG = FlutterMqttPlugin::class.java.simpleName
        var channel: MethodChannel? = null
    }

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        Log.d(TAG, "onAttachedToEngine is working...")
        flutterMqttCallHandler = FlutterMqttCallHandler(flutterPluginBinding.applicationContext)
        flutterMqttStreamHandler = FlutterMqttStreamHandler(flutterPluginBinding.binaryMessenger)
        context = flutterPluginBinding.applicationContext
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "th.co.cdgs/flutter_mqtt")
        channel?.setMethodCallHandler(flutterMqttCallHandler)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        Log.d(TAG, "onDetachedFromEngine is working...")
        channel?.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        mainActivity = binding.activity
        binding.addOnNewIntentListener(this)
        SharedPreferenceHelper.setIsTaskRemove(context, false)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        mainActivity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        mainActivity = binding.activity
        binding.addOnNewIntentListener(this)
        SharedPreferenceHelper.setIsTaskRemove(context, false)
    }

    override fun onDetachedFromActivity() {
        mainActivity = null
        SharedPreferenceHelper.setIsTaskRemove(context, true)
    }

    /**
     * Get trigger when user tap to open notification in Foreground state & Background state
     */
    override fun onNewIntent(intent: Intent): Boolean {
        Log.d(TAG, "onNewIntent is working...")
        val res = sendNotificationPayloadMessage(intent)
        if (res && mainActivity != null) {
            mainActivity!!.intent = intent
        }
        return res
    }

    private fun sendNotificationPayloadMessage(intent: Intent): Boolean {
        Log.d(TAG, "sendNotificationPayloadMessage is working...")
        if (SELECT_NOTIFICATION == intent.action) {
            val notificationResponse: Map<String, Any?> = extractNotificationResponseMap(intent)
            channel?.invokeMethod("onMessageOpenedApp", notificationResponse)
            return true
        }
        return false
    }
}
