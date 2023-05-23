package th.co.cdgs.flutter_mqtt.workmanager

import android.Manifest
import android.annotation.SuppressLint
import android.app.Notification
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Handler
import android.os.Looper
import android.text.Spannable
import android.text.SpannableString
import android.text.style.ForegroundColorSpan
import android.util.Log
import androidx.core.app.ActivityCompat
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import androidx.core.graphics.drawable.IconCompat
import androidx.work.CoroutineWorker
import androidx.work.WorkerParameters
import com.google.gson.GsonBuilder
import com.hivemq.client.mqtt.MqttClient
import com.hivemq.client.mqtt.datatypes.MqttQos
import com.hivemq.client.mqtt.lifecycle.MqttClientConnectedContext
import com.hivemq.client.mqtt.lifecycle.MqttClientConnectedListener
import com.hivemq.client.mqtt.lifecycle.MqttClientDisconnectedContext
import com.hivemq.client.mqtt.lifecycle.MqttClientDisconnectedListener
import com.hivemq.client.mqtt.mqtt3.Mqtt3AsyncClient
import com.hivemq.client.mqtt.mqtt3.message.publish.Mqtt3Publish
import com.hivemq.client.mqtt.mqtt3.message.subscribe.Mqtt3Subscribe
import com.hivemq.client.mqtt.mqtt3.message.unsubscribe.Mqtt3Unsubscribe
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.embedding.engine.loader.FlutterLoader
import io.flutter.plugin.common.MethodChannel
import io.flutter.view.FlutterCallbackInformation
import kotlinx.coroutines.*
import th.co.cdgs.flutter_mqtt.FlutterMqttPlugin
import th.co.cdgs.flutter_mqtt.entity.AndroidNotificationAction
import th.co.cdgs.flutter_mqtt.entity.MQTTConnectionSetting
import th.co.cdgs.flutter_mqtt.entity.PendingBackgroundNotification
import th.co.cdgs.flutter_mqtt.receiver.ActionBroadcastReceiver
import th.co.cdgs.flutter_mqtt.util.NotificationHelper.ACTION_ID
import th.co.cdgs.flutter_mqtt.util.NotificationHelper.CANCEL_NOTIFICATION
import th.co.cdgs.flutter_mqtt.util.NotificationHelper.GROUP_KEY_MESSAGE
import th.co.cdgs.flutter_mqtt.util.NotificationHelper.GROUP_PUSH_NOTIFICATION_ID
import th.co.cdgs.flutter_mqtt.util.NotificationHelper.NOTIFICATION_ID
import th.co.cdgs.flutter_mqtt.util.NotificationHelper.NOTIFICATION_PAYLOAD
import th.co.cdgs.flutter_mqtt.util.NotificationHelper.SELECT_FOREGROUND_NOTIFICATION_ACTION
import th.co.cdgs.flutter_mqtt.util.NotificationHelper.SELECT_NOTIFICATION
import th.co.cdgs.flutter_mqtt.util.ResourceHelper.getDefaultAppIcon
import th.co.cdgs.flutter_mqtt.util.ResourceHelper.getDrawableResourceId
import th.co.cdgs.flutter_mqtt.util.ResourceHelper.getIconFromSource
import th.co.cdgs.flutter_mqtt.util.SharedPreferenceHelper
import th.co.cdgs.flutter_mqtt.util.isNullOrBlankOrEmpty
import java.util.concurrent.TimeUnit
import java.util.function.Consumer


class HiveMqttNotificationServiceWorker(
    private val context: Context, private val params: WorkerParameters
) : CoroutineWorker(context, params) {

    private var engine: FlutterEngine? = null
    private var workerMethodChannel: MethodChannel? = null
    private val flutterLoader = FlutterLoader()
    private var androidNotificationAction: List<AndroidNotificationAction>? = null
    private lateinit var channelId: String
    private var pendingBackgroundNotification: MutableList<PendingBackgroundNotification> =
        mutableListOf()

    private val gsonBuilder by lazy {
        return@lazy GsonBuilder().create()
    }
    private val onConnected = object : MqttClientConnectedListener {
        override fun onConnected(mqttContext: MqttClientConnectedContext) {
            Log.d(TAG, "HiveMQTT is connected")
            isConnected = true
        }

    }
    private val onDisConnected = object : MqttClientDisconnectedListener {
        override fun onDisconnected(mqttContext: MqttClientDisconnectedContext) {
            Log.d(TAG, "HiveMQTT is disconnected")
            isConnected = false
        }

    }
    private val onReceivedMessage: Consumer<Mqtt3Publish> = Consumer<Mqtt3Publish> { it ->
        val jsonMessage = String(it.payloadAsBytes)
        val logMessage = "Receive message: $jsonMessage from topic: ${it.topic}"
        Log.d(TAG, logMessage)

        // notificationId is a unique int for each notification that you must define
        if (ActivityCompat.checkSelfPermission(
                context, Manifest.permission.POST_NOTIFICATIONS
            ) == PackageManager.PERMISSION_GRANTED
        ) {
            NotificationManagerCompat.from(context).apply {

                val notificationId = System.currentTimeMillis().toInt()
                // val message = gsonBuilder.fromJson(jsonMessage, NotificationPayload::class.java)

                val pendingIntent = getLaunchIntent(context)?.also {
                    it.action = SELECT_NOTIFICATION
                    it.putExtra(
                        NOTIFICATION_PAYLOAD, jsonMessage
                    )
                }.let {
                    PendingIntent.getActivity(
                        context,
                        notificationId,
                        it,
                        PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
                    )
                }

                val pushNotificationBuilder = NotificationCompat.Builder(
                    context, channelId
                ).apply {
                    setSmallIcon(getDefaultAppIcon(context))
                    setGroup(GROUP_KEY_MESSAGE)
                    setContentTitle("Push notification")
                    setContentText(logMessage)
                    setContentIntent(pendingIntent)
                    setAutoCancel(true)
                    setStyle(
                        NotificationCompat.BigTextStyle().bigText(logMessage)
                    )
                    setCategory(Notification.CATEGORY_MESSAGE)
                }

                addAndroidNotificationAction(pushNotificationBuilder, notificationId, jsonMessage)

                val groupPushNotificationBuilder = NotificationCompat.Builder(
                    context, channelId
                ).apply {
                    setSmallIcon(getDefaultAppIcon(context))
                    setGroup(GROUP_KEY_MESSAGE)
                    setContentTitle("Push notification")
                    setContentText(logMessage)
                    setGroup(GROUP_KEY_MESSAGE)
                    setGroupSummary(true)
                    setCategory(Notification.CATEGORY_MESSAGE)
                }

                notify(notificationId, pushNotificationBuilder.build())
                notify(GROUP_PUSH_NOTIFICATION_ID, groupPushNotificationBuilder.build())

                // Send notification to Flutter side
                notifyToFlutter(notificationId, jsonMessage, it)
            }
        }
    }

    private fun addAndroidNotificationAction(
        notificationBuilder: NotificationCompat.Builder,
        notificationId: Int,
        notificationPayload: String,
    ) {
        if (androidNotificationAction != null) {
            // Space out request codes by 16 so even with 16 actions they won't clash
            var requestCode: Int = notificationId * 16
            androidNotificationAction?.forEach { action ->
                var icon: IconCompat? = null
                if (!action.icon.isNullOrBlankOrEmpty() && action.iconSource != null) {
                    icon =
                        getIconFromSource(context, action.icon as Any, action.iconSource!!);
                }
                var actionIntent: Intent? = null
                // TODO : ทดสอบ showsUserInterface = true
                if (action.showsUserInterface != null && action.showsUserInterface!!) {
                    actionIntent = getLaunchIntent(context)?.also {
                        it.action = SELECT_FOREGROUND_NOTIFICATION_ACTION
                    }
                } else {
                    actionIntent = Intent(context, ActionBroadcastReceiver::class.java)
                    actionIntent.action = ActionBroadcastReceiver.ACTION_TAPPED
                }

                actionIntent?.apply {
                    putExtra(NOTIFICATION_ID, notificationId)
                    putExtra(ACTION_ID, action.id)
                    putExtra(CANCEL_NOTIFICATION, action.cancelNotification)
                    putExtra(NOTIFICATION_PAYLOAD, notificationPayload)
                }

                val actionFlags = PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE

                @SuppressLint("UnspecifiedImmutableFlag")
                val actionPendingIntent =
                    if (action.showsUserInterface != null && action.showsUserInterface!!) PendingIntent.getActivity(
                        context,
                        requestCode++,
                        actionIntent,
                        actionFlags
                    ) else PendingIntent.getBroadcast(
                        context, requestCode++,
                        actionIntent!!, actionFlags
                    )


                val actionTitleSpannable: Spannable = SpannableString(action.title)
                if (action.titleColor != null) {
                    actionTitleSpannable.setSpan(
                        ForegroundColorSpan(action.titleColor!!), 0, actionTitleSpannable.length, 0
                    )
                }
                val actionBuilder = NotificationCompat.Action.Builder(
                    icon,
                    actionTitleSpannable,
                    actionPendingIntent
                )


                if (action.contextual != null) {
                    actionBuilder.setContextual(action.contextual!!)
                }
                if (action.showsUserInterface != null) {
                    actionBuilder.setShowsUserInterface(action.showsUserInterface!!)
                }

                notificationBuilder.addAction(actionBuilder.build())
            }
        }
    }

    /**
     * Send notification to Flutter side
     */
    private fun notifyToFlutter(
        notificationId: Int,
        notificationPayload: String,
        mqtt3Publish: Mqtt3Publish?
    ) {
        val scope = CoroutineScope(Job() + Dispatchers.Main)
        scope.launch {
            coroutineScope {

                val isStartBackgroundChannel = startBackgroundChannelIfNecessary(
                    notificationId,
                    notificationPayload,
                    mqtt3Publish
                )

                if (!isStartBackgroundChannel) {
                    val channel = if (isAppInTerminatedState()) {
                        Log.d(TAG, "Using workerMethodChannel")
                        workerMethodChannel
                    } else {
                        Log.d(TAG, "Using FlutterMqttPlugin.channel")
                        FlutterMqttPlugin.channel
                    }

                    val arguments = buildNotificationArguments(notificationId, notificationPayload)

                    channel?.invokeMethod(
                        "didReceiveNotificationResponse",
                        arguments,
                        object : MethodChannel.Result {
                            override fun notImplemented() {
                                Log.d(TAG, "didReceiveNotificationResponse result : notImplemented")
                            }

                            override fun error(
                                errorCode: String,
                                errorMessage: String?,
                                errorDetails: Any?
                            ) {
                                Log.d(TAG, "didReceiveNotificationResponse result : error")
                            }

                            override fun success(receivedResult: Any?) {
                                Log.d(TAG, "didReceiveNotificationResponse result : success")
                                mqtt3Publish?.acknowledge()
                            }
                        })
                }
            }
            scope.cancel()
        }
    }

    private fun buildNotificationArguments(
        notificationId: Int,
        notificationPayload: String
    ): Map<String, Any> {
        return mapOf(
            NOTIFICATION_PAYLOAD to notificationPayload,
            NOTIFICATION_ID to notificationId
        )
    }

    override suspend fun doWork(): Result {
        // This block run in Default dispatcher
        return try {
            val hostname = SharedPreferenceHelper.getHostname(context) ?: return Result.failure()
            val username = SharedPreferenceHelper.getUsername(context) ?: return Result.failure()
            val password = SharedPreferenceHelper.getPassword(context) ?: return Result.failure()
            val clientId = SharedPreferenceHelper.getClientId(context) ?: return Result.failure()
            val topic = SharedPreferenceHelper.getTopic(context) ?: return Result.failure()
            val isRequiredSSL = SharedPreferenceHelper.isRequiredSSL(context)
            channelId = SharedPreferenceHelper.getChannelId(context) ?: return Result.failure()
            androidNotificationAction = SharedPreferenceHelper.getAndroidNotificationAction(context)

            Log.d(TAG, "isConnected : $isConnected | mqtt3AsyncClient : $mqtt3AsyncClient")
            if (!isConnected && mqtt3AsyncClient == null) {

                connect(
                    MQTTConnectionSetting(
                        hostname = hostname,
                        userName = username,
                        password = password,
                        clientId = clientId,
                        topic = topic,
                        isRequiredSSL = isRequiredSSL,
                    )
                )
            }

            Result.success()
        } catch (e: Exception) {
            Log.d(TAG, "exception in doWork ${e.message}")
            Result.failure()
        }
    }

    /**
     * Start FlutterEngine for background isolate
     */
    private suspend fun startBackgroundChannelIfNecessary(
        notificationId: Int,
        notificationPayload: String,
        mqtt3Publish: Mqtt3Publish?
    ): Boolean {
        return withContext(Dispatchers.Main) {
            if (isAppInTerminatedState() && workerMethodChannel == null) {
                pendingBackgroundNotification.add(
                    PendingBackgroundNotification(
                        notificationId = notificationId,
                        payload = notificationPayload,
                        mqtt3Publish = mqtt3Publish
                    )
                )

                if (engine == null) {
                    engine = FlutterEngine(applicationContext)
                }

                if (!flutterLoader.initialized()) {
                    flutterLoader.startInitialization(applicationContext)
                }

                flutterLoader.ensureInitializationCompleteAsync(
                    applicationContext,
                    null,
                    Handler(Looper.getMainLooper())
                ) {
                    engine?.let {
                        val dispatchHandle =
                            SharedPreferenceHelper.getDispatchHandle(applicationContext)
                        if (dispatchHandle == -1L) {
                            Log.w(
                                TAG,
                                "Callback information could not be retrieved"
                            )
                            return@ensureInitializationCompleteAsync
                        }

                        val callbackInfo =
                            FlutterCallbackInformation.lookupCallbackInformation(dispatchHandle)
                        val dartBundlePath = flutterLoader.findAppBundlePath()
                        workerMethodChannel = MethodChannel(
                            it.dartExecutor,
                            "th.co.cdgs/flutter_mqtt/worker"
                        )

                        workerMethodChannel?.setMethodCallHandler { call, result ->
                            when (call.method) {
                                "getCallbackHandle" -> {
                                    val handle: Long =
                                        SharedPreferenceHelper.getCallbackHandle(context)

                                    if (handle != -1L) {
                                        result.success(handle)
                                    } else {
                                        result.error(
                                            "callback_handle_not_found",
                                            "The CallbackHandle could not be found. Please make sure it has been set when you initialize plugin",
                                            null
                                        )
                                    }
                                }

                                "backgroundChannelInitialized" -> {
                                    Log.d(TAG, "backgroundChannelInitialized is working...")
                                    pendingBackgroundNotification.forEach { notification ->
                                        workerMethodChannel?.invokeMethod(
                                            "didReceiveNotificationResponse",
                                            buildNotificationArguments(
                                                notification.notificationId,
                                                notification.payload
                                            ),
                                            object : MethodChannel.Result {
                                                override fun notImplemented() {
                                                    Log.d(
                                                        TAG,
                                                        "didReceiveNotificationResponse result : notImplemented"
                                                    )
                                                }

                                                override fun error(
                                                    errorCode: String,
                                                    errorMessage: String?,
                                                    errorDetails: Any?
                                                ) {
                                                    Log.d(
                                                        TAG,
                                                        "didReceiveNotificationResponse result : error"
                                                    )
                                                }

                                                override fun success(receivedResult: Any?) {
                                                    Log.d(
                                                        TAG,
                                                        "didReceiveNotificationResponse result : success"
                                                    )
                                                    notification.mqtt3Publish?.acknowledge()
                                                    pendingBackgroundNotification.remove(
                                                        notification
                                                    )
                                                }
                                            })
                                    }
                                }
                            }
                        }

                        it.dartExecutor.executeDartCallback(
                            DartExecutor.DartCallback(
                                applicationContext.assets,
                                dartBundlePath,
                                callbackInfo
                            )
                        )
                    }
                }

                return@withContext true
            }
            return@withContext false
        }
    }

    private suspend fun connect(MQTTConnectionSetting: MQTTConnectionSetting) {
        coroutineScope {
            val clientId = MQTTConnectionSetting.clientId
            topic = MQTTConnectionSetting.topic
            Log.d(TAG, "ClientId is $clientId")
            Log.d(TAG, "Topic is $topic")
            Log.d(TAG, "Context is $context")
            if (!clientId.isNullOrBlankOrEmpty() && !topic.isNullOrBlankOrEmpty()) {
                var clientBuilder = MqttClient.builder().identifier(clientId!!)
                    .serverHost(MQTTConnectionSetting.hostname!!).serverPort(1883)
                    .useMqttVersion3()
                    /** Reconnect strategy
                     *  https://www.hivemq.com/blog/hivemq-mqtt-client-features/reconnect-handling/
                     */
                    .automaticReconnect().initialDelay(3000, TimeUnit.MILLISECONDS)
                    .maxDelay(3, TimeUnit.MINUTES).applyAutomaticReconnect().simpleAuth()
                    .username(MQTTConnectionSetting.userName!!)
                    .password(MQTTConnectionSetting.password!!.toByteArray())
                    .applySimpleAuth().addConnectedListener(onConnected)
                    .addDisconnectedListener(onDisConnected)

                if (MQTTConnectionSetting.isRequiredSSL!!) {
                    clientBuilder = clientBuilder.sslWithDefaultConfig()
                }

                mqtt3AsyncClient = clientBuilder.buildAsync()

                Log.d(TAG, "Start connecting to Broker")
                mqtt3AsyncClient!!.connectWith().cleanSession(false).send()

                subscribeNotification(topic!!)
            }
        }
    }

    private fun subscribeNotification(topic: String) {
        val mqtt3Subscribe = Mqtt3Subscribe.builder().topicFilter(topic).qos(
            MqttQos.AT_LEAST_ONCE
        ).build()

        mqtt3AsyncClient?.subscribe(mqtt3Subscribe, onReceivedMessage, true)
            ?.whenComplete { t, u ->
                Log.d(TAG, "Subscribe to $topic completed")
            }
    }

    private fun getLaunchIntent(context: Context): Intent? {
        val packageName = context.packageName
        val packageManager = context.packageManager
        return packageManager.getLaunchIntentForPackage(packageName)
    }

    private fun isAppInTerminatedState(): Boolean {
        return SharedPreferenceHelper.isTaskRemove(context)
    }

    companion object {
        private val TAG = HiveMqttNotificationServiceWorker::class.java.simpleName

        private var topic: String? = null
        private var mqtt3AsyncClient: Mqtt3AsyncClient? = null
        var isConnected: Boolean = false

        fun disconnect(
            successCallback: (() -> Unit)? = null, failedCallback: (() -> Unit)? = null
        ) {
            if (isConnected && mqtt3AsyncClient != null && !topic.isNullOrBlankOrEmpty()) {
                mqtt3AsyncClient!!.unsubscribe(
                    Mqtt3Unsubscribe.builder().topicFilter(topic!!).build()
                ).whenComplete { _, e ->
                    if (e != null) {
                        Log.d(TAG, "Error unsubscribing from topic: $topic")
                        failedCallback?.invoke()
                    } else {
                        Log.d(TAG, "Successfully unsubscribed from topic: $topic")
                        mqtt3AsyncClient!!.disconnect().whenComplete { _, e2 ->
                            if (e2 != null) {
                                Log.d(TAG, "Error disconnecting from Broker")
                                failedCallback?.invoke()
                            } else {
                                Log.d(TAG, "Clearing static data...")
                                isConnected = false
                                mqtt3AsyncClient = null
                                topic = null
                                successCallback?.invoke()
                            }
                        }
                    }
                }
            }
        }
    }

}