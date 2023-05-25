package th.co.cdgs.flutter_mqtt

import android.content.Context
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import th.co.cdgs.flutter_mqtt.util.Extractor
import th.co.cdgs.flutter_mqtt.util.FlutterMqttCall
import th.co.cdgs.flutter_mqtt.util.SharedPreferenceHelper

private interface CallHandler<T : FlutterMqttCall> {
    fun handle(context: Context, convertedCall: T, result: MethodChannel.Result)
}

class FlutterMqttBackgroundHandler(
    private val context: Context,
    private val onBackgroundInitialized: (() -> Unit)? = null
) : MethodChannel.MethodCallHandler {

    companion object {
        private val TAG = FlutterMqttBackgroundHandler::class.java.simpleName
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (val extractedCall = Extractor.extractFlutterMqttCallFromRawMethodName(call)) {
            is FlutterMqttCall.GetReceiveBackgroundNotificationCallbackHandle -> {
                getReceiveBackgroundNotificationCallbackHandle(result)
            }

            is FlutterMqttCall.GetTapActionBackgroundNotificationCallbackHandle -> {
                getTapActionBackgroundNotificationCallbackHandle(result)
            }

            is FlutterMqttCall.BackgroundChannelInitialized -> {
                onBackgroundInitialized?.invoke()
            }

            else -> {
                result.notImplemented()
            }
        }

    }

    private fun getReceiveBackgroundNotificationCallbackHandle(result: MethodChannel.Result) {
        val handle: Long =
            SharedPreferenceHelper.getReceiveBackgroundNotificationCallbackHandle(
                context
            )

        if (handle != -1L) {
            result.success(handle)
        } else {
            result.error(
                "receive_background_notification_callback_handle_not_found",
                "The CallbackHandle could not be found. Please make sure it has been set when you initialize plugin",
                null
            )
        }
    }

    private fun getTapActionBackgroundNotificationCallbackHandle(result: MethodChannel.Result) {
        val handle: Long =
            SharedPreferenceHelper.getTapActionBackgroundNotificationCallbackHandle(
                context
            )

        if (handle != -1L) {
            result.success(handle)
        } else {
            result.error(
                "tap_action_background_notification_callback_handle_not_found",
                "The CallbackHandle could not be found. Please make sure it has been set when you initialize plugin",
                null
            )
        }
    }
}

