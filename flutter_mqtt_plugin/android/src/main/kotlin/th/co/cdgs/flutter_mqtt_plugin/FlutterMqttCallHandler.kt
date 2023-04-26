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
import android.widget.Toast
import androidx.core.content.ContextCompat
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry
import th.co.cdgs.flutter_mqtt_plugin.entity.Connection
import th.co.cdgs.flutter_mqtt_plugin.service.DetectTaskRemoveService
import th.co.cdgs.flutter_mqtt_plugin.util.Extractor
import th.co.cdgs.flutter_mqtt_plugin.util.FlutterMqttCall
import th.co.cdgs.flutter_mqtt_plugin.util.SharedPreferenceHelper
import th.co.cdgs.flutter_mqtt_plugin.util.WorkManagerRequestHelper
import th.co.cdgs.flutter_mqtt_plugin.workmanager.HiveMqttNotificationServiceWorker
import th.co.cdgs.flutter_mqtt_plugin.workmanager.HiveMqttNotificationServiceWorker.Companion.CHANNEL_ID

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
        private const val CHANNEL_NAME = "Push notification"
    }

    override fun handle(
        context: Context,
        convertedCall: FlutterMqttCall.ConnectMqtt,
        result: MethodChannel.Result
    ) {
        this.ctx = context
        createNotificationChannel(context, CHANNEL_ID, CHANNEL_NAME)
        saveConnectionConfiguration(convertedCall.connection)

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

    private fun saveConnectionConfiguration(connection: Connection) {
        SharedPreferenceHelper.setHostname(ctx, connection.hostname)
        SharedPreferenceHelper.setUsername(ctx, connection.userName)
        SharedPreferenceHelper.setPassword(ctx, connection.password)
        SharedPreferenceHelper.setTopic(ctx, connection.topic)
        SharedPreferenceHelper.setClientId(ctx, connection.clientId)
        SharedPreferenceHelper.setIsRequiredSSL(ctx, connection.isRequiredSSL)
    }

    private fun createNotificationChannel(
        context: Context,
        channelId: String,
        channelName: String
    ): String {
        val channel: NotificationChannel = NotificationChannel(
            channelId, channelName, NotificationManager.IMPORTANCE_HIGH
        ).also {
            it.lightColor = Color.BLUE
            it.lockscreenVisibility = Notification.VISIBILITY_PRIVATE
        }
        (context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager).also {
            it.createNotificationChannel(channel)
        }
        return channelId
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

private object DisconnectHandler : CallHandler<FlutterMqttCall.Disconnect> {
    override fun handle(
        context: Context,
        convertedCall: FlutterMqttCall.Disconnect,
        result: MethodChannel.Result
    ) {
        WorkManagerRequestHelper.cancelAllWork(context)
        HiveMqttNotificationServiceWorker.disconnect {
            SharedPreferenceHelper.clearPrefs(context)
        }
        result.success(null)
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