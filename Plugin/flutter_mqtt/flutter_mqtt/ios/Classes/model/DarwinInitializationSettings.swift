struct DarwinInitializationSettings {
    let requestAlertPermission: Bool?
    let requestSoundPermission: Bool?
    let requestBadgePermission: Bool?
    let notificationCategories: [DarwinNotificationCategory]?
}

struct DarwinNotificationCategory {
    let identifier: String?
    let actions: [DarwinNotificationAction]?
    let options: UNNotificationCategoryOptions?
}

struct DarwinNotificationAction{
    let identifier: String?
    let title: String?
    let options: UNNotificationActionOptions?
    let buttonTitle: String?
    let placeholder: String?
}
