package th.co.cdgs.flutter_mqtt_plugin.receiver

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import th.co.cdgs.flutter_mqtt_plugin.util.WorkManagerRequestHelper
import th.co.cdgs.flutter_mqtt_plugin.util.goAsync


/**
 * Run these command for testing (Only non-playstore emulator)
 * adb root
 * adb shell am broadcast -n "com.example.mqttkotlinsample/com.example.mqttkotlinsample.poc.boardcastreceiver.BootBroadcastReceiver" -a android.intent.action.BOOT_COMPLETED
 */
class BootBroadcastReceiver : BroadcastReceiver() {
    companion object {
        val TAG: String = BootBroadcastReceiver::class.java.simpleName
    }

    override fun onReceive(context: Context, intent: Intent) = goAsync {
        if (intent.action.equals(Intent.ACTION_BOOT_COMPLETED)) {
            WorkManagerRequestHelper.startOneTimeWorker(context)
        }
    }
}
