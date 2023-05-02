package th.co.cdgs.flutter_mqtt_plugin.util

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context
import android.graphics.Color
import android.os.Build.VERSION
import android.os.Build.VERSION_CODES

object NotificationHelper {
    const val CHANNEL_ID = "push_notification"
    const val CHANNEL_NAME = "Push notification"

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