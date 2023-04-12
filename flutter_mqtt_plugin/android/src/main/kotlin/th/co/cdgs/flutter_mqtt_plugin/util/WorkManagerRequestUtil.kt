package th.co.cdgs.flutter_mqtt_plugin.util

import android.content.Context
import android.util.Log
import androidx.work.*
import th.co.cdgs.flutter_mqtt_plugin.workmanager.HiveMqttNotificationServiceWorker
import java.util.concurrent.TimeUnit

object WorkManagerRequestUtil {

    private val TAG = WorkManagerRequestUtil::class.java.simpleName
    fun startOneTimeHiveMqttNotificationServiceWorker(context: Context) {
        Log.d(TAG, "startOneTimeHiveMqttNotificationServiceWorker called")
        val workManager: WorkManager = WorkManager.getInstance(context)
        val startServiceRequest =
            OneTimeWorkRequest.Builder(HiveMqttNotificationServiceWorker::class.java)
                // .setExpedited(OutOfQuotaPolicy.RUN_AS_NON_EXPEDITED_WORK_REQUEST)
                .setConstraints(
                    Constraints.Builder()
                        .setRequiredNetworkType(NetworkType.CONNECTED)
                        .setRequiresCharging(false)
                        .build()
                )
                .build()
        Log.d(TAG, "OneTimeWorkRequest id : ${startServiceRequest.id}")
        workManager.enqueue(startServiceRequest)
    }

    fun startPeriodicWorkHiveMQNotificationServiceWorkManager(context: Context) {
        Log.d(TAG, "startPeriodicWorkHiveMQNotificationServiceWorkManager called")
        val workManager = WorkManager.getInstance(context)
        workManager.cancelUniqueWork(HiveMqttNotificationServiceWorker.UNIQUE_PERIODIC_HIVE_MQTT)
        // As per Documentation: The minimum repeat interval that can be defined is 15 minutes
        // (same as the JobScheduler API), but in practice 15 doesn't work. Using 16 here
        val request = PeriodicWorkRequest.Builder(
            HiveMqttNotificationServiceWorker::class.java, 16, TimeUnit.MINUTES
        ).setConstraints(
            Constraints.Builder()
                .setRequiredNetworkType(NetworkType.CONNECTED)
                .setRequiresCharging(false)
                .build()
        )
            .build()

        Log.d(TAG, "PeriodicWorkRequest id : ${request.id}")

        // to schedule a unique work, no matter how many times app is opened i.e. startServiceViaWorker gets called
        // do check for AutoStart permission
        workManager.enqueueUniquePeriodicWork(
            HiveMqttNotificationServiceWorker.UNIQUE_PERIODIC_HIVE_MQTT,
            ExistingPeriodicWorkPolicy.KEEP,
            request
        )
    }
}