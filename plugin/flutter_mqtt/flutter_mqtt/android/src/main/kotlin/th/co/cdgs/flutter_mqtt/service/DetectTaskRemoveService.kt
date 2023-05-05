package th.co.cdgs.flutter_mqtt.service

import android.app.Service
import android.content.Intent
import android.os.IBinder
import android.util.Log
import th.co.cdgs.flutter_mqtt.receiver.TaskRemoveReceiver

class DetectTaskRemoveService : Service() {

    override fun onBind(intent: Intent?): IBinder? {
        return null
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        return START_STICKY
    }

    override fun onDestroy() {
        Log.d(TAG, "onDestroy is working")
        super.onDestroy()
    }

    override fun onTaskRemoved(rootIntent: Intent?) {
        Log.d(TAG, "onTaskRemoved is working")
        val broadcastIntent = Intent(this, TaskRemoveReceiver::class.java).also {
            it.action = "$packageName.TASK_REMOVE_RECEIVER"
        }
        this.sendBroadcast(broadcastIntent)
        super.onTaskRemoved(rootIntent)
    }

    companion object {
        private val TAG = DetectTaskRemoveService::class.java.simpleName
    }
}