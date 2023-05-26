package th.co.cdgs.flutter_mqtt.receiver

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import th.co.cdgs.flutter_mqtt.util.WorkManagerRequestHelper


class TaskRemoveReceiver : BroadcastReceiver() {

    companion object {
        private val TAG = TaskRemoveReceiver::class.java.simpleName
    }

    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action.equals(context.packageName + ".TASK_REMOVE_RECEIVER")) {
            WorkManagerRequestHelper.startPeriodicWorker(context)
        }
    }
}