package th.co.cdgs.flutter_mqtt

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.util.Log
import androidx.annotation.NonNull
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

/** FlutterMqttPlugin */
class FlutterMqttPlugin : FlutterPlugin, ActivityAware, NewIntentListener {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private var mainActivity: Activity? = null
    private lateinit var context: Context
    private lateinit var flutterMqttCallHandler: FlutterMqttCallHandler
    private lateinit var flutterMqttStreamHandler: FlutterMqttStreamHandler

    companion object {
        private val TAG = FlutterMqttPlugin::class.java.simpleName
    }

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        flutterMqttCallHandler = FlutterMqttCallHandler(flutterPluginBinding.applicationContext)
        flutterMqttStreamHandler = FlutterMqttStreamHandler(flutterPluginBinding.binaryMessenger)
        context = flutterPluginBinding.applicationContext
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "th.co.cdgs/flutter_mqtt")
        channel.setMethodCallHandler(flutterMqttCallHandler)
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        mainActivity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
        mainActivity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        mainActivity = binding.activity
    }

    override fun onDetachedFromActivity() {
        mainActivity = null
    }

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
            if (SELECT_FOREGROUND_NOTIFICATION_ACTION == intent.action) {
                if (intent.getBooleanExtra(
                        CANCEL_NOTIFICATION,
                        false
                    )
                ) {
                    NotificationManagerCompat.from(context)
                        .cancel(
                            notificationResponse[NOTIFICATION_ID] as Int
                        )
                }
            }
            channel.invokeMethod("didReceiveNotificationResponse", notificationResponse)
            return true
        }
        return false
    }

    private fun extractNotificationResponseMap(intent: Intent): Map<String, Any?> {
        val notificationResponseMap: MutableMap<String, Any?> = HashMap()
        notificationResponseMap[NOTIFICATION_ID] = intent.getIntExtra(NOTIFICATION_ID, 0)
        notificationResponseMap[ACTION_ID] = intent.getStringExtra(ACTION_ID)
        notificationResponseMap[NOTIFICATION_PAYLOAD] = intent.getStringExtra(NOTIFICATION_PAYLOAD)

        if (SELECT_NOTIFICATION == intent.action) {
            notificationResponseMap[NOTIFICATION_RESPONSE_TYPE] = 0
        }
        if (SELECT_FOREGROUND_NOTIFICATION_ACTION == intent.action) {
            notificationResponseMap[NOTIFICATION_RESPONSE_TYPE] = 1
        }
        return notificationResponseMap
    }
}
