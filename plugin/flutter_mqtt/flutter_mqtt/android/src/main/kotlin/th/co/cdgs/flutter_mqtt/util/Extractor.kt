package th.co.cdgs.flutter_mqtt.util

import io.flutter.plugin.common.MethodCall
import th.co.cdgs.flutter_mqtt.entity.MQTTConnectionSetting
import th.co.cdgs.flutter_mqtt.entity.PlatformNotificationSetting
import th.co.cdgs.flutter_mqtt.util.FlutterMqttCall.Initialize.KEYS.INITIALIZE_ANDROID_NOTIFICATION_ACTIONS_KEY
import th.co.cdgs.flutter_mqtt.util.FlutterMqttCall.Initialize.KEYS.INITIALIZE_RECEIVE_BACKGROUND_NOTIFICATION_CALLBACK_HANDLE_KEY
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
import th.co.cdgs.flutter_mqtt.util.FlutterMqttCall.Initialize.KEYS.INITIALIZE_TAP_ACTION_BACKGROUND_NOTIFICATION_CALLBACK_HANDLE_KEY
import th.co.cdgs.flutter_mqtt.util.FlutterMqttCall.Initialize.KEYS.INITIALIZE_TOPIC_KEY
import th.co.cdgs.flutter_mqtt.util.FlutterMqttCall.Initialize.KEYS.INITIALIZE_USERNAME_KEY

sealed class FlutterMqttCall {
    data class Initialize(
        val MQTTConnectionSetting: MQTTConnectionSetting,
        val platformNotificationSettings: PlatformNotificationSetting,
        val dispatcherHandle: Long?,
        val receiveBackgroundNotificationCallbackHandle: Long?,
        val tapActionBackgroundNotificationCallbackHandle: Long?,
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
            const val INITIALIZE_ANDROID_NOTIFICATION_ACTIONS_KEY = "actions"
            const val INITIALIZE_ANDROID_NOTIFICATION_ACTIONS_ID_KEY = "id"
            const val INITIALIZE_ANDROID_NOTIFICATION_ACTIONS_TITLE_KEY = "title"
            const val INITIALIZE_ANDROID_NOTIFICATION_ACTIONS_TITLE_COLOR_ALPHA_KEY =
                "titleColorAlpha"
            const val INITIALIZE_ANDROID_NOTIFICATION_ACTIONS_TITLE_COLOR_RED_KEY = "titleColorRed"
            const val INITIALIZE_ANDROID_NOTIFICATION_ACTIONS_TITLE_COLOR_GREEN_KEY =
                "titleColorGreen"
            const val INITIALIZE_ANDROID_NOTIFICATION_ACTIONS_TITLE_COLOR_BLUE_KEY =
                "titleColorBlue"
            const val INITIALIZE_ANDROID_NOTIFICATION_ACTIONS_ICON_KEY = "icon"
            const val INITIALIZE_ANDROID_NOTIFICATION_ACTIONS_ICON_BITMAP_SOURCE_KEY =
                "iconBitmapSource"
            const val INITIALIZE_ANDROID_NOTIFICATION_ACTIONS_CONTEXUAL_KEY = "contextual"
            const val INITIALIZE_ANDROID_NOTIFICATION_ACTIONS_SHOW_USER_INTERFACE_KEY =
                "showsUserInterface"
            const val INITIALIZE_ANDROID_NOTIFICATION_ACTIONS_CANCEL_NOTIFICATION_KEY =
                "cancelNotification"


            const val INITIALIZE_DISPATCHER_HANDLE_KEY = "dispatcher_handle"
            const val INITIALIZE_RECEIVE_BACKGROUND_NOTIFICATION_CALLBACK_HANDLE_KEY = "receive_background_notification_callback_handle"
            const val INITIALIZE_TAP_ACTION_BACKGROUND_NOTIFICATION_CALLBACK_HANDLE_KEY = "tap_action_background_notification_callback_handle"

        }
    }

    object GetReceiveBackgroundNotificationCallbackHandle : FlutterMqttCall()

    object GetTapActionBackgroundNotificationCallbackHandle : FlutterMqttCall()

    object BackgroundChannelInitialized : FlutterMqttCall()

    object GetNotificationAppLaunchDetails : FlutterMqttCall()

    object CancelAll : FlutterMqttCall()

    object Unknown : FlutterMqttCall()
}

object Extractor {
    private enum class PossibleFlutterMqttCall(val rawMethodName: String?) {
        INITIALIZE("initialize"),
        CANCEL_ALL("cancelAll"),
        GET_RECEIVE_BACKGROUND_NOTIFICATION_CALLBACK_HANDLE("getReceiveBackgroundNotificationCallbackHandle"),
        GET_TAP_ACTION_BACKGROUND_NOTIFICATION_CALLBACK_HANDLE("getTapActionBackgroundNotificationCallbackHandle"),
        BACKGROUND_CHANNEL_INITIALIZED("backgroundChannelInitialized"),
        GET_NOTIFICATION_APP_LAUNCH_DETAILS("getNotificationAppLaunchDetails"),

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
                val receiveBackgroundNotificationCallbackHandle = arguments?.get(
                    INITIALIZE_RECEIVE_BACKGROUND_NOTIFICATION_CALLBACK_HANDLE_KEY
                ) as Long?
                val tapActionBackgroundNotificationCallbackHandle = arguments?.get(
                    INITIALIZE_TAP_ACTION_BACKGROUND_NOTIFICATION_CALLBACK_HANDLE_KEY
                ) as Long?

                FlutterMqttCall.Initialize(
                    MQTTConnectionSetting = mqttConnectionSetting,
                    platformNotificationSettings = platformNotificationSetting,
                    dispatcherHandle = dispatcherHandle,
                    receiveBackgroundNotificationCallbackHandle = receiveBackgroundNotificationCallbackHandle,
                    tapActionBackgroundNotificationCallbackHandle = tapActionBackgroundNotificationCallbackHandle,
                )
            }
            PossibleFlutterMqttCall.GET_RECEIVE_BACKGROUND_NOTIFICATION_CALLBACK_HANDLE -> FlutterMqttCall.GetReceiveBackgroundNotificationCallbackHandle
            PossibleFlutterMqttCall.GET_TAP_ACTION_BACKGROUND_NOTIFICATION_CALLBACK_HANDLE -> FlutterMqttCall.GetTapActionBackgroundNotificationCallbackHandle
            PossibleFlutterMqttCall.BACKGROUND_CHANNEL_INITIALIZED -> FlutterMqttCall.BackgroundChannelInitialized
            PossibleFlutterMqttCall.GET_NOTIFICATION_APP_LAUNCH_DETAILS -> FlutterMqttCall.GetNotificationAppLaunchDetails
            PossibleFlutterMqttCall.CANCEL_ALL -> FlutterMqttCall.CancelAll
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
        val actions = platformNotificationSetting?.get(INITIALIZE_ANDROID_NOTIFICATION_ACTIONS_KEY) as List<Map<String, Any>>?

//        val actions: List<AndroidNotificationAction>? =
//            (platformNotificationSetting?.get(INITIALIZE_ANDROID_NOTIFICATION_ACTIONS_KEY) as List<Map<String, Object>>?)?.let {
//                it.map { action ->
//                    return@map AndroidNotificationAction(action)
//                }
//            }

        return PlatformNotificationSetting(
            channelId = channelId,
            channelName = channelName,
            notificationIcon = notificationIcon,
            actions = actions,
        )
    }
}