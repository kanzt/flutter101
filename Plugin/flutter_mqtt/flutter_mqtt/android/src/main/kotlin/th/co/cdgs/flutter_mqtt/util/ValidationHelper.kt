package th.co.cdgs.flutter_mqtt.util

import io.flutter.plugin.common.MethodChannel
import th.co.cdgs.flutter_mqtt.entity.MQTTConnectionSetting
import th.co.cdgs.flutter_mqtt.entity.PlatformNotificationSetting

object ValidationHelper {
    private const val INVALID_CONNECTION_ERROR_CODE = "invalid_connection_config"
    private const val INVALID_CONNECTION_CONFIG_ERROR_MESSAGE =
        ("Invalid connection configuration.Please review the values and retry again")

    private const val INVALID_PLATFORM_NOTIFICATION_ERROR_CODE = "invalid_platform_notification_config"

    fun hasInvalidMQTTConnectionConfig(
        MQTTConnectionSetting: MQTTConnectionSetting,
        result: MethodChannel.Result
    ): Boolean {
        if (MQTTConnectionSetting.hostname.isNullOrBlankOrEmpty() ||
            MQTTConnectionSetting.userName.isNullOrBlankOrEmpty() ||
            MQTTConnectionSetting.password.isNullOrBlankOrEmpty() ||
            MQTTConnectionSetting.topic.isNullOrBlankOrEmpty() ||
            MQTTConnectionSetting.clientId.isNullOrBlankOrEmpty()
        ) {
            result.error(
                INVALID_CONNECTION_ERROR_CODE,
                INVALID_CONNECTION_CONFIG_ERROR_MESSAGE,
                null
            )
            return true
        }

        return false
    }

    fun hasInvalidPlatformNotificationSetting(
        platformNotificationSetting: PlatformNotificationSetting,
        result: MethodChannel.Result
    ): Boolean {
        if (platformNotificationSetting.channelId.isNullOrBlankOrEmpty() ||
            platformNotificationSetting.channelName.isNullOrBlankOrEmpty()
                ) {
            result.error(
                INVALID_PLATFORM_NOTIFICATION_ERROR_CODE,
                "Notification channel name or channel id is not defined",
                null
            )
            return true
        }

        return false
    }
}