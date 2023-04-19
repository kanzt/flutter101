package th.co.cdgs.flutter_mqtt_plugin.receiver

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log
import th.co.cdgs.flutter_mqtt_plugin.util.WorkManagerRequestUtil

class TaskRemoveReceiver : BroadcastReceiver() {

    companion object {
        private val TAG = TaskRemoveReceiver::class.java.simpleName
    }

    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action.equals(context.packageName + "TASK_REMOVE_RECEIVER")) {
            Log.d(TAG, "MyReceiver received event")
            WorkManagerRequestUtil.startOneTimeHiveMqttNotificationServiceWorker(context)
        }
    }
}