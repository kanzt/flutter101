package th.co.cdgs.flutter_mqtt_plugin.workmanager

import android.Manifest
import android.app.Notification
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.util.Log
import androidx.core.app.ActivityCompat
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import androidx.core.app.TaskStackBuilder
import androidx.work.CoroutineWorker
import androidx.work.WorkerParameters
import com.example.mqttkotlinsample.data.entity.NotificationPayload
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
import io.flutter.BuildConfig
import kotlinx.coroutines.*
import th.co.cdgs.flutter_mqtt_plugin.R
import th.co.cdgs.flutter_mqtt_plugin.util.isNullOrBlankOrEmpty
import java.util.concurrent.TimeUnit
import java.util.function.Consumer
import kotlin.coroutines.Continuation
import kotlin.coroutines.resume

class HiveMqttNotificationServiceWorker(
    val context: Context,
    val params: WorkerParameters
) : CoroutineWorker(context, params) {

    private val gsonBuilder by lazy {
        return@lazy GsonBuilder().create()
    }
    private val onConnected = object : MqttClientConnectedListener {
        override fun onConnected(mqttContext: MqttClientConnectedContext) {
            Log.d(TAG, "HiveMQTT is connected")
            if (isConnected) {
                beginConnected = TimeUnit.MILLISECONDS.toMinutes(System.currentTimeMillis())
            }
            isConnected = true

            val reconnectedTime =
                if (beginDisconnected != null) (TimeUnit.MILLISECONDS.toMinutes(
                    System.currentTimeMillis()
                ) - beginDisconnected!!) else null
            val message =
                if (reconnectedTime == null) "Connected" else "Reconnected in $reconnectedTime minutes"

            showConnectionStatusNotification(message)
        }

    }
    private val onDisConnected = object : MqttClientDisconnectedListener {
        override fun onDisconnected(mqttContext: MqttClientDisconnectedContext) {
            Log.d(TAG, "HiveMQTT is disconnected")
            if (isConnected) {
                beginDisconnected = TimeUnit.MILLISECONDS.toMinutes(System.currentTimeMillis())
            }
            isConnected = false

            val disconnectTime =
                if (beginConnected != null) (TimeUnit.MILLISECONDS.toMinutes(
                    System.currentTimeMillis()
                ) - beginConnected!!) else null
            val message =
                if (disconnectTime == null) "Disconnected" else "Disconnected after $disconnectTime minutes"

            showConnectionStatusNotification(message)

        }

    }
    private val onReceivedMessage: Consumer<Mqtt3Publish> =
        Consumer<Mqtt3Publish> { it ->
            val jsonMessage = String(it.payloadAsBytes)
            val logMessage = "Receive message: $jsonMessage from topic: ${it.topic}"
            Log.d(TAG, logMessage)

            // notificationId is a unique int for each notification that you must define
            if (ActivityCompat.checkSelfPermission(
                    context,
                    Manifest.permission.POST_NOTIFICATIONS
                ) == PackageManager.PERMISSION_GRANTED
            ) {
                with(NotificationManagerCompat.from(context)) {

                    val message = gsonBuilder.fromJson(jsonMessage, NotificationPayload::class.java)
                    // Create an Intent for the activity you want to start
                    val resultIntent =
                        Intent(context, NotificationDetailActivity::class.java).also {
                            it.putExtra(NOTIFICATION_PAYLOAD, jsonMessage)
                        }
                    // Create the TaskStackBuilder
                    val resultPendingIntent: PendingIntent? = TaskStackBuilder.create(context).run {
                        // Add the intent, which inflates the back stack
                        addNextIntentWithParentStack(resultIntent)
                        // Get the PendingIntent containing the entire back stack
                        getPendingIntent(
                            0,
                            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
                        )
                    }

                    val pushNotificationBuilder = NotificationCompat.Builder(
                        context,
                        CHANNEL_ID
                    ).apply {
                        setSmallIcon(getDrawableResourceId(context, "ic_launcher"))
                        setGroup(GROUP_KEY_MESSAGE)
                        setContentTitle("Push notification")
                        setContentText(logMessage)
                        setStyle(
                            NotificationCompat.BigTextStyle()
                                .bigText(logMessage)
                        )
                        setContentIntent(resultPendingIntent)
                        setCategory(Notification.CATEGORY_MESSAGE)
                    }

                    val groupPushNotificationBuilder = NotificationCompat.Builder(
                        context,
                        CHANNEL_ID
                    ).apply {
                        setSmallIcon(getDrawableResourceId(context, "ic_launcher"))
                        setGroup(GROUP_KEY_MESSAGE)
                        setContentTitle("Push notification")
                        setContentText(logMessage)
                        setGroup(GROUP_KEY_MESSAGE)
                        setGroupSummary(true)
                        setCategory(Notification.CATEGORY_MESSAGE)
                    }

                    notify(System.currentTimeMillis().toInt(), pushNotificationBuilder.build())
                    notify(GROUP_PUSH_NOTIFICATION_ID, groupPushNotificationBuilder.build())

                    val scope = CoroutineScope(Job() + Dispatchers.IO)
                    scope.launch {
                        coroutineScope {
                            UserPreferences.setStringPreferences(
                                context,
                                UserPreferences.PreferencesKeys.KEY_RECENT_NOTIFICATION,
                                jsonMessage
                            )

                            it.acknowledge()
                        }
                        scope.cancel()
                    }
                }
            }
        }

    override suspend fun doWork(): Result {
        // This block run in Default dispatcher
        return try {
            Log.d(TAG, "isConnected : $isConnected | mqtt3AsyncClient : $mqtt3AsyncClient")
            if (!isConnected && mqtt3AsyncClient == null) {
                connect()
            }
            Result.success()
        } catch (e: Exception) {
            Log.d(TAG, "exception in doWork ${e.message}")
            Result.failure()
        }
    }

    private fun buildNotificationConnectionStatus(message: String): NotificationCompat.Builder {
        return NotificationCompat.Builder(
            context,
            CHANNEL_ID
        ).apply {
            setSmallIcon(getDrawableResourceId(context, "ic_launcher"))
            setOngoing(true)
            setContentTitle("Connection status (Debug purpose)")
            setContentText(message)
            setCategory(Notification.CATEGORY_MESSAGE)
        }
    }

    private suspend fun connect() {
        Log.d(TAG, "Before coroutineScope")
        coroutineScope {
            Log.d(TAG, "begin coroutineScope")
            // TODO : Read clientId
            val clientId = ""
            // TODO : Read topic
            topic = ""
            Log.d(TAG, "ClientId is $clientId")
            Log.d(TAG, "Topic is $topic")
            Log.d(TAG, "Context is $context")
            if (!clientId.isNullOrBlankOrEmpty() && !topic.isNullOrBlankOrEmpty()) {
                var clientBuilder = MqttClient.builder().identifier(clientId)
                    .serverHost(BuildConfig.HOSTNAME).serverPort(1883)
                    .useMqttVersion3()
                    /** Reconnect strategy
                     *  https://www.hivemq.com/blog/hivemq-mqtt-client-features/reconnect-handling/
                     */
                    .automaticReconnect()
                    .initialDelay(3000, TimeUnit.MILLISECONDS)
                    .maxDelay(3, TimeUnit.MINUTES)
                    .applyAutomaticReconnect()
                    .simpleAuth()
                    .username(BuildConfig.USERNAME)
                    .password(BuildConfig.PASSWORD.toByteArray())
                    .applySimpleAuth()
                    .addConnectedListener(onConnected).addDisconnectedListener(onDisConnected)

                if (BuildConfig.IS_REQUIRED_SSL) {
                    clientBuilder = clientBuilder.sslWithDefaultConfig()
                }

                mqtt3AsyncClient = clientBuilder.buildAsync()

                Log.d(TAG, "Start connecting to Broker")
                mqtt3AsyncClient!!.connectWith().cleanSession(false).send()

                subscribeNotification(topic!!)
            }
            Log.d(TAG, "end coroutineScope")
        }
        Log.d(TAG, "After coroutineScope")
    }

    private fun subscribeNotification(topic: String) {
        val mqtt3Subscribe = Mqtt3Subscribe.builder()
            .topicFilter(topic).qos(
                MqttQos.AT_LEAST_ONCE
            ).build()

        mqtt3AsyncClient?.subscribe(mqtt3Subscribe, onReceivedMessage, true)?.whenComplete { t, u ->
            Log.d(TAG, "Subscribe to $topic completed")
        }
    }

    private fun showConnectionStatusNotification(message: String) {
        with(NotificationManagerCompat.from(context)) {
            // notificationId is a unique int for each notification that you must define
            if (ActivityCompat.checkSelfPermission(
                    context,
                    Manifest.permission.POST_NOTIFICATIONS
                ) != PackageManager.PERMISSION_GRANTED
            ) {
                return
            }

            val pushNotificationBuilder = buildNotificationConnectionStatus(message)

            notify(3, pushNotificationBuilder.build())
        }
    }

    companion object {
        private val TAG = HiveMqttNotificationServiceWorker::class.java.simpleName
        private const val GROUP_PUSH_NOTIFICATION_ID = 4
        private const val CHANNEL_ID = "push_notification"
        private const val GROUP_KEY_MESSAGE =
            "com.example.mqttkotlinsample.HiveMqttNotificationServiceWorker"
        const val UNIQUE_PERIODIC_HIVE_MQTT = "MqttHiveNotificationServiceWorker"
        private var topic: String? = null

        private var mqtt3AsyncClient: Mqtt3AsyncClient? = null
        var isConnected: Boolean = false
        private var beginDisconnected: Long? = null
        private var beginConnected: Long? = null

        private fun getDrawableResourceId(context: Context, name: String): Int {
            return context.resources.getIdentifier(name, "drawable", context.packageName)
        }

        fun disconnect(
            successCallback: (() -> Unit)? = null,
            failedCallback: (() -> Unit)? = null
        ) {
            if (isConnected && mqtt3AsyncClient != null && !topic.isNullOrBlankOrEmpty()) {
                mqtt3AsyncClient!!.unsubscribe(
                    Mqtt3Unsubscribe.builder().topicFilter(topic!!).build()
                )
                    .whenComplete { _, e ->
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
                                    beginDisconnected = null
                                    beginConnected = null
                                    successCallback?.invoke()
                                }
                            }
                        }
                    }
            }
        }
    }

}

/**
 * No longer use
 */
@OptIn(ExperimentalCoroutinesApi::class)
suspend fun Mqtt3AsyncClient.subscribe(
    mqtt3Subscribe: Mqtt3Subscribe,
    manualAcknowledgement: Boolean = false
): Mqtt3Publish =
    suspendCancellableCoroutine<Mqtt3Publish> { continuation ->
        subscribe(mqtt3Subscribe, {
            continuation.safeResume(it) {
                Log.d(
                    "suspendCancellableCoroutine",
                    "Job has already done"
                )
            }
        }, manualAcknowledgement)
            .whenComplete { _, e ->
                if (e != null) {
                    continuation.cancel(e)
                }
            }

    }

/**
 * No longer use
 */
inline fun <T> Continuation<T>.safeResume(value: T, onExceptionCalled: () -> Unit) {
    if (this is CancellableContinuation) {
        if (isActive)
            resume(value)
        else
            onExceptionCalled()
    } else throw Exception("Must use suspendCancellableCoroutine instead of suspendCoroutine")
}