//private class InitializeHandler : CallHandler<FlutterMqttCall.Initialize>, ActivityAware,
//    PluginRegistry.RequestPermissionsResultListener {
//    private var activity: Activity? = null
//    private lateinit var ctx: Context
//
//    companion object {
//        private const val NOTIFICATION_PERMISSION_REQUEST_CODE = 36
//        private val TAG = InitializeHandler::class.java.simpleName
//    }
//
//    override fun handle(
//        context: Context,
//        convertedCall: FlutterMqttCall.Initialize,
//        result: MethodChannel.Result
//    ) {
//        // Validation
//        if (
//            hasInvalidIcon(
//                context,
//                convertedCall.platformNotificationSettings.notificationIcon,
//                result
//            ) ||
//            hasInvalidMQTTConnectionConfig(convertedCall.MQTTConnectionSetting, result) ||
//            hasInvalidPlatformNotificationSetting(
//                convertedCall.platformNotificationSettings,
//                result
//            )
//        ) {
//            return
//        }
//
//
//        // Save configuration
//        this.ctx = context
//        createNotificationChannel(
//            context,
//            convertedCall.platformNotificationSettings.channelId!!,
//            convertedCall.platformNotificationSettings.channelName!!
//        )
//        savePlatformNotificationSetting(convertedCall.platformNotificationSettings)
//        saveMQTTConnectionSetting(convertedCall.MQTTConnectionSetting)
//        saveCallbackKeys(convertedCall.dispatcherHandle, convertedCall.receiveBackgroundNotificationCallbackHandle)
//
//
//        // Request notification permission and then start worker
//        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
//            if (
//                ContextCompat.checkSelfPermission(
//                    context,
//                    Manifest.permission.POST_NOTIFICATIONS
//                ) != PackageManager.PERMISSION_GRANTED
//            ) {
//                activity?.requestPermissions(
//                    arrayOf(Manifest.permission.POST_NOTIFICATIONS),
//                    NOTIFICATION_PERMISSION_REQUEST_CODE
//                )
//            } else {
//                startWorker()
//            }
//        } else {
//            startWorker()
//        }
//
//        result.success(true)
//    }
//
//    private fun savePlatformNotificationSetting(platformNotificationSettings: PlatformNotificationSetting) {
//        SharedPreferenceHelper.setChannelId(ctx, platformNotificationSettings.channelId!!)
//        SharedPreferenceHelper.setChannelName(ctx, platformNotificationSettings.channelName!!)
//    }
//
//    private fun saveCallbackKeys(dispatcherHandle: Long?, callbackHandle: Long?) {
//        dispatcherHandle?.let {
//            SharedPreferenceHelper.setDispatcherHandle(ctx, it)
//        }
//        callbackHandle?.let {
//            SharedPreferenceHelper.setReceiveBackgroundNotificationCallbackHandle(ctx, it)
//        }
//    }
//
//    private fun saveMQTTConnectionSetting(MQTTConnectionSetting: MQTTConnectionSetting) {
//        SharedPreferenceHelper.setHostname(ctx, MQTTConnectionSetting.hostname!!)
//        SharedPreferenceHelper.setUsername(ctx, MQTTConnectionSetting.userName!!)
//        SharedPreferenceHelper.setPassword(ctx, MQTTConnectionSetting.password!!)
//        SharedPreferenceHelper.setTopic(ctx, MQTTConnectionSetting.topic!!)
//        SharedPreferenceHelper.setClientId(ctx, MQTTConnectionSetting.clientId!!)
//        SharedPreferenceHelper.setIsRequiredSSL(ctx, MQTTConnectionSetting.isRequiredSSL == true)
//    }
//
//    private fun startWorker() {
//
//        WorkManagerRequestHelper.startPeriodicWorker(
//            ctx,
//        )
//
//        ctx.startService(
//            Intent(
//                ctx,
//                DetectTaskRemoveService::class.java
//            )
//        )
//    }
//
//    override fun onRequestPermissionsResult(
//        requestCode: Int,
//        permissions: Array<out String>,
//        grantResults: IntArray
//    ): Boolean {
//        when (requestCode) {
//            NOTIFICATION_PERMISSION_REQUEST_CODE -> {
//                return if (grantResults.isNotEmpty() && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
//                    // Permission granted, proceed with using the camera
//                    Toast.makeText(
//                        ctx,
//                        "Notification permission granted",
//                        Toast.LENGTH_SHORT
//                    ).show()
//                    startWorker()
//                    true
//                } else {
//                    // Permission denied, show a message to the user
//                    Toast.makeText(
//                        ctx,
//                        "Notification permission denied",
//                        Toast.LENGTH_SHORT
//                    ).show()
//                    false
//                }
//            }
//        }
//        return false
//    }
//
//    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
//        activity = binding.activity
//        binding.addRequestPermissionsResultListener(this)
//    }
//
//    override fun onDetachedFromActivityForConfigChanges() {
//        activity = null
//    }
//
//    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
//        activity = binding.activity
//        binding.addRequestPermissionsResultListener(this)
//    }
//
//    override fun onDetachedFromActivity() {
//        activity = null
//    }
//
//}
//
//private class GetNotificationAppLaunchDetailsHandler :
//    CallHandler<FlutterMqttCall.GetNotificationAppLaunchDetails>, ActivityAware {
//    private var mainActivity: Activity? = null
//
//    override fun handle(
//        context: Context,
//        convertedCall: FlutterMqttCall.GetNotificationAppLaunchDetails,
//        result: MethodChannel.Result
//    ) {
//        val notificationAppLaunchDetails: MutableMap<String, Any> = HashMap()
//        var notificationLaunchedApp = false
//        Log.d("GetNotificationAppLaunchDetailsHandler", "GetNotificationAppLaunchDetailsHandler is working")
//        if (mainActivity != null) {
//            val launchIntent: Intent? = mainActivity?.intent
//            notificationLaunchedApp =
//                (launchIntent != null &&
//                        (SELECT_NOTIFICATION == launchIntent.action) &&
//                        !launchedActivityFromHistory(launchIntent))
//
//            if (notificationLaunchedApp) {
//                notificationAppLaunchDetails["notificationResponse"] =
//                    extractNotificationResponseMap(
//                        launchIntent!!
//                    )
//            }
//        }
//
//        notificationAppLaunchDetails[NOTIFICATION_LAUNCHED_APP] = notificationLaunchedApp
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
//        mainActivity = binding.activity
//    }
//
//    override fun onDetachedFromActivityForConfigChanges() {
//        mainActivity = null
//    }
//
//    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
//        mainActivity = binding.activity
//    }
//
//    override fun onDetachedFromActivity() {
//        mainActivity = null
//    }
//}
//
//private object GetCallBackHandle : CallHandler<FlutterMqttCall.GetCallbackHandle> {
//    override fun handle(
//        context: Context,
//        convertedCall: FlutterMqttCall.GetCallbackHandle,
//        result: MethodChannel.Result
//    ) {
//        val handle: Long = SharedPreferenceHelper.getReceiveBackgroundNotificationCallbackHandle(context)
//
//        if (handle != -1L) {
//            result.success(handle)
//        } else {
//            result.error(
//                "callback_handle_not_found",
//                "The CallbackHandle could not be found. Please make sure it has been set when you initialize plugin",
//                null
//            )
//        }
//    }
//}
//
//private object CancelAllHandler : CallHandler<FlutterMqttCall.CancelAll> {
//    override fun handle(
//        context: Context,
//        convertedCall: FlutterMqttCall.CancelAll,
//        result: MethodChannel.Result
//    ) {
//        HiveMqttNotificationServiceWorker.disconnect {
//            SharedPreferenceHelper.clearPrefs(context)
//            WorkManagerRequestHelper.cancelNotificationWorker(context)
//        }
//
//        result.success(true)
//    }
//}
//
//private object UnknownTaskHandler : CallHandler<FlutterMqttCall.Unknown> {
//    override fun handle(
//        context: Context,
//        convertedCall: FlutterMqttCall.Unknown,
//        result: MethodChannel.Result
//    ) {
//        result.notImplemented()
//    }
//}