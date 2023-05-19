package th.co.cdgs.flutter_mqtt.entity

import android.graphics.Color
import android.os.Parcelable
import android.util.Log
import com.google.gson.annotations.SerializedName
import kotlinx.parcelize.Parcelize
import th.co.cdgs.flutter_mqtt.util.FlutterMqttCall.Initialize.KEYS.INITIALIZE_ANDROID_NOTIFICATION_ACTIONS_CANCEL_NOTIFICATION_KEY
import th.co.cdgs.flutter_mqtt.util.FlutterMqttCall.Initialize.KEYS.INITIALIZE_ANDROID_NOTIFICATION_ACTIONS_CONTEXUAL_KEY
import th.co.cdgs.flutter_mqtt.util.FlutterMqttCall.Initialize.KEYS.INITIALIZE_ANDROID_NOTIFICATION_ACTIONS_ICON_BITMAP_SOURCE_KEY
import th.co.cdgs.flutter_mqtt.util.FlutterMqttCall.Initialize.KEYS.INITIALIZE_ANDROID_NOTIFICATION_ACTIONS_ICON_KEY
import th.co.cdgs.flutter_mqtt.util.FlutterMqttCall.Initialize.KEYS.INITIALIZE_ANDROID_NOTIFICATION_ACTIONS_ID_KEY
import th.co.cdgs.flutter_mqtt.util.FlutterMqttCall.Initialize.KEYS.INITIALIZE_ANDROID_NOTIFICATION_ACTIONS_SHOW_USER_INTERFACE_KEY
import th.co.cdgs.flutter_mqtt.util.FlutterMqttCall.Initialize.KEYS.INITIALIZE_ANDROID_NOTIFICATION_ACTIONS_TITLE_COLOR_ALPHA_KEY
import th.co.cdgs.flutter_mqtt.util.FlutterMqttCall.Initialize.KEYS.INITIALIZE_ANDROID_NOTIFICATION_ACTIONS_TITLE_COLOR_BLUE_KEY
import th.co.cdgs.flutter_mqtt.util.FlutterMqttCall.Initialize.KEYS.INITIALIZE_ANDROID_NOTIFICATION_ACTIONS_TITLE_COLOR_GREEN_KEY
import th.co.cdgs.flutter_mqtt.util.FlutterMqttCall.Initialize.KEYS.INITIALIZE_ANDROID_NOTIFICATION_ACTIONS_TITLE_COLOR_RED_KEY
import th.co.cdgs.flutter_mqtt.util.FlutterMqttCall.Initialize.KEYS.INITIALIZE_ANDROID_NOTIFICATION_ACTIONS_TITLE_KEY

@Parcelize
data class AndroidNotificationAction(
    @SerializedName("id")
    var id: String? = null,
    @SerializedName("title")
    var title: String? = null,
    @SerializedName("titleColor")
    var titleColor: Int? = null,
    @SerializedName("icon")
    var icon: String? = null,
    @SerializedName("iconSource")
    var iconSource: IconSource? = null,
    @SerializedName("contextual")
    var contextual: Boolean? = null,
    @SerializedName("showsUserInterface")
    var showsUserInterface: Boolean? = null,
    @SerializedName("cancelNotification")
    var cancelNotification: Boolean? = null,
) : Parcelable {

    constructor(arguments: Map<String, Any>) : this() {
        this.id = arguments[INITIALIZE_ANDROID_NOTIFICATION_ACTIONS_ID_KEY] as String?
        this.title = arguments[INITIALIZE_ANDROID_NOTIFICATION_ACTIONS_TITLE_KEY] as String?

        val titleColorAlpha = arguments[INITIALIZE_ANDROID_NOTIFICATION_ACTIONS_TITLE_COLOR_ALPHA_KEY] as Int?
        val titleColorRed = arguments[INITIALIZE_ANDROID_NOTIFICATION_ACTIONS_TITLE_COLOR_RED_KEY] as Int?
        val titleColorGreen = arguments[INITIALIZE_ANDROID_NOTIFICATION_ACTIONS_TITLE_COLOR_GREEN_KEY] as Int?
        val titleColorBlue = arguments[INITIALIZE_ANDROID_NOTIFICATION_ACTIONS_TITLE_COLOR_BLUE_KEY] as Int?
        if (titleColorAlpha != null && titleColorRed != null && titleColorGreen != null && titleColorBlue != null) {
            this.titleColor = Color.argb(titleColorAlpha, titleColorRed, titleColorGreen, titleColorBlue)
        } else {
            this.titleColor = null
        }

        this.icon = arguments[INITIALIZE_ANDROID_NOTIFICATION_ACTIONS_ICON_KEY] as String?

        val iconSourceIndex = arguments[INITIALIZE_ANDROID_NOTIFICATION_ACTIONS_ICON_BITMAP_SOURCE_KEY] as Int?
        this.iconSource = if (iconSourceIndex != null) {
            IconSource.values()[iconSourceIndex]
        } else {
            null
        }

        this.contextual = arguments[INITIALIZE_ANDROID_NOTIFICATION_ACTIONS_CONTEXUAL_KEY] as Boolean?
        this.showsUserInterface = arguments[INITIALIZE_ANDROID_NOTIFICATION_ACTIONS_SHOW_USER_INTERFACE_KEY] as Boolean?
        this.cancelNotification = arguments[INITIALIZE_ANDROID_NOTIFICATION_ACTIONS_CANCEL_NOTIFICATION_KEY] as Boolean?
    }
}
