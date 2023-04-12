package th.co.cdgs.flutter_mqtt_plugin.entity


data class Config(
    val isRequiredSSL: Boolean,
    val hostname: String,
    val password: String,
    val userName: String,
    val topic: String,
    val clientId: String,
)