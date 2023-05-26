package th.co.cdgs.flutter_mqtt

import android.Manifest
import android.app.Activity
import android.app.NotificationManager
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import android.util.Log
import android.widget.Toast
import androidx.core.app.NotificationManagerCompat
import androidx.core.content.ContextCompat
import io.flutter.FlutterInjector
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugin.common.PluginRegistry.NewIntentListener
import io.flutter.view.FlutterCallbackInformation
import th.co.cdgs.flutter_mqtt.entity.MQTTConnectionSetting
import th.co.cdgs.flutter_mqtt.entity.PlatformNotificationSetting
import th.co.cdgs.flutter_mqtt.service.DetectTaskRemoveService
import th.co.cdgs.flutter_mqtt.util.Extractor
import th.co.cdgs.flutter_mqtt.util.FlutterMqttCall
import th.co.cdgs.flutter_mqtt.util.NotificationHelper
import th.co.cdgs.flutter_mqtt.util.NotificationHelper.CANCEL_NOTIFICATION
import th.co.cdgs.flutter_mqtt.util.NotificationHelper.NOTIFICATION_ID
import th.co.cdgs.flutter_mqtt.util.NotificationHelper.SELECT_FOREGROUND_NOTIFICATION_ACTION
import th.co.cdgs.flutter_mqtt.util.NotificationHelper.SELECT_NOTIFICATION
import th.co.cdgs.flutter_mqtt.util.NotificationHelper.extractNotificationResponseMap
import th.co.cdgs.flutter_mqtt.util.PossibleFlutterMqttFlutterCall
import th.co.cdgs.flutter_mqtt.util.ResourceHelper
import th.co.cdgs.flutter_mqtt.util.SharedPreferenceHelper
import th.co.cdgs.flutter_mqtt.util.ValidationHelper
import th.co.cdgs.flutter_mqtt.util.WorkManagerRequestHelper
import th.co.cdgs.flutter_mqtt.workmanager.HiveMqttNotificationServiceWorker

/** FlutterMqttPlugin */
class FlutterMqttPlugin : FlutterPlugin, ActivityAware, NewIntentListener,
    MethodChannel.MethodCallHandler, PluginRegistry.RequestPermissionsResultListener,
    BroadcastReceiver() {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private var mainActivity: Activity? = null
    private lateinit var context: Context
    private val pendingActionNotification: MutableList<Map<String, Any?>> = mutableListOf()

    companion object {
        private val TAG = FlutterMqttPlugin::class.java.simpleName
        private const val NOTIFICATION_PERMISSION_REQUEST_CODE = 36
        const val ACTION_TAPPED =
            "th.co.cdgs.flutter_mqtt.receiver.FlutterMqttPlugin.ACTION_TAPPED"
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

            channel?.invokeMethod(
                PossibleFlutterMqttFlutterCall.ON_TAP_NOTIFICATION.rawMethodName,
                notificationResponse,
                object : MethodChannel.Result {
                    override fun notImplemented() {
                        Log.d(TAG, "onTapNotification result : notImplemented")
                    }

                    override fun error(
                        errorCode: String,
                        errorMessage: String?,
                        errorDetails: Any?
                    ) {
                        Log.d(TAG, "onTapNotification result : error")
                    }

                    override fun success(receivedResult: Any?) {
                        Log.d(TAG, "onTapNotification result : success")
                    }
                })
            return true
        }
        return false
    }

    /**
     * Initilize MQTT notification
     */
    private fun initialize(
        convertedCall: FlutterMqttCall.Initialize,
        result: MethodChannel.Result
    ) {
        Log.d(TAG, convertedCall.platformNotificationSettings.actions.toString())

        // Validation
        if (
            ResourceHelper.hasInvalidIcon(
                context,
                convertedCall.platformNotificationSettings.notificationIcon,
                result
            ) ||
            ValidationHelper.hasInvalidMQTTConnectionConfig(
                convertedCall.MQTTConnectionSetting,
                result
            ) ||
            ValidationHelper.hasInvalidPlatformNotificationSetting(
                convertedCall.platformNotificationSettings,
                result
            )
        ) {
            return
        }

        // Save configuration
        savePlatformNotificationSetting(convertedCall.platformNotificationSettings)
        saveMQTTConnectionSetting(convertedCall.MQTTConnectionSetting)
        saveCallbackKeys(
            convertedCall.dispatcherHandle,
            convertedCall.receiveBackgroundNotificationCallbackHandle,
            convertedCall.tapActionBackgroundNotificationCallbackHandle
        )

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
        SharedPreferenceHelper.setAndroidNotificationAction(
            context,
            platformNotificationSettings.actions
        )
    }

    /**
     * Work together with [initialize] function
     */
    private fun saveCallbackKeys(
        dispatcherHandle: Long?,
        callbackHandle: Long?,
        tapActionBackgroundNotificationCallbackHandle: Long?
    ) {
        dispatcherHandle?.let { dispatcher ->
            SharedPreferenceHelper.setDispatcherHandle(context, dispatcher)
            callbackHandle?.let {
                SharedPreferenceHelper.setReceiveBackgroundNotificationCallbackHandle(context, it)
            }
            tapActionBackgroundNotificationCallbackHandle?.let {
                SharedPreferenceHelper.setTapActionBackgroundNotificationCallbackHandle(context, it)
            }
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
        SharedPreferenceHelper.setIsRequiredSSL(
            context,
            MQTTConnectionSetting.isRequiredSSL == true
        )
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
    private fun cancelAll(result: MethodChannel.Result) {
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
                        ((SELECT_NOTIFICATION == launchIntent.action) || SELECT_FOREGROUND_NOTIFICATION_ACTION == launchIntent.action) &&
                        !launchedActivityFromHistory(launchIntent))

            if (notificationLaunchedApp) {
                notificationAppLaunchDetails["notificationResponse"] =
                    extractNotificationResponseMap(
                        launchIntent!!
                    )
            }
        }

        notificationAppLaunchDetails[NotificationHelper.NOTIFICATION_LAUNCHED_APP] =
            notificationLaunchedApp
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


    override fun onReceive(context: Context?, intent: Intent?) {

        if (!ACTION_TAPPED.equals(intent!!.action, ignoreCase = true)) {
            return
        }

        val action: Map<String, Any?> = extractNotificationResponseMap(intent)
        if (intent.getBooleanExtra(CANCEL_NOTIFICATION, false)) {
            NotificationManagerCompat.from(context!!).apply {
                cancel(action[NOTIFICATION_ID] as Int)
            }

            with((context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager)) {
                if (this.activeNotifications.size == 1) {
                    this.activeNotifications.find {
                        it.id == NotificationHelper.GROUP_PUSH_NOTIFICATION_ID
                    }?.also {
                        this.cancelAll()
                    }
                }
            }
        }

        onTapAction(context!!, intent)
    }

    private fun onTapAction(context: Context, intent: Intent) {
        if (intent.action == ACTION_TAPPED) {
            val notificationResponse: Map<String, Any?> = extractNotificationResponseMap(intent)

            val isStartBackgroundChannel = startBackgroundChannelIfNecessary(
                context,
                notificationResponse,
            )

            if(!isStartBackgroundChannel){
                channel?.invokeMethod(
                    PossibleFlutterMqttFlutterCall.ON_TAP_NOTIFICATION.rawMethodName,
                    notificationResponse,
                    object : MethodChannel.Result {
                        override fun success(result: Any?) {
                            Log.d(TAG, "onTapNotification : success")
                        }

                        override fun error(
                            errorCode: String,
                            errorMessage: String?,
                            errorDetails: Any?
                        ) {
                            Log.d(TAG, "onTapNotification : error")
                        }

                        override fun notImplemented() {
                            Log.d(TAG, "onTapNotification : notImplemented")
                        }
                    })
            }
        }
    }

    private var engine: FlutterEngine? = null

    private fun startBackgroundChannelIfNecessary(context: Context?, notificationResponse: Map<String, Any?>): Boolean {
        if (SharedPreferenceHelper.isAppInTerminatedState(context!!)) {
            pendingActionNotification.add(notificationResponse)

            if (engine != null) {
                Log.e(TAG, "Engine is already initialised")
                return false
            }

            val injector = FlutterInjector.instance()
            val loader = injector.flutterLoader()

            loader.startInitialization(context)
            loader.ensureInitializationComplete(context, null)

            engine = FlutterEngine(context)

            val dispatcherHandle = SharedPreferenceHelper.getDispatchHandle(context)
            if (dispatcherHandle == -1L) {
                Log.w(TAG, "Callback information could not be retrieved")
                return false
            }

            val dartExecutor: DartExecutor = engine!!.dartExecutor
            initializeMethodChannel(context, dartExecutor, notificationResponse)

            val dartBundlePath = loader.findAppBundlePath()
            val flutterCallbackInfo =
                FlutterCallbackInformation.lookupCallbackInformation(dispatcherHandle)
            dartExecutor.executeDartCallback(
                DartExecutor.DartCallback(context.assets, dartBundlePath, flutterCallbackInfo)
            )

            return true
        }

        return false

    }

    private fun initializeMethodChannel(
        context: Context,
        dartExecutor: DartExecutor,
        notificationResponse: Map<String, Any?>
    ) {
        val methodChannel =
            MethodChannel(dartExecutor.binaryMessenger, "th.co.cdgs/flutter_mqtt/background")

        val flutterMqttBackgroundHandler = FlutterMqttBackgroundHandler(context){
            Log.d(TAG, "backgroundChannelInitialized is working...")
            pendingActionNotification.forEach {
                methodChannel.invokeMethod(
                    PossibleFlutterMqttFlutterCall.ON_TAP_NOTIFICATION.rawMethodName,
                    notificationResponse,
                    object : MethodChannel.Result {
                        override fun success(result: Any?) {
                            Log.d(TAG, "onTapNotification : success")
                            pendingActionNotification.remove(it)
                        }

                        override fun error(
                            errorCode: String,
                            errorMessage: String?,
                            errorDetails: Any?
                        ) {
                            Log.d(TAG, "onTapNotification : error")
                        }

                        override fun notImplemented() {
                            Log.d(TAG, "onTapNotification : notImplemented")
                        }
                    })
            }
        }

        methodChannel.setMethodCallHandler(flutterMqttBackgroundHandler)
    }
}
