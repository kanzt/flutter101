package th.co.cdgs.flutter_mqtt_plugin.util

import io.flutter.plugin.common.MethodCall
import th.co.cdgs.flutter_mqtt_plugin.entity.ConnectionSetting
import th.co.cdgs.flutter_mqtt_plugin.entity.NotificationSetting
import th.co.cdgs.flutter_mqtt_plugin.util.FlutterMqttCall.ConnectMqtt.KEYS.CONNECT_MQTT_PLATFORM_NOTIFICATION_SETTING_KEY
import th.co.cdgs.flutter_mqtt_plugin.util.FlutterMqttCall.ConnectMqtt.KEYS.CONNECT_MQTT_CHANNEL_ID_KEY
import th.co.cdgs.flutter_mqtt_plugin.util.FlutterMqttCall.ConnectMqtt.KEYS.CONNECT_MQTT_CHANNEL_NAME_KEY
import th.co.cdgs.flutter_mqtt_plugin.util.FlutterMqttCall.ConnectMqtt.KEYS.CONNECT_MQTT_CLIENT_ID_KEY
import th.co.cdgs.flutter_mqtt_plugin.util.FlutterMqttCall.ConnectMqtt.KEYS.CONNECT_MQTT_CONNECTION_KEY
import th.co.cdgs.flutter_mqtt_plugin.util.FlutterMqttCall.ConnectMqtt.KEYS.CONNECT_MQTT_HOSTNAME_KEY
import th.co.cdgs.flutter_mqtt_plugin.util.FlutterMqttCall.ConnectMqtt.KEYS.CONNECT_MQTT_IS_REQUIRED_SSL_KEY
import th.co.cdgs.flutter_mqtt_plugin.util.FlutterMqttCall.ConnectMqtt.KEYS.CONNECT_MQTT_NOTIFICATION_ICON_KEY
import th.co.cdgs.flutter_mqtt_plugin.util.FlutterMqttCall.ConnectMqtt.KEYS.CONNECT_MQTT_PASSWORD_KEY
import th.co.cdgs.flutter_mqtt_plugin.util.FlutterMqttCall.ConnectMqtt.KEYS.CONNECT_MQTT_SOUND_KEY
import th.co.cdgs.flutter_mqtt_plugin.util.FlutterMqttCall.ConnectMqtt.KEYS.CONNECT_MQTT_TOPIC_KEY
import th.co.cdgs.flutter_mqtt_plugin.util.FlutterMqttCall.ConnectMqtt.KEYS.CONNECT_MQTT_USERNAME_KEY

sealed class FlutterMqttCall {
    data class ConnectMqtt(
        val connectionSetting: ConnectionSetting,
        val notificationSettings: NotificationSetting
    ) : FlutterMqttCall() {
        companion object KEYS {
            const val CONNECT_MQTT_CONNECTION_KEY = "connectionSetting"
            const val CONNECT_MQTT_HOSTNAME_KEY = "hostname"
            const val CONNECT_MQTT_USERNAME_KEY = "username"
            const val CONNECT_MQTT_PASSWORD_KEY = "password"
            const val CONNECT_MQTT_CLIENT_ID_KEY = "clientId"
            const val CONNECT_MQTT_TOPIC_KEY = "topic"
            const val CONNECT_MQTT_IS_REQUIRED_SSL_KEY = "isRequiredSSL"


            const val CONNECT_MQTT_PLATFORM_NOTIFICATION_SETTING_KEY = "platformNotificationSetting"
            const val CONNECT_MQTT_CHANNEL_NAME_KEY = "channelName"
            const val CONNECT_MQTT_CHANNEL_ID_KEY = "channelId"
            const val CONNECT_MQTT_NOTIFICATION_ICON_KEY = "notificationIcon"
            const val CONNECT_MQTT_SOUND_KEY = "sound"
        }
    }

    object GetNotificationAppLaunchDetails : FlutterMqttCall()

    object Disconnect : FlutterMqttCall()

    object Unknown : FlutterMqttCall()
}

object Extractor {
    private enum class PossibleFlutterMqttCall(val rawMethodName: String?) {
        CONNECT_MQTT("connectMQTT"),
        DISCONNECT("disconnectMQTT"),

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
            PossibleFlutterMqttCall.CONNECT_MQTT -> {
                val arguments = call.arguments as Map<*, *>?

                // Connection configuration
                val connectionSetting =
                    readConnectionSetting(arguments?.get(CONNECT_MQTT_CONNECTION_KEY) as Map<*, *>?)

                // Notification configuration
                val notificationSetting =
                    readAndroidNotificationSetting(arguments?.get(
                        CONNECT_MQTT_PLATFORM_NOTIFICATION_SETTING_KEY) as Map<*, *>?)

                FlutterMqttCall.ConnectMqtt(
                    connectionSetting = connectionSetting,
                    notificationSettings = notificationSetting,
                )
            }
            PossibleFlutterMqttCall.DISCONNECT -> FlutterMqttCall.Disconnect
            PossibleFlutterMqttCall.UNKNOWN -> FlutterMqttCall.Unknown
        }

    private fun readConnectionSetting(connectionSettingMap: Map<*, *>?): ConnectionSetting {
        val username = connectionSettingMap?.get(CONNECT_MQTT_USERNAME_KEY) as String?
        val password = connectionSettingMap?.get(CONNECT_MQTT_PASSWORD_KEY) as String?
        val hostname = connectionSettingMap?.get(CONNECT_MQTT_HOSTNAME_KEY) as String?
        val clientId = connectionSettingMap?.get(CONNECT_MQTT_CLIENT_ID_KEY) as String?
        val topic = connectionSettingMap?.get(CONNECT_MQTT_TOPIC_KEY) as String?
        val isRequiredSSL = connectionSettingMap?.get(CONNECT_MQTT_IS_REQUIRED_SSL_KEY) as Boolean?

        return ConnectionSetting(
            userName = username,
            password = password,
            hostname = hostname,
            clientId = clientId,
            topic = topic,
            isRequiredSSL = isRequiredSSL
        )
    }

    private fun readAndroidNotificationSetting(platformNotificationSetting: Map<*, *>?): NotificationSetting {
        val channelId = platformNotificationSetting?.get(CONNECT_MQTT_CHANNEL_ID_KEY) as String?
        val channelName = platformNotificationSetting?.get(CONNECT_MQTT_CHANNEL_NAME_KEY) as String?
        val notificationIcon =
            platformNotificationSetting?.get(CONNECT_MQTT_NOTIFICATION_ICON_KEY) as String?
        val sound = platformNotificationSetting?.get(CONNECT_MQTT_SOUND_KEY) as String?

        return NotificationSetting(
            channelId = channelId,
            channelName = channelName,
            notificationIcon = notificationIcon,
            sound = sound,
        )
    }
}