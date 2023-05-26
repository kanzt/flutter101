package th.co.cdgs.flutter_mqtt.entity

import com.google.gson.annotations.SerializedName

data class PlatformNotificationSetting(
    @SerializedName("channelId")
    val channelId: String?,
    @SerializedName("channelName")
    val channelName: String?,
    @SerializedName("notificationIcon")
    val notificationIcon: String?,
    @SerializedName("actions")
    val actions: List<Map<String, Any>>?,
)
