package th.co.cdgs.flutter_mqtt_plugin.entity

import android.os.Parcelable
import com.google.gson.annotations.SerializedName
import kotlinx.parcelize.Parcelize

@Parcelize
data class NotificationSetting(
    @SerializedName("channelId")
    val channelId : String?,
    @SerializedName("channelName")
    val channelName : String?,
    @SerializedName("notificationIcon")
    val notificationIcon : String?,
): Parcelable
