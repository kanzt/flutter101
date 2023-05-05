package th.co.cdgs.flutter_mqtt.util

import io.flutter.plugin.common.MethodCall
import th.co.cdgs.flutter_mqtt.entity.MQTTConnectionSetting
import th.co.cdgs.flutter_mqtt.entity.PlatformNotificationSetting
import th.co.cdgs.flutter_mqtt.util.FlutterMqttCall.Initialize.KEYS.INITIALIZE_CALLBACK_HANDLE_KEY
import th.co.cdgs.flutter_mqtt.util.FlutterMqttCall.Initialize.KEYS.INITIALIZE_CHANNEL_ID_KEY
import th.co.cdgs.flutter_mqtt.util.FlutterMqttCall.Initialize.KEYS.INITIALIZE_CHANNEL_NAME_KEY
import th.co.cdgs.flutter_mqtt.util.FlutterMqttCall.Initialize.KEYS.INITIALIZE_CLIENT_ID_KEY
import th.co.cdgs.flutter_mqtt.util.FlutterMqttCall.Initialize.KEYS.INITIALIZE_DISPATCHER_HANDLE_KEY
import th.co.cdgs.flutter_mqtt.util.FlutterMqttCall.Initialize.KEYS.INITIALIZE_HOSTNAME_KEY
import th.co.cdgs.flutter_mqtt.util.FlutterMqttCall.Initialize.KEYS.INITIALIZE_IS_REQUIRED_SSL_KEY
import th.co.cdgs.flutter_mqtt.util.FlutterMqttCall.Initialize.KEYS.INITIALIZE_MQTT_CONNECTION_SETTING_KEY
import th.co.cdgs.flutter_mqtt.util.FlutterMqttCall.Initialize.KEYS.INITIALIZE_NOTIFICATION_ICON_KEY
import th.co.cdgs.flutter_mqtt.util.FlutterMqttCall.Initialize.KEYS.INITIALIZE_PASSWORD_KEY
import th.co.cdgs.flutter_mqtt.util.FlutterMqttCall.Initialize.KEYS.INITIALIZE_PLATFORM_NOTIFICATION_SETTING_KEY
import th.co.cdgs.flutter_mqtt.util.FlutterMqttCall.Initialize.KEYS.INITIALIZE_TOPIC_KEY
import th.co.cdgs.flutter_mqtt.util.FlutterMqttCall.Initialize.KEYS.INITIALIZE_USERNAME_KEY

sealed class FlutterMqttCall {
    data class Initialize(
        val MQTTConnectionSetting: MQTTConnectionSetting,
        val platformNotificationSettings: PlatformNotificationSetting,
        val dispatcherHandle: Long?,
        val callbackHandle: Long?,
    ) : FlutterMqttCall() {
        companion object KEYS {
            const val INITIALIZE_MQTT_CONNECTION_SETTING_KEY = "mqttConnectionSetting"
            const val INITIALIZE_HOSTNAME_KEY = "hostname"
            const val INITIALIZE_USERNAME_KEY = "username"
            const val INITIALIZE_PASSWORD_KEY = "password"
            const val INITIALIZE_CLIENT_ID_KEY = "clientId"
            const val INITIALIZE_TOPIC_KEY = "topic"
            const val INITIALIZE_IS_REQUIRED_SSL_KEY = "isRequiredSSL"


            const val INITIALIZE_PLATFORM_NOTIFICATION_SETTING_KEY = "platformNotificationSetting"
            const val INITIALIZE_CHANNEL_NAME_KEY = "channelName"
            const val INITIALIZE_CHANNEL_ID_KEY = "channelId"
            const val INITIALIZE_NOTIFICATION_ICON_KEY = "notificationIcon"

            const val INITIALIZE_DISPATCHER_HANDLE_KEY = "dispatcher_handle"
            const val INITIALIZE_CALLBACK_HANDLE_KEY = "callback_handle"
        }
    }

    object CancelAll : FlutterMqttCall()

    object Unknown : FlutterMqttCall()
}

object Extractor {
    private enum class PossibleFlutterMqttCall(val rawMethodName: String?) {
        INITIALIZE("initialize"),
        DISCONNECT("cancelAll"),

        UNKNOWN(null);

        companion object {
            fun fromRawMethodName(methodName: String): PossibleFlutterMqttCall =
                values()
                    .filter { !it.rawMethodName.isNullOrEmpty() }
                    .firstOrNull { it.rawMethodName == methodName }
                    ?: UNKNOWN
        }
    }

    fun extractFlutterMqttCallFromRawMethodName(call: MethodCall): FlutterMqttCall =
        when (PossibleFlutterMqttCall.fromRawMethodName(call.method)) {
            PossibleFlutterMqttCall.INITIALIZE -> {
                val arguments = call.arguments as Map<*, *>?

                // Connection configuration
                val mqttConnectionSetting =
                    readConnectionSetting(arguments?.get(INITIALIZE_MQTT_CONNECTION_SETTING_KEY) as Map<*, *>?)

                // Notification configuration
                val platformNotificationSetting =
                    readPlatformNotificationSetting(
                        arguments?.get(
                            INITIALIZE_PLATFORM_NOTIFICATION_SETTING_KEY
                        ) as Map<*, *>?
                    )

                // Callback
                val dispatcherHandle = arguments?.get(
                    INITIALIZE_DISPATCHER_HANDLE_KEY
                ) as Long?
                val callbackHandle = arguments?.get(
                    INITIALIZE_CALLBACK_HANDLE_KEY
                ) as Long?

                FlutterMqttCall.Initialize(
                    MQTTConnectionSetting = mqttConnectionSetting,
                    platformNotificationSettings = platformNotificationSetting,
                    dispatcherHandle = dispatcherHandle,
                    callbackHandle = callbackHandle,
                )
            }
            PossibleFlutterMqttCall.DISCONNECT -> FlutterMqttCall.CancelAll
            PossibleFlutterMqttCall.UNKNOWN -> FlutterMqttCall.Unknown
        }

    private fun readConnectionSetting(connectionSettingMap: Map<*, *>?): MQTTConnectionSetting {
        val username = connectionSettingMap?.get(INITIALIZE_USERNAME_KEY) as String?
        val password = connectionSettingMap?.get(INITIALIZE_PASSWORD_KEY) as String?
        val hostname = connectionSettingMap?.get(INITIALIZE_HOSTNAME_KEY) as String?
        val clientId = connectionSettingMap?.get(INITIALIZE_CLIENT_ID_KEY) as String?
        val topic = connectionSettingMap?.get(INITIALIZE_TOPIC_KEY) as String?
        val isRequiredSSL = connectionSettingMap?.get(INITIALIZE_IS_REQUIRED_SSL_KEY) as Boolean?

        return MQTTConnectionSetting(
            userName = username,
            password = password,
            hostname = hostname,
            clientId = clientId,
            topic = topic,
            isRequiredSSL = isRequiredSSL
        )
    }

    private fun readPlatformNotificationSetting(platformNotificationSetting: Map<*, *>?): PlatformNotificationSetting {
        val channelId = platformNotificationSetting?.get(INITIALIZE_CHANNEL_ID_KEY) as String?
        val channelName = platformNotificationSetting?.get(INITIALIZE_CHANNEL_NAME_KEY) as String?
        val notificationIcon =
            platformNotificationSetting?.get(INITIALIZE_NOTIFICATION_ICON_KEY) as String?

        return PlatformNotificationSetting(
            channelId = channelId,
            channelName = channelName,
            notificationIcon = notificationIcon,
        )
    }
}