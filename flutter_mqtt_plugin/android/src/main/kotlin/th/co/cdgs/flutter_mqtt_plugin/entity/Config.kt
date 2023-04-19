package th.co.cdgs.flutter_mqtt_plugin.entity

import android.os.Parcelable
import com.google.gson.annotations.SerializedName
import kotlinx.parcelize.Parcelize

@Parcelize
data class Config(
    @SerializedName("isRequiredSSL")
    val isRequiredSSL: Boolean,
    @SerializedName("hostname")
    val hostname: String,
    @SerializedName("password")
    val password: String,
    @SerializedName("userName")
    val userName: String,
    @SerializedName("topic")
    val topic: String,
    @SerializedName("clientId")
    val clientId: String,
) : Parcelable