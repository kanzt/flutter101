package th.co.cdgs.flutter_mqtt_plugin

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
import th.co.cdgs.flutter_mqtt_plugin.entity.ConnectionSetting
import th.co.cdgs.flutter_mqtt_plugin.service.DetectTaskRemoveService
import th.co.cdgs.flutter_mqtt_plugin.util.ConnectionHelper.hasInvalidConnectionConfig
import th.co.cdgs.flutter_mqtt_plugin.util.Extractor
import th.co.cdgs.flutter_mqtt_plugin.util.FlutterMqttCall
import th.co.cdgs.flutter_mqtt_plugin.util.NotificationHelper.CHANNEL_ID
import th.co.cdgs.flutter_mqtt_plugin.util.NotificationHelper.CHANNEL_NAME
import th.co.cdgs.flutter_mqtt_plugin.util.NotificationHelper.createNotificationChannel
import th.co.cdgs.flutter_mqtt_plugin.util.ResourceHelper.hasInvalidIcon
import th.co.cdgs.flutter_mqtt_plugin.util.SharedPreferenceHelper
import th.co.cdgs.flutter_mqtt_plugin.util.WorkManagerRequestHelper
import th.co.cdgs.flutter_mqtt_plugin.workmanager.HiveMqttNotificationServiceWorker
import th.co.cdgs.flutter_mqtt_plugin.workmanager.HiveMqttNotificationServiceWorker.Companion.SELECT_NOTIFICATION

private interface CallHandler<T : FlutterMqttCall> {
    fun handle(context: Context, convertedCall: T, result: MethodChannel.Result)
}

class FlutterMqttCallHandler(private val ctx: Context) : MethodChannel.MethodCallHandler {

    companion object {
        private val TAG = FlutterMqttCallHandler::class.java.simpleName
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (val extractedCall = Extractor.extractFlutterMqttCallFromRawMethodName(call)) {
            is FlutterMqttCall.ConnectMqtt -> {
                ConnectMqttHandler().handle(ctx, extractedCall, result)
            }
            is FlutterMqttCall.GetNotificationAppLaunchDetails -> {
                GetNotificationGetLaunchDetails().handle(ctx, extractedCall, result)
            }
            is FlutterMqttCall.Disconnect -> {
                DisconnectHandler.handle(ctx, extractedCall, result)
            }
            is FlutterMqttCall.Unknown -> {
                UnknownTaskHandler.handle(ctx, extractedCall, result)
            }
        }

    }
}

private class ConnectMqttHandler : CallHandler<FlutterMqttCall.ConnectMqtt>, ActivityAware,
    PluginRegistry.RequestPermissionsResultListener {
    private var activity: Activity? = null
    private lateinit var ctx: Context

    companion object {
        private const val NOTIFICATION_PERMISSION_REQUEST_CODE = 36
    }

    override fun handle(
        context: Context,
        convertedCall: FlutterMqttCall.ConnectMqtt,
        result: MethodChannel.Result
    ) {
        // TODO : ทดสอบส่ง Arguments มาไม่ครบ หรือส่ง Empty string มาจะได้ผลลัพธ์อย่างไร
        // TODO : จัดการ createNotificationChannel ใหม่ ตาม Argument ที่ส่งเข้ามา
        if (
            hasInvalidIcon(context, convertedCall.notificationSettings.notificationIcon, result) ||
            hasInvalidConnectionConfig(convertedCall.connectionSetting, result)
        ) {
            return
        }

        this.ctx = context
        createNotificationChannel(context, CHANNEL_ID, CHANNEL_NAME)
        saveConnectionConfiguration(convertedCall.connectionSetting)

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

        result.success(null)
    }


    private fun saveConnectionConfiguration(connectionSetting: ConnectionSetting) {
        SharedPreferenceHelper.setHostname(ctx, connectionSetting.hostname!!)
        SharedPreferenceHelper.setUsername(ctx, connectionSetting.userName!!)
        SharedPreferenceHelper.setPassword(ctx, connectionSetting.password!!)
        SharedPreferenceHelper.setTopic(ctx, connectionSetting.topic!!)
        SharedPreferenceHelper.setClientId(ctx, connectionSetting.clientId!!)
        SharedPreferenceHelper.setIsRequiredSSL(ctx, connectionSetting.isRequiredSSL == true)
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

private class GetNotificationGetLaunchDetails :
    CallHandler<FlutterMqttCall.GetNotificationAppLaunchDetails>,
    ActivityAware {

    private var activity: Activity? = null

    override fun handle(
        context: Context,
        convertedCall: FlutterMqttCall.GetNotificationAppLaunchDetails,
        result: MethodChannel.Result
    ) {
        var notificationAppLaunchDetails: Map<String, Any> = hashMapOf()
        val notificationLaunchedApp: Boolean
        if (activity != null) {
            val launchIntent: Intent = activity!!.intent
            notificationLaunchedApp =
                launchIntent.action.equals(SELECT_NOTIFICATION) && !launchedActivityFromHistory(
                    launchIntent
                )
            if (notificationLaunchedApp) {
                // TODO : Attach notification payload copy from FlutterLocalNotificationsPlugin.kt Line 1538
                notificationAppLaunchDetails = hashMapOf(
                    "notificationResponse" to ""
                )
            }
        }

        result.success(notificationAppLaunchDetails)
    }

    private fun launchedActivityFromHistory(intent: Intent?): Boolean {
        return (intent != null
                && intent.flags and Intent.FLAG_ACTIVITY_LAUNCHED_FROM_HISTORY
                == Intent.FLAG_ACTIVITY_LAUNCHED_FROM_HISTORY)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivity() {
        activity = null
    }

}

private object DisconnectHandler : CallHandler<FlutterMqttCall.Disconnect> {
    override fun handle(
        context: Context,
        convertedCall: FlutterMqttCall.Disconnect,
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