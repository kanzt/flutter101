package th.co.cdgs.flutter_mqtt.workmanager

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
import th.co.cdgs.flutter_mqtt.entity.MQTTConnectionSetting
import th.co.cdgs.flutter_mqtt.entity.NotificationPayload
import th.co.cdgs.flutter_mqtt.util.NotificationHelper.GROUP_KEY_MESSAGE
import th.co.cdgs.flutter_mqtt.util.NotificationHelper.GROUP_PUSH_NOTIFICATION_ID
import th.co.cdgs.flutter_mqtt.util.NotificationHelper.NOTIFICATION_PAYLOAD
import th.co.cdgs.flutter_mqtt.util.NotificationHelper.SELECT_NOTIFICATION
import th.co.cdgs.flutter_mqtt.util.SharedPreferenceHelper
import th.co.cdgs.flutter_mqtt.util.isNullOrBlankOrEmpty
import java.util.concurrent.TimeUnit
import java.util.function.Consumer

class HiveMqttNotificationServiceWorker(
    val context: Context, val params: WorkerParameters
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
    private val onReceivedMessage: Consumer<Mqtt3Publish> = Consumer<Mqtt3Publish> { it ->
        val jsonMessage = String(it.payloadAsBytes)
        val logMessage = "Receive message: $jsonMessage from topic: ${it.topic}"
        Log.d(TAG, logMessage)

        // notificationId is a unique int for each notification that you must define
        if (ActivityCompat.checkSelfPermission(
                context, Manifest.permission.POST_NOTIFICATIONS
            ) == PackageManager.PERMISSION_GRANTED
        ) {
            with(NotificationManagerCompat.from(context)) {

                val notificationId = System.currentTimeMillis().toInt()
                val message = gsonBuilder.fromJson(jsonMessage, NotificationPayload::class.java)

                val intent = getLaunchIntent(context)?.also {
                    it.action = SELECT_NOTIFICATION
                    it.putExtra(
                        NOTIFICATION_PAYLOAD, jsonMessage
                    )
                }
                val pendingIntent = PendingIntent.getActivity(
                    context,
                    notificationId,
                    intent,
                    PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
                )

                val pushNotificationBuilder = NotificationCompat.Builder(
                    context, channelId
                ).apply {
                    setSmallIcon(getDrawableResourceId(context, "ic_launcher"))
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

                val groupPushNotificationBuilder = NotificationCompat.Builder(
                    context, channelId
                ).apply {
                    setSmallIcon(getDrawableResourceId(context, "ic_launcher"))
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
                notifyToFlutter(jsonMessage, it)
            }
        }
    }

    private fun notifyToFlutter(jsonMessage: String, mqtt3Publish: Mqtt3Publish?) {
        // TODO : Implementation ส่ง Notification ไปฝั่ง Flutter
        mqtt3Publish?.acknowledge()
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

    private suspend fun connect(MQTTConnectionSetting: MQTTConnectionSetting) {
        Log.d(TAG, "Before coroutineScope")
        coroutineScope {
            Log.d(TAG, "begin coroutineScope")
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
            Log.d(TAG, "end coroutineScope")
        }
        Log.d(TAG, "After coroutineScope")
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

    companion object {
        private val TAG = HiveMqttNotificationServiceWorker::class.java.simpleName

        private lateinit var channelId: String
        private var topic: String? = null
        private var mqtt3AsyncClient: Mqtt3AsyncClient? = null
        var isConnected: Boolean = false

        private fun getDrawableResourceId(context: Context, name: String): Int {
            return context.resources.getIdentifier(name, "mipmap", context.packageName)
        }

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
                                successCallback?.invoke()
                            }
                        }
                    }
                }
            }
        }
    }

}