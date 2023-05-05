package th.co.cdgs.flutter_mqtt

import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel

class FlutterMqttStreamHandler(private val messenger: BinaryMessenger) : EventChannel.StreamHandler {
    companion object{
        var onTokenUpdateEventSink: EventChannel.EventSink? = null
        var onReceivedNotificationEventSink: EventChannel.EventSink? = null
        var onOpenedNotificationEventSink: EventChannel.EventSink? = null

        private const val tokenChannelName = "th.co.cdgs.flutter_mqtt_plugin/token"
        private const val messageChannelName = "th.co.cdgs.flutter_mqtt_plugin/onReceivedMessage"
        private const val openNotificationChannelName = "th.co.cdgs.flutter_mqtt_plugin/onOpenedNotification"
    }

    init{
        initEventChannel()
    }

    private fun initEventChannel() {
        val tokenUpdateEventChannel =
            EventChannel(messenger, tokenChannelName)
        val messageEventChannel =
            EventChannel(messenger, messageChannelName)
        val openNotificationEventChannel =
            EventChannel(messenger, messageChannelName)

        tokenUpdateEventChannel.setStreamHandler(this)
        messageEventChannel.setStreamHandler(this)
        openNotificationEventChannel.setStreamHandler(this)
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        if ((arguments as String?) == tokenChannelName) {
            onTokenUpdateEventSink = events
        } else if (arguments == messageChannelName) {
            onReceivedNotificationEventSink = events
        } else if (arguments == openNotificationChannelName) {
            onOpenedNotificationEventSink = events
        }
    }

    override fun onCancel(arguments: Any?) {
        if ((arguments as String?) == tokenChannelName) {
            onTokenUpdateEventSink = null
        } else if (arguments == messageChannelName) {
            onReceivedNotificationEventSink = null
        } else if (arguments == openNotificationChannelName) {
            onOpenedNotificationEventSink = null
        }
    }
}