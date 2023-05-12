package th.co.cdgs.flutter_mqtt.util

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context
import android.graphics.Color
import android.os.Build.VERSION
import android.os.Build.VERSION_CODES

object NotificationHelper {
    const val GROUP_PUSH_NOTIFICATION_ID = 1
    const val GROUP_KEY_MESSAGE =
        "th.co.cdgs.flutter_mqtt.workmanager.HiveMqttNotificationServiceWorker"

    // Arguments
    const val NOTIFICATION_ID = "notificationId"
    const val ACTION_ID = "actionId"
    const val NOTIFICATION_PAYLOAD = "payload"
    const val NOTIFICATION_RESPONSE_TYPE = "notificationResponseType"

    // Intent action
    const val SELECT_NOTIFICATION = "SELECT_NOTIFICATION"
    const val CANCEL_NOTIFICATION = "CANCEL_NOTIFICATION"
    const val SELECT_FOREGROUND_NOTIFICATION_ACTION = "SELECT_FOREGROUND_NOTIFICATION_ACTION"

    fun createNotificationChannel(
        context: Context,
        channelId: String,
        channelName: String
    ) {
        if (VERSION.SDK_INT >= VERSION_CODES.O) {
            val channel: NotificationChannel = NotificationChannel(
                channelId, channelName, NotificationManager.IMPORTANCE_HIGH
            ).also {
                it.lightColor = Color.BLUE
                it.lockscreenVisibility = Notification.VISIBILITY_PRIVATE
            }
            (context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager).also {
                it.createNotificationChannel(channel)
            }
        }
    }
}