package th.co.cdgs.flutter_mqtt_plugin.util

import io.flutter.plugin.common.MethodCall
import th.co.cdgs.flutter_mqtt_plugin.entity.Connection
import th.co.cdgs.flutter_mqtt_plugin.util.FlutterMqttCall.ConnectMqtt.KEYS.CONNECT_MQTT_CLIENT_ID_KEY
import th.co.cdgs.flutter_mqtt_plugin.util.FlutterMqttCall.ConnectMqtt.KEYS.CONNECT_MQTT_HOSTNAME_KEY
import th.co.cdgs.flutter_mqtt_plugin.util.FlutterMqttCall.ConnectMqtt.KEYS.CONNECT_MQTT_IS_REQUIRED_SSL_KEY
import th.co.cdgs.flutter_mqtt_plugin.util.FlutterMqttCall.ConnectMqtt.KEYS.CONNECT_MQTT_PASSWORD_KEY
import th.co.cdgs.flutter_mqtt_plugin.util.FlutterMqttCall.ConnectMqtt.KEYS.CONNECT_MQTT_TOPIC_KEY
import th.co.cdgs.flutter_mqtt_plugin.util.FlutterMqttCall.ConnectMqtt.KEYS.CONNECT_MQTT_USERNAME_KEY

sealed class FlutterMqttCall {
    data class ConnectMqtt(
        val connection: Connection,
    ) : FlutterMqttCall() {
        companion object KEYS {
            const val CONNECT_MQTT_HOSTNAME_KEY = "hostname"
            const val CONNECT_MQTT_USERNAME_KEY = "username"
            const val CONNECT_MQTT_PASSWORD_KEY = "password"
            const val CONNECT_MQTT_CLIENT_ID_KEY = "clientId"
            const val CONNECT_MQTT_TOPIC_KEY = "topic"
            const val CONNECT_MQTT_IS_REQUIRED_SSL_KEY = "isRequiredSSL"
        }
    }

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
                val username = call.argument<String>(CONNECT_MQTT_USERNAME_KEY)!!
                val password = call.argument<String>(CONNECT_MQTT_PASSWORD_KEY)!!
                val hostname = call.argument<String>(CONNECT_MQTT_HOSTNAME_KEY)!!
                val clientId = call.argument<String>(CONNECT_MQTT_CLIENT_ID_KEY)!!
                val topic = call.argument<String>(CONNECT_MQTT_TOPIC_KEY)!!
                val isRequiredSSL = call.argument<Boolean>(CONNECT_MQTT_IS_REQUIRED_SSL_KEY) ?: false

                FlutterMqttCall.ConnectMqtt(Connection(
                    userName = username,
                    password = password,
                    hostname = hostname,
                    clientId = clientId,
                    topic = topic,
                    isRequiredSSL = isRequiredSSL
                ))
            }
            PossibleFlutterMqttCall.DISCONNECT -> FlutterMqttCall.Disconnect
            PossibleFlutterMqttCall.UNKNOWN -> FlutterMqttCall.Unknown
        }
}