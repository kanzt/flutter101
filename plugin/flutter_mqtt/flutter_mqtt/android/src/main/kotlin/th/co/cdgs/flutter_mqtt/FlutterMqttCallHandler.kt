package th.co.cdgs.flutter_mqtt

import android.Manifest
import android.app.Activity
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import android.widget.Toast
import androidx.core.content.ContextCompat
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry
import th.co.cdgs.flutter_mqtt.entity.MQTTConnectionSetting
import th.co.cdgs.flutter_mqtt.entity.PlatformNotificationSetting
import th.co.cdgs.flutter_mqtt.service.DetectTaskRemoveService
import th.co.cdgs.flutter_mqtt.util.Extractor
import th.co.cdgs.flutter_mqtt.util.FlutterMqttCall
import th.co.cdgs.flutter_mqtt.util.NotificationHelper.createNotificationChannel
import th.co.cdgs.flutter_mqtt.util.ResourceHelper.hasInvalidIcon
import th.co.cdgs.flutter_mqtt.util.SharedPreferenceHelper
import th.co.cdgs.flutter_mqtt.util.Validation.hasInvalidMQTTConnectionConfig
import th.co.cdgs.flutter_mqtt.util.Validation.hasInvalidPlatformNotificationSetting
import th.co.cdgs.flutter_mqtt.util.WorkManagerRequestHelper
import th.co.cdgs.flutter_mqtt.workmanager.HiveMqttNotificationServiceWorker

private interface CallHandler<T : FlutterMqttCall> {
    fun handle(context: Context, convertedCall: T, result: MethodChannel.Result)
}

class FlutterMqttCallHandler(private val ctx: Context) : MethodChannel.MethodCallHandler {

    companion object {
        private val TAG = FlutterMqttCallHandler::class.java.simpleName
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (val extractedCall = Extractor.extractFlutterMqttCallFromRawMethodName(call)) {
            is FlutterMqttCall.Initialize -> {
                InitializeHandler().handle(ctx, extractedCall, result)
            }
            is FlutterMqttCall.CancelAll -> {
                CancelAllHandler.handle(ctx, extractedCall, result)
            }
            is FlutterMqttCall.Unknown -> {
                UnknownTaskHandler.handle(ctx, extractedCall, result)
            }
        }

    }
}

private class InitializeHandler : CallHandler<FlutterMqttCall.Initialize>, ActivityAware,
    PluginRegistry.RequestPermissionsResultListener {
    private var activity: Activity? = null
    private lateinit var ctx: Context

    companion object {
        private const val NOTIFICATION_PERMISSION_REQUEST_CODE = 36
    }

    override fun handle(
        context: Context,
        convertedCall: FlutterMqttCall.Initialize,
        result: MethodChannel.Result
    ) {
        if (
            hasInvalidIcon(
                context,
                convertedCall.platformNotificationSettings.notificationIcon,
                result
            ) ||
            hasInvalidMQTTConnectionConfig(convertedCall.MQTTConnectionSetting, result) ||
            hasInvalidPlatformNotificationSetting(
                convertedCall.platformNotificationSettings,
                result
            )
        ) {
            return
        }

        this.ctx = context
        createNotificationChannel(
            context,
            convertedCall.platformNotificationSettings.channelId!!,
            convertedCall.platformNotificationSettings.channelName!!
        )
        savePlatformNotificationSetting(convertedCall.platformNotificationSettings)
        saveMQTTConnectionSetting(convertedCall.MQTTConnectionSetting)
        saveCallbackKeys(convertedCall.dispatcherHandle, convertedCall.callbackHandle)

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            if (
                ContextCompat.checkSelfPermission(
                    context,
                    Manifest.permission.POST_NOTIFICATIONS
                ) != PackageManager.PERMISSION_GRANTED
            ) {
                activity?.requestPermissions(
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

    private fun savePlatformNotificationSetting(platformNotificationSettings: PlatformNotificationSetting) {
        SharedPreferenceHelper.setChannelId(ctx, platformNotificationSettings.channelId!!)
        SharedPreferenceHelper.setChannelName(ctx, platformNotificationSettings.channelName!!)
    }

    private fun saveCallbackKeys(dispatcherHandle: Long?, callbackHandle: Long?) {
        dispatcherHandle?.let {
            SharedPreferenceHelper.setDispatcherHandle(ctx, it)
        }
        callbackHandle?.let {
            SharedPreferenceHelper.setCallbackHandle(ctx, it)
        }
    }

    private fun saveMQTTConnectionSetting(MQTTConnectionSetting: MQTTConnectionSetting) {
        SharedPreferenceHelper.setHostname(ctx, MQTTConnectionSetting.hostname!!)
        SharedPreferenceHelper.setUsername(ctx, MQTTConnectionSetting.userName!!)
        SharedPreferenceHelper.setPassword(ctx, MQTTConnectionSetting.password!!)
        SharedPreferenceHelper.setTopic(ctx, MQTTConnectionSetting.topic!!)
        SharedPreferenceHelper.setClientId(ctx, MQTTConnectionSetting.clientId!!)
        SharedPreferenceHelper.setIsRequiredSSL(ctx, MQTTConnectionSetting.isRequiredSSL == true)
    }

    private fun startWorker() {

        WorkManagerRequestHelper.startPeriodicWorker(
            ctx,
        )

        ctx.startService(
            Intent(
                ctx,
                DetectTaskRemoveService::class.java
            )
        )
    }

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
                        ctx,
                        "Notification permission granted",
                        Toast.LENGTH_SHORT
                    ).show()
                    startWorker()
                    true
                } else {
                    // Permission denied, show a message to the user
                    Toast.makeText(
                        ctx,
                        "Notification permission denied",
                        Toast.LENGTH_SHORT
                    ).show()
                    false
                }
            }
        }
        return false
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
        binding.addRequestPermissionsResultListener(this)
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
}

//private class GetNotificationGetLaunchDetails :
//    CallHandler<FlutterMqttCall.GetNotificationAppLaunchDetails>,
//    ActivityAware {
//
//    private var activity: Activity? = null
//
//    override fun handle(
//        context: Context,
//        convertedCall: FlutterMqttCall.GetNotificationAppLaunchDetails,
//        result: MethodChannel.Result
//    ) {
//        var notificationAppLaunchDetails: Map<String, Any> = hashMapOf()
//        val notificationLaunchedApp: Boolean
//        if (activity != null) {
//            val launchIntent: Intent = activity!!.intent
//            notificationLaunchedApp =
//                launchIntent.action.equals(SELECT_NOTIFICATION) && !launchedActivityFromHistory(
//                    launchIntent
//                )
//            if (notificationLaunchedApp) {
//                // TODO : Attach notification payload copy from FlutterLocalNotificationsPlugin.kt Line 1538
//                notificationAppLaunchDetails = hashMapOf(
//                    "notificationResponse" to ""
//                )
//            }
//        }
//
//        result.success(notificationAppLaunchDetails)
//    }
//
//    private fun launchedActivityFromHistory(intent: Intent?): Boolean {
//        return (intent != null
//                && intent.flags and Intent.FLAG_ACTIVITY_LAUNCHED_FROM_HISTORY
//                == Intent.FLAG_ACTIVITY_LAUNCHED_FROM_HISTORY)
//    }
//
//    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
//        activity = binding.activity
//    }
//
//    override fun onDetachedFromActivityForConfigChanges() {
//        activity = null
//    }
//
//    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
//        activity = binding.activity
//    }
//
//    override fun onDetachedFromActivity() {
//        activity = null
//    }
//
//}

private object CancelAllHandler : CallHandler<FlutterMqttCall.CancelAll> {
    override fun handle(
        context: Context,
        convertedCall: FlutterMqttCall.CancelAll,
        result: MethodChannel.Result
    ) {
        HiveMqttNotificationServiceWorker.disconnect {
            SharedPreferenceHelper.clearPrefs(context)
            WorkManagerRequestHelper.cancelNotificationWorker(context)
        }

        result.success(true)
    }
}

private object UnknownTaskHandler : CallHandler<FlutterMqttCall.Unknown> {
    override fun handle(
        context: Context,
        convertedCall: FlutterMqttCall.Unknown,
        result: MethodChannel.Result
    ) {
        result.notImplemented()
    }
}