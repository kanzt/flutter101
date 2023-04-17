package th.co.cdgs.flutter_mqtt_plugin

import android.Manifest
import android.app.Activity
import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.graphics.Color
import android.os.Build
import android.util.Log
import android.widget.Toast
import androidx.activity.result.ActivityResultLauncher
import androidx.activity.result.contract.ActivityResultContracts
import androidx.annotation.NonNull
import androidx.core.content.ContextCompat
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry
import th.co.cdgs.flutter_mqtt_plugin.entity.Config
import th.co.cdgs.flutter_mqtt_plugin.service.DetectTaskRemoveService
import th.co.cdgs.flutter_mqtt_plugin.util.WorkManagerRequestUtil

const val tokenChannelName = "th.co.cdgs.flutter_mqtt_plugin/token";
const val messageChannelName = "th.co.cdgs.flutter_mqtt_plugin/onReceivedMessage";
const val openNotificationChannelName = "th.co.cdgs.flutter_mqtt_plugin/onOpenedNotification";
const val initialNotificationChannelName = "th.co.cdgs.flutter_mqtt_plugin/initialNotification";

// PreferenceKeys
const val keyIsAppInTerminatedState = "th.co.cdgs.flutter_mqtt_plugin/is_app_in_terminated_state"
const val keyRecentNotification = "th.co.cdgs.flutter_mqtt_plugin/recent_notification"

/** FlutterMqttPlugin */
class FlutterMqttPlugin : FlutterPlugin, MethodCallHandler, ActivityAware, PluginRegistry.RequestPermissionsResultListener {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private lateinit var applicationContext: Context
    private var activity: Activity? = null
    val NOTIFICATION_PERMISSION_REQUEST_CODE = 36

    // Streaming data from Native side
    companion object {
        private val TAG = FlutterMqttPlugin::class.java.simpleName
        var onTokenUpdateEventSink: EventChannel.EventSink? = null
        var onReceivedNotificationEventSink: EventChannel.EventSink? = null
        var onOpenedNotificationEventSink: EventChannel.EventSink? = null
        var config: Config? = null
    }

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_mqtt_plugin")
        applicationContext = flutterPluginBinding.applicationContext

        val tokenUpdateEventChannel =
            EventChannel(flutterPluginBinding.binaryMessenger, tokenChannelName)
        val messageEventChannel =
            EventChannel(flutterPluginBinding.binaryMessenger, messageChannelName)
        val openNotificationEventChannel =
            EventChannel(flutterPluginBinding.binaryMessenger, messageChannelName)

        val streamHandler = object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                if ((arguments as String?) == tokenChannelName) {
                    onTokenUpdateEventSink = events
                } else if (arguments == messageChannelName) {
                    onReceivedNotificationEventSink = events
                } else if (arguments == openNotificationChannelName) {
                    onOpenedNotificationEventSink = events
                }
            }

            override fun onCancel(arguments: Any?) {
                if ((arguments as String?) == tokenChannelName) {
                    onTokenUpdateEventSink = null
                } else if (arguments == messageChannelName) {
                    onReceivedNotificationEventSink = null
                } else if (arguments == openNotificationChannelName) {
                    onOpenedNotificationEventSink = null
                }
            }
        }

        tokenUpdateEventChannel.setStreamHandler(streamHandler)
        messageEventChannel.setStreamHandler(streamHandler)
        openNotificationEventChannel.setStreamHandler(streamHandler)

        createNotificationChannel("push_notification", "Push notification")

        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        if (call.method == "connectMQTT") {
            val args = call.arguments as HashMap<*, *>
            val username = args["username"] as String
            val password = args["password"] as String
            val hostname = args["hostname"] as String
            val clientId = args["clientId"] as String
            val topic = args["topic"] as String
            val isRequiredSSL = args["isRequiredSSL"] as Boolean
            val config = Config(
                userName = username,
                password = password,
                hostname = hostname,
                clientId = clientId,
                topic = topic,
                isRequiredSSL = isRequiredSSL
            )
            connectMQTT(config)
        } else {
            result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
        binding.addRequestPermissionsResultListener(this)
        /**
         * Request POST_NOTIFICATION permission for Android 13
         */
        requestPostNotificationPermission()
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
        binding.addRequestPermissionsResultListener(this)
    }

    override fun onDetachedFromActivity() {
        activity = null
    }

    /**
     * Developer
     */
    private fun connectMQTT(config: Config) {
        FlutterMqttPlugin.config = config
        WorkManagerRequestUtil.startPeriodicWorkHiveMQNotificationServiceWorkManager(
            applicationContext
        )
        applicationContext.startService(
            Intent(
                applicationContext,
                DetectTaskRemoveService::class.java
            )
        )
    }

    private fun createNotificationChannel(channelId: String, channelName: String): String {
        val channel: NotificationChannel = NotificationChannel(
            channelId, channelName, NotificationManager.IMPORTANCE_HIGH
        ).also {
            it.lightColor = Color.BLUE
            it.lockscreenVisibility = Notification.VISIBILITY_PRIVATE
        }
        (applicationContext.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager).also {
            it.createNotificationChannel(channel)
        }
        return channelId
    }

    private fun requestPostNotificationPermission() {
        Log.d(TAG, "requestPostNotificationPermission called")
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            if (
                ContextCompat.checkSelfPermission(
                    applicationContext,
                    Manifest.permission.POST_NOTIFICATIONS
                ) != PackageManager.PERMISSION_GRANTED
            ) {
                activity?.requestPermissions(arrayOf(Manifest.permission.POST_NOTIFICATIONS), NOTIFICATION_PERMISSION_REQUEST_CODE)
            }
        }
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ): Boolean {
        if (requestCode == NOTIFICATION_PERMISSION_REQUEST_CODE) {
            if (grantResults.isNotEmpty() && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                // Permission granted, proceed with using the camera
                Toast.makeText(applicationContext, "Notification permission granted", Toast.LENGTH_SHORT).show();
            } else {
                // Permission denied, show a message to the user
                Toast.makeText(applicationContext, "Notification permission denied", Toast.LENGTH_SHORT).show();
            }
        }
        return true
    }
}
