package th.co.cdgs.flutter_mqtt.entity

data class InitializationSettings(val MQTTConnectionSetting: MQTTConnectionSetting, val notificationSettings: NotificationSettings)

data class NotificationSettings(val androidNotificationSetting: AndroidNotificationSetting)

data class AndroidNotificationSetting(val channelName: String, val channelId: String, val notificationIcon: String)