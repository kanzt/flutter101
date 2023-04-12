package th.co.cdgs.flutter_mqtt_plugin.receiver

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.launch
import th.co.cdgs.flutter_mqtt_plugin.util.WorkManagerRequestUtil
import kotlin.coroutines.CoroutineContext
import kotlin.coroutines.EmptyCoroutineContext


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
            WorkManagerRequestUtil.startOneTimeHiveMqttNotificationServiceWorker(context)
        }
    }
}

fun BroadcastReceiver.goAsync(
    context: CoroutineContext = EmptyCoroutineContext,
    block: suspend CoroutineScope.() -> Unit
) {
    val pendingResult = goAsync()
    CoroutineScope(SupervisorJob()).launch(context) {
        try {
            block()
        } finally {
            pendingResult.finish()
        }
    }
}
