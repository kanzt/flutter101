package com.example.flutter_foreground_example

import android.app.Service
import android.content.Intent
import android.os.IBinder
import android.util.Log
import kotlinx.coroutines.*

class ExampleBackgroundService : Service() {
    var serviceRunning = false

    private val serviceJob = Job()
    private val serviceScope = CoroutineScope(Dispatchers.IO + serviceJob)

    companion object{
        val TAG = ExampleBackgroundService::class.java.simpleName
    }

    override fun onCreate() {
        super.onCreate()
        serviceRunning = true
    }

    override fun onDestroy() {
        serviceRunning = false
        serviceJob.cancel()
        Log.d(TAG, "Service stopped")
        super.onDestroy()
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        Log.d(TAG, "Service restarting")
        serviceScope.launch {

            // เนื่องจากภายใน downloadUserData เรียกใช้งาน coroutineScope ดังนั้นมันจะทำงานโค้ดข้างใน coroutineScope ให้เสร็จเรียบร้อยก่อน
            // จึงจะเริ่มทำ while loop
            downloadUserData()

            while (true){
                delay(5)
                Log.d(TAG, "I got updated!")
            }
        }
        return START_STICKY
    }

    override fun onBind(intent: Intent): IBinder? {
        return null
    }

    private suspend fun downloadUserData(): Int {
        var result = 0
        // By using coroutineScope (Smaller c version) below, we ensure that this coroutine would execute in the
        // parent/caller coroutine's scope, so it would make sure that the for loop would complete
        // before returning from this suspended function.
        coroutineScope {
            for (i in 0 until 100) {
                delay(10)
                Log.d(TAG, "Downloading : $i %")
                result++
            }
        }
        return result
    }
}
