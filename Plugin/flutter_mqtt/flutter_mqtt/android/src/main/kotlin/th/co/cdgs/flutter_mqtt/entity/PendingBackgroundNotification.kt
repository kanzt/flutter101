package th.co.cdgs.flutter_mqtt.entity

import com.hivemq.client.mqtt.mqtt3.message.publish.Mqtt3Publish


data class PendingBackgroundNotification(
    val notificationId : Int,
    val payload : String,
    val mqtt3Publish: Mqtt3Publish?
)
