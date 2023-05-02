package th.co.cdgs.flutter_mqtt_plugin.util

import io.flutter.plugin.common.MethodChannel
import th.co.cdgs.flutter_mqtt_plugin.entity.ConnectionSetting

object ConnectionHelper {
    private const val INVALID_CONNECTION_ERROR_CODE = "invalid_connection_config"
    private const val INVALID_CONNECTION_CONFIG_ERROR_MESSAGE =
        ("Invalid connection configuration.Please review the values and retry again")

    fun hasInvalidConnectionConfig(
        connectionSetting: ConnectionSetting,
        result: MethodChannel.Result
    ): Boolean {
        if (connectionSetting.hostname.isNullOrBlankOrEmpty() ||
            connectionSetting.userName.isNullOrBlankOrEmpty() ||
            connectionSetting.password.isNullOrBlankOrEmpty() ||
            connectionSetting.topic.isNullOrBlankOrEmpty() ||
            connectionSetting.clientId.isNullOrBlankOrEmpty()
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
}