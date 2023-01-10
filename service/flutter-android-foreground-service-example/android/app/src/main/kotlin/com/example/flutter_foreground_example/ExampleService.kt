package com.example.flutter_foreground_example

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.Service
import android.content.Context
import android.content.Intent
import android.graphics.Color
import android.os.Build
import android.os.IBinder
import android.util.Log
import androidx.annotation.RequiresApi
import androidx.core.app.NotificationCompat
import kotlinx.coroutines.*

class ExampleService : Service() {
    val notificationId = 1
    var serviceRunning = false
    lateinit var builder: NotificationCompat.Builder
    lateinit var channel: NotificationChannel
    lateinit var manager: NotificationManager

    companion object {
        val TAG = ExampleService::class.java.simpleName
    }

    private val serviceJob = Job()
    private val serviceScope = CoroutineScope(Dispatchers.IO + serviceJob)

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        GlobalScope
        Log.d(TAG, "Service is running with ID : $startId")
        startForeground(startId)
        serviceRunning = true
        serviceScope.launch {
            delay(5000)
            if (serviceRunning) {
                updateNotification("I got updated! $startId", startId)

                launch {
                    while (true) {
                        if (isActive) {
                            delay(1000)
                            Log.d(TAG, "Running from ID : $startId")
                        }
                    }
                }
            }
        }
        return START_STICKY
    }

    override fun onDestroy() {
        serviceRunning = false
        Log.d(TAG, "Service is destroyed")
        serviceScope.cancel()
        super.onDestroy()
    }

    @RequiresApi(Build.VERSION_CODES.O)
    private fun createNotificationChannel(channelId: String, channelName: String): String {
        channel = NotificationChannel(
            channelId,
            channelName, NotificationManager.IMPORTANCE_NONE
        )
        channel.lightColor = Color.BLUE
        channel.lockscreenVisibility = Notification.VISIBILITY_PRIVATE
        manager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        manager.createNotificationChannel(channel)
        return channelId
    }

    private fun startForeground(notificationId: Int) {
        val channelId =
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                createNotificationChannel("example_service", "Example Service")
            } else {
                // If earlier version channel ID is not used
                // https://developer.android.com/reference/android/support/v4/app/NotificationCompat.Builder.html#NotificationCompat.Builder(android.content.Context)
                ""
            }
        builder = NotificationCompat.Builder(this, channelId)
        builder
            .setOngoing(true)
            .setOnlyAlertOnce(true)
            .setSmallIcon(R.mipmap.ic_launcher)
            .setContentTitle("Example Service")
            .setContentText("Example Serivce is running")
            .setCategory(Notification.CATEGORY_SERVICE)
        startForeground(notificationId, builder.build())
    }

    private fun updateNotification(text: String, notificationId: Int) {
        builder
            .setContentText(text)
        manager.notify(notificationId, builder.build());
    }

    override fun onBind(intent: Intent): IBinder? {
        return null
    }
}
