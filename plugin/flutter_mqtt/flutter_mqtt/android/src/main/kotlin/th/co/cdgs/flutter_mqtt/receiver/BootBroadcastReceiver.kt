package th.co.cdgs.flutter_mqtt.receiver

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import th.co.cdgs.flutter_mqtt.util.WorkManagerRequestHelper
import th.co.cdgs.flutter_mqtt.util.goAsync


/**
 * Run these command for testing (Only non-playstore emulator)
 * adb root
 * adb shell am broadcast -n "th.co.cdgs.flutter_mqtt/th.co.cdgs.flutter_mqtt.receiver.BootBroadcastReceiver" -a android.intent.action.BOOT_COMPLETED
 */
class BootBroadcastReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) = goAsync {
        if (intent.action.equals(Intent.ACTION_BOOT_COMPLETED)) {
            WorkManagerRequestHelper.startPeriodicWorker(context)
        }
    }
}
