package th.co.cdgs.flutter_mqtt

import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel

// TODO : 12/05/2023 ไม่ได้ใช้งานแล้วเตรียมลบออก
class FlutterMqttStreamHandler(private val messenger: BinaryMessenger) : EventChannel.StreamHandler {
    companion object{
        var onTokenUpdateEventSink: EventChannel.EventSink? = null
        var onOpenedNotificationEventSink: EventChannel.EventSink? = null

        /**
         * onReceiveNotification
         */
        var notificationEventChannelSink: EventChannel.EventSink? = null

        private const val tokenChannelName = "th.co.cdgs.flutter_mqtt_plugin/token"
        private const val NOTIFICATION_EVENT_CHANNEL_NAME = "th.co.cdgs/flutter_mqtt/notification"
        private const val openNotificationChannelName = "th.co.cdgs.flutter_mqtt_plugin/onOpenedNotification"
    }

    init{
        initEventChannel()
    }

    private fun initEventChannel() {
        val tokenUpdateEventChannel =
            EventChannel(messenger, tokenChannelName)
        val notificationEventChannel =
            EventChannel(messenger, NOTIFICATION_EVENT_CHANNEL_NAME)
        val openNotificationEventChannel =
            EventChannel(messenger, NOTIFICATION_EVENT_CHANNEL_NAME)

        tokenUpdateEventChannel.setStreamHandler(this)
        notificationEventChannel.setStreamHandler(this)
        openNotificationEventChannel.setStreamHandler(this)
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        if ((arguments as String?) == tokenChannelName) {
            onTokenUpdateEventSink = events
        } else if (arguments == NOTIFICATION_EVENT_CHANNEL_NAME) {
            notificationEventChannelSink = events
        } else if (arguments == openNotificationChannelName) {
            onOpenedNotificationEventSink = events
        }
    }

    override fun onCancel(arguments: Any?) {
        if ((arguments as String?) == tokenChannelName) {
            onTokenUpdateEventSink = null
        } else if (arguments == NOTIFICATION_EVENT_CHANNEL_NAME) {
            notificationEventChannelSink = null
        } else if (arguments == openNotificationChannelName) {
            onOpenedNotificationEventSink = null
        }
    }
}