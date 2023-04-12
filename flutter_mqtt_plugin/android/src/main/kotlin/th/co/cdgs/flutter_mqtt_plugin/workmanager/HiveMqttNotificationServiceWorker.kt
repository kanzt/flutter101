package th.co.cdgs.flutter_mqtt_plugin.workmanager

import android.Manifest
import android.app.Notification
import android.content.Context
import android.content.pm.PackageManager
import android.util.Log
import androidx.core.app.ActivityCompat
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
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
import kotlinx.coroutines.coroutineScope
import th.co.cdgs.flutter_mqtt_plugin.FlutterMqttPlugin
import th.co.cdgs.flutter_mqtt_plugin.entity.NotificationPayload
import th.co.cdgs.flutter_mqtt_plugin.util.isNullOrBlankOrEmpty
import java.util.concurrent.TimeUnit
import java.util.function.Consumer

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
            isConnected = true
        }

    }
    private val onDisConnected = object : MqttClientDisconnectedListener {
        override fun onDisconnected(mqttContext: MqttClientDisconnectedContext) {
            Log.d(TAG, "HiveMQTT is disconnected")
            isConnected = false
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
//                    val resultIntent =
//                        Intent(context, NotificationDetailActivity::class.java).also {
//                            it.putExtra(NOTIFICATION_PAYLOAD, jsonMessage)
//                        }
//                    // Create the TaskStackBuilder
//                    val resultPendingIntent: PendingIntent? = TaskStackBuilder.create(context).run {
//                        // Add the intent, which inflates the back stack
//                        addNextIntentWithParentStack(resultIntent)
//                        // Get the PendingIntent containing the entire back stack
//                        getPendingIntent(
//                            0,
//                            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
//                        )
//                    }

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
                        // setContentIntent(resultPendingIntent)
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

                    FlutterMqttPlugin.onReceivedNotificationEventSink?.success(jsonMessage)
                }
            }
        }

    override suspend fun doWork(): Result {
        // This block run in Default dispatcher
        return try {
            Log.d(TAG, "isConnected : $isConnected | mqtt3AsyncClient : $mqtt3AsyncClient")
            if (!isConnected && mqtt3AsyncClient == null && FlutterMqttPlugin.config != null) {
                connect()
            }
            Result.success()
        } catch (e: Exception) {
            Log.d(TAG, "exception in doWork ${e.message}")
            Result.failure()
        }
    }

    private suspend fun connect() {
        Log.d(TAG, "Before coroutineScope")
        coroutineScope {
            Log.d(TAG, "begin coroutineScope")
            val clientId = FlutterMqttPlugin.config!!.clientId
            topic = FlutterMqttPlugin.config!!.topic
            Log.d(TAG, "ClientId is $clientId")
            Log.d(TAG, "Topic is $topic")
            Log.d(TAG, "Context is $context")
            if (!clientId.isNullOrBlankOrEmpty() && !topic.isNullOrBlankOrEmpty()) {
                var clientBuilder = MqttClient.builder().identifier(clientId)
                    .serverHost(FlutterMqttPlugin.config!!.hostname).serverPort(1883)
                    .useMqttVersion3()
                    /** Reconnect strategy
                     *  https://www.hivemq.com/blog/hivemq-mqtt-client-features/reconnect-handling/
                     */
                    .automaticReconnect()
                    .initialDelay(3000, TimeUnit.MILLISECONDS)
                    .maxDelay(3, TimeUnit.MINUTES)
                    .applyAutomaticReconnect()
                    .simpleAuth()
                    .username(FlutterMqttPlugin.config!!.userName)
                    .password(FlutterMqttPlugin.config!!.password.toByteArray())
                    .applySimpleAuth()
                    .addConnectedListener(onConnected).addDisconnectedListener(onDisConnected)

                if (FlutterMqttPlugin.config!!.isRequiredSSL) {
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
                                    successCallback?.invoke()
                                }
                            }
                        }
                    }
            }
        }
    }

}