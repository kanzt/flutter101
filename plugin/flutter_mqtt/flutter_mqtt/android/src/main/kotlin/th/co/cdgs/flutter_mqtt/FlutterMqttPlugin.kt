package th.co.cdgs.flutter_mqtt

import android.Manifest
import android.app.Activity
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import android.util.Log
import android.widget.Toast
import androidx.core.app.NotificationManagerCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugin.common.PluginRegistry.NewIntentListener
import th.co.cdgs.flutter_mqtt.entity.MQTTConnectionSetting
import th.co.cdgs.flutter_mqtt.entity.PlatformNotificationSetting
import th.co.cdgs.flutter_mqtt.service.DetectTaskRemoveService
import th.co.cdgs.flutter_mqtt.util.*
import th.co.cdgs.flutter_mqtt.util.NotificationHelper.CANCEL_NOTIFICATION
import th.co.cdgs.flutter_mqtt.util.NotificationHelper.NOTIFICATION_ID
import th.co.cdgs.flutter_mqtt.util.NotificationHelper.SELECT_FOREGROUND_NOTIFICATION_ACTION
import th.co.cdgs.flutter_mqtt.util.NotificationHelper.SELECT_NOTIFICATION
import th.co.cdgs.flutter_mqtt.util.NotificationHelper.extractNotificationResponseMap
import th.co.cdgs.flutter_mqtt.workmanager.HiveMqttNotificationServiceWorker

/** FlutterMqttPlugin */
class FlutterMqttPlugin : FlutterPlugin, ActivityAware, NewIntentListener, MethodChannel.MethodCallHandler, PluginRegistry.RequestPermissionsResultListener{
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private var mainActivity: Activity? = null
    private lateinit var context: Context

    companion object {
        private val TAG = FlutterMqttPlugin::class.java.simpleName
        private const val NOTIFICATION_PERMISSION_REQUEST_CODE = 36
        var channel: MethodChannel? = null
    }

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        Log.d(TAG, "onAttachedToEngine is working...")
        context = flutterPluginBinding.applicationContext
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "th.co.cdgs/flutter_mqtt")
        channel?.setMethodCallHandler(this)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        Log.d(TAG, "onDetachedFromEngine is working...")
        channel?.setMethodCallHandler(null)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (val extractedCall = Extractor.extractFlutterMqttCallFromRawMethodName(call)) {
            is FlutterMqttCall.Initialize -> {
                initialize(extractedCall, result)
            }
            is FlutterMqttCall.GetNotificationAppLaunchDetails -> {
                getNotificationAppLaunchDetails(result)
            }
            is FlutterMqttCall.CancelAll -> {
                cancelAll(result)
            }
            else -> result.notImplemented()
        }

    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        mainActivity = binding.activity
        binding.addOnNewIntentListener(this)
        binding.addRequestPermissionsResultListener(this)
        SharedPreferenceHelper.setIsTaskRemove(context, false)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        mainActivity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        mainActivity = binding.activity
        binding.addOnNewIntentListener(this)
        binding.addRequestPermissionsResultListener(this)
        SharedPreferenceHelper.setIsTaskRemove(context, false)
    }

    override fun onDetachedFromActivity() {
        mainActivity = null
        SharedPreferenceHelper.setIsTaskRemove(context, true)
    }

    /**
     * Request notification permission result in Android >= 13
     */
    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ): Boolean {
        when (requestCode) {
            NOTIFICATION_PERMISSION_REQUEST_CODE -> {
                return if (grantResults.isNotEmpty() && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                    // Permission granted, proceed with using the camera
                    Toast.makeText(
                        context,
                        "Notification permission granted",
                        Toast.LENGTH_SHORT
                    ).show()
                    startWorker()
                    true
                } else {
                    // Permission denied, show a message to the user
                    Toast.makeText(
                        context,
                        "Notification permission denied",
                        Toast.LENGTH_SHORT
                    ).show()
                    false
                }
            }
        }
        return false
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

    /**
     * Work together with [onNewIntent] function
     */
    private fun sendNotificationPayloadMessage(intent: Intent): Boolean {
        Log.d(TAG, "sendNotificationPayloadMessage is working...")
        if (SELECT_NOTIFICATION == intent.action || SELECT_FOREGROUND_NOTIFICATION_ACTION == intent.action) {
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

            // TODO : แก้ไข onMessageOpenedApp ไม่ทำงานบางครั้ง
            channel?.invokeMethod("onMessageOpenedApp", notificationResponse, object : MethodChannel.Result {
                override fun notImplemented() {
                    Log.d(TAG, "onMessageOpenedApp result : notImplemented")
                }

                override fun error(
                    errorCode: String,
                    errorMessage: String?,
                    errorDetails: Any?
                ) {
                    Log.d(TAG, "onMessageOpenedApp result : error")
                }

                override fun success(receivedResult: Any?) {
                    Log.d(TAG, "onMessageOpenedApp result : success")
                }
            })
            return true
        }
        return false
    }

    /**
     * Initilize MQTT notification
     */
    private fun initialize(convertedCall: FlutterMqttCall.Initialize, result: MethodChannel.Result) {
        Log.d(TAG, convertedCall.platformNotificationSettings.actions.toString())

        // Validation
        if (
            ResourceHelper.hasInvalidIcon(
                context,
                convertedCall.platformNotificationSettings.notificationIcon,
                result
            ) ||
            Validation.hasInvalidMQTTConnectionConfig(
                convertedCall.MQTTConnectionSetting,
                result
            ) ||
            Validation.hasInvalidPlatformNotificationSetting(
                convertedCall.platformNotificationSettings,
                result
            )
        ) {
            return
        }

        // Save configuration
        savePlatformNotificationSetting(convertedCall.platformNotificationSettings)
        saveMQTTConnectionSetting(convertedCall.MQTTConnectionSetting)
        saveCallbackKeys(convertedCall.dispatcherHandle, convertedCall.callbackHandle)

        // Create notification channel
        NotificationHelper.createNotificationChannel(
            context,
            convertedCall.platformNotificationSettings.channelId!!,
            convertedCall.platformNotificationSettings.channelName!!
        )

        // Request notification permission and then start worker
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            if (
                ContextCompat.checkSelfPermission(
                    context,
                    Manifest.permission.POST_NOTIFICATIONS
                ) != PackageManager.PERMISSION_GRANTED
            ) {
                mainActivity?.requestPermissions(
                    arrayOf(Manifest.permission.POST_NOTIFICATIONS),
                    NOTIFICATION_PERMISSION_REQUEST_CODE
                )
            } else {
                startWorker()
            }
        } else {
            startWorker()
        }

        result.success(true)
    }

    /**
     * Work together with [initialize] function
     */
    private fun savePlatformNotificationSetting(platformNotificationSettings: PlatformNotificationSetting) {
        SharedPreferenceHelper.setChannelId(context, platformNotificationSettings.channelId!!)
        SharedPreferenceHelper.setChannelName(context, platformNotificationSettings.channelName!!)
        SharedPreferenceHelper.setAndroidNotificationAction(context, platformNotificationSettings.actions)
    }

    /**
     * Work together with [initialize] function
     */
    private fun saveCallbackKeys(dispatcherHandle: Long?, callbackHandle: Long?) {
        dispatcherHandle?.let {
            SharedPreferenceHelper.setDispatcherHandle(context, it)
        }
        callbackHandle?.let {
            SharedPreferenceHelper.setCallbackHandle(context, it)
        }
    }

    /**
     * Work together with [initialize] function
     */
    private fun saveMQTTConnectionSetting(MQTTConnectionSetting: MQTTConnectionSetting) {
        SharedPreferenceHelper.setHostname(context, MQTTConnectionSetting.hostname!!)
        SharedPreferenceHelper.setUsername(context, MQTTConnectionSetting.userName!!)
        SharedPreferenceHelper.setPassword(context, MQTTConnectionSetting.password!!)
        SharedPreferenceHelper.setTopic(context, MQTTConnectionSetting.topic!!)
        SharedPreferenceHelper.setClientId(context, MQTTConnectionSetting.clientId!!)
        SharedPreferenceHelper.setIsRequiredSSL(context, MQTTConnectionSetting.isRequiredSSL == true)
    }

    /**
     * Work together with [initialize] function
     */
    private fun startWorker() {

        WorkManagerRequestHelper.startPeriodicWorker(
            context,
        )

        context.startService(
            Intent(
                context,
                DetectTaskRemoveService::class.java
            )
        )
    }

    /**
     * To disconnect from MQTT notification server
     */
    private fun cancelAll(result: MethodChannel.Result){
        HiveMqttNotificationServiceWorker.disconnect {
            SharedPreferenceHelper.clearPrefs(context)
            WorkManagerRequestHelper.cancelNotificationWorker(context)
        }

        result.success(true)
    }

    /**
     * Check if user open app via notification
     */
    private fun getNotificationAppLaunchDetails(result: MethodChannel.Result) {
        val notificationAppLaunchDetails: MutableMap<String, Any> = HashMap()
        var notificationLaunchedApp = false
        Log.d(TAG, "getNotificationAppLaunchDetails is working")
        if (mainActivity != null) {
            val launchIntent: Intent? = mainActivity?.intent
            notificationLaunchedApp =
                (launchIntent != null &&
                        (SELECT_NOTIFICATION == launchIntent.action) &&
                        !launchedActivityFromHistory(launchIntent))

            if (notificationLaunchedApp) {
                notificationAppLaunchDetails["notificationResponse"] =
                    extractNotificationResponseMap(
                        launchIntent!!
                    )
            }
        }

        notificationAppLaunchDetails[NotificationHelper.NOTIFICATION_LAUNCHED_APP] = notificationLaunchedApp
        result.success(notificationAppLaunchDetails)
    }

    /**
     * Work together with [getNotificationAppLaunchDetails] function
     */
    private fun launchedActivityFromHistory(intent: Intent?): Boolean {
        return (intent != null
                && intent.flags and Intent.FLAG_ACTIVITY_LAUNCHED_FROM_HISTORY
                == Intent.FLAG_ACTIVITY_LAUNCHED_FROM_HISTORY)
    }
}
