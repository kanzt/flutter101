package th.co.cdgs.flutter_mqtt.receiver

import android.app.NotificationManager
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log
import androidx.core.app.NotificationManagerCompat
import io.flutter.FlutterInjector
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.embedding.engine.dart.DartExecutor.DartCallback
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.EventSink
import io.flutter.view.FlutterCallbackInformation
import th.co.cdgs.flutter_mqtt.util.NotificationHelper
import th.co.cdgs.flutter_mqtt.util.NotificationHelper.CANCEL_NOTIFICATION
import th.co.cdgs.flutter_mqtt.util.NotificationHelper.NOTIFICATION_ID
import th.co.cdgs.flutter_mqtt.util.NotificationHelper.extractNotificationResponseMap
import th.co.cdgs.flutter_mqtt.util.SharedPreferenceHelper

class ActionBroadcastReceiver : BroadcastReceiver() {
    private var engine: FlutterEngine? = null
    private var eventSink: EventSink? = null
    private val cache: MutableList<Map<String, Any?>> = mutableListOf()

    companion object {
        private val TAG = ActionBroadcastReceiver::class.java.simpleName
        const val ACTION_TAPPED =
            "th.co.cdgs.flutter_mqtt.receiver.ActionBroadcastReceiver.ACTION_TAPPED"
    }

    override fun onReceive(context: Context?, intent: Intent?) {
        if (!ACTION_TAPPED.equals(intent!!.action, ignoreCase = true)) {
            return
        }

        val action: Map<String, Any?> = extractNotificationResponseMap(intent)
        if (intent.getBooleanExtra(CANCEL_NOTIFICATION, false)) {
            Log.d("Paper", (action[NOTIFICATION_ID] as Int).toString())
            NotificationManagerCompat.from(context!!).apply {
                cancel(action[NOTIFICATION_ID] as Int)
            }

            with((context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager)) {
                if (this.activeNotifications.size == 1) {
                    this.activeNotifications.find {
                        it.id == NotificationHelper.GROUP_PUSH_NOTIFICATION_ID
                    }?.also {
                        this.cancelAll()
                    }
                }
            }
        }

        addItem(action)

        startEngine(context)
    }

    private fun startEngine(context: Context?) {
        if (engine != null) {
            Log.e(TAG, "Engine is already initialised")
            return
        }

        val injector = FlutterInjector.instance()
        val loader = injector.flutterLoader()

        loader.startInitialization(context!!)
        loader.ensureInitializationComplete(context, null)

        engine = FlutterEngine(context)

        val dispatcherHandle = SharedPreferenceHelper.getDispatchHandle(context!!)
        if (dispatcherHandle == -1L) {
            Log.w(TAG, "Callback information could not be retrieved")
            return
        }

        val dartExecutor: DartExecutor = engine!!.dartExecutor
        initializeEventChannel(dartExecutor)

        val dartBundlePath = loader.findAppBundlePath()
        val flutterCallbackInfo = FlutterCallbackInformation.lookupCallbackInformation(dispatcherHandle)
        dartExecutor.executeDartCallback(
            DartCallback(context.assets, dartBundlePath, flutterCallbackInfo)
        )
    }

    private fun initializeEventChannel(dartExecutor: DartExecutor) {
        val channel = EventChannel(
            dartExecutor.binaryMessenger, "th.co.cdgs/flutter_mqtt/actions"
        )

        channel.setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                for (item in cache) {
                    Log.d(TAG, "Submit to Dart")
                    events!!.success(item)
                }

                cache.clear()
                eventSink = events
            }

            override fun onCancel(arguments: Any?) {
                eventSink = null
            }

        })
    }

    private fun addItem(item: Map<String, Any?>) {
        if (eventSink != null) {
            Log.d(TAG, "Submit to Dart")
            eventSink!!.success(item)
        } else {
            cache.add(item)
        }
    }
}