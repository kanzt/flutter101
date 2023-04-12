package th.co.cdgs.flutter_mqtt_plugin.service

import android.app.Service
import android.content.Intent
import android.os.IBinder
import android.util.Log
import kotlinx.coroutines.*
import th.co.cdgs.flutter_mqtt_plugin.receiver.TaskRemoveReceiver

class DetectTaskRemoveService : Service() {
    private val scope: CoroutineScope = CoroutineScope(Job() + Dispatchers.IO)
    override fun onBind(intent: Intent?): IBinder? {
        return null
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {

//        counting()

        return START_STICKY
    }

    @Suppress("unused")
    private fun counting() {
        scope.launch {
            repeat(100) {
                delay(2000)
                Log.d(TAG, it.toString())
            }
        }
    }

    override fun onDestroy() {
        Log.d(TAG, "onDestroy is working")
        scope.cancel()
        super.onDestroy()
    }

    override fun onTaskRemoved(rootIntent: Intent?) {
        Log.d(TAG, "onTaskRemoved is working")
        val broadcastIntent = Intent(this, TaskRemoveReceiver::class.java)
        this.sendBroadcast(broadcastIntent)
        super.onTaskRemoved(rootIntent)
    }

    companion object {
        private val TAG = DetectTaskRemoveService::class.java.simpleName
    }
}