package th.co.cdgs.flutter_mqtt_plugin.entity

data class InitializationSettings(val connectionSetting: ConnectionSetting, val notificationSettings: NotificationSettings)

data class NotificationSettings(val androidNotificationSetting: AndroidNotificationSetting)

data class AndroidNotificationSetting(val channelName: String, val channelId: String, val notificationIcon: String)