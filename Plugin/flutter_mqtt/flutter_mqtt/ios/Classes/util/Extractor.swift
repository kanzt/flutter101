import Foundation
import Flutter

enum FlutterMqttCall {
    case initialize(Initialize)
    case getNotificationAppLaunchDetails
    case unknown
}

enum FlutterMqttEventChannel {
    case getAPNSToken(Initialize)
    case unknown
}

class Extractor {
    private enum PossibleFlutterMqttCall: String, CaseIterable {
        case initialize = "initialize"
        case getNotificationAppLaunchDetails = "getNotificationAppLaunchDetails"
        case unknown
        
        static func fromRawMethodName(_ metthodName: String) -> PossibleFlutterMqttCall {
            return PossibleFlutterMqttCall.allCases.first { it in
                it.rawValue == metthodName
            } ?? .unknown
        }
    }
    
    static func extractFlutterMqttCallFromRawMethodName(_ call: FlutterMethodCall) -> FlutterMqttCall{
        switch (PossibleFlutterMqttCall.fromRawMethodName(call.method)){
        case PossibleFlutterMqttCall.initialize :
            guard let result = call.arguments as? [String:Any] else {
                return .unknown
            }
            
            let initializeArgs = Initialize(darwinInitializationSettings:
                                                DarwinInitializationSettings(
                                                    requestAlertPermission: result["requestAlertPermission"] as? Bool,
                                                    requestSoundPermission: result["requestSoundPermission"] as? Bool,
                                                    requestBadgePermission: result["requestBadgePermission"] as? Bool,
                                                    notificationCategories: extractDarwinNotificationCategory(result["notificationCategories"] as? [[String:Any]])
                                                ),
                                            dispatcherHandle: result["dispatcher_handle"] as? NSNumber,
                                            receiveBackgroundNotificationCallbackHandle: result["receive_background_notification_callback_handle"]as? NSNumber,
                                            tapActionBackgroundNotificattionCallbackHandle: result["tap_action_background_notification_callback_handle"]as? NSNumber
            )
            return .initialize(initializeArgs)
        case PossibleFlutterMqttCall.getNotificationAppLaunchDetails : return .getNotificationAppLaunchDetails
        default:
            return .unknown
        }
    }
    
    private static func extractDarwinNotificationCategory(_ notificationCategories: [[String:Any]]?) -> [DarwinNotificationCategory]? {
        var resultCategory: [DarwinNotificationCategory]? = []
        if let notificationCategories = notificationCategories {
            for category in notificationCategories {
                var resultAction: [DarwinNotificationAction]? = []
                let actions = category["actions"] as? [[String:Any]]?
                if let actions = actions {
                    for action in actions! {
                        var resultOptions = UNNotificationActionOptions.init(rawValue: 0)
                        let options = action["options"] as? [Int]?
                        if let options = options {
                            for option in options! {
                                resultOptions.insert(UNNotificationActionOptions(rawValue: UInt(option)))
                                // resultOptions?.append(option)
                            }
                        }
                        resultAction?.append(
                            DarwinNotificationAction(
                                identifier: action["identifier"] as? String,
                                title: action["title"] as? String,
                                options: resultOptions,
                                buttonTitle: action["buttonTitle"] as? String,
                                placeholder: action["placeholder"] as? String
                            )
                        )
                    }
                }
                
                var resultOptions = UNNotificationCategoryOptions.init(rawValue: 0)
                let options = category["options"] as? [Int]?
                if let options = options {
                    for option in options! {
                        resultOptions.insert(UNNotificationCategoryOptions(rawValue: UInt(option)))
                    }
                }
                
                resultCategory?.append(
                    DarwinNotificationCategory(
                        identifier: category["identifier"] as? String,
                        actions: resultAction,
                        options: resultOptions
                    )
                )
            }
            return resultCategory
        }
        
        return nil
    }
    
//    private func parseNotificationCategoryOptions(_ options: [Int]?){
//        if let options = options {
//            var result = []
//            for option in options {
//                result |= option
//            }
//            return result
//        }
//    }
    
    private enum PossibleFlutterMqttEventChannel: String, CaseIterable {
        case getAPNSToken = "th.co.cdgs/flutter_mqtt/apnsToken"
        case unknown
        
        static func fromRawChannelName(_ channelName: String) -> PossibleFlutterMqttEventChannel {
            return PossibleFlutterMqttEventChannel.allCases.first { it in
                it.rawValue == channelName
            } ?? .unknown
        }
    }
    
    static func extractFlutterMqttEventChannel(_ dict: [String:Any]?) -> FlutterMqttEventChannel{
        guard let args = dict else {
            return .unknown
        }
        let channelName = args["eventName"] as? String ?? ""
        switch (PossibleFlutterMqttEventChannel.fromRawChannelName(channelName)){
        case PossibleFlutterMqttEventChannel.getAPNSToken :
            let initializeArgs = Initialize(darwinInitializationSettings:
                                                DarwinInitializationSettings(
                                                    requestAlertPermission: args["requestAlertPermission"] as? Bool,
                                                    requestSoundPermission: args["requestSoundPermission"] as? Bool,
                                                    requestBadgePermission: args["requestBadgePermission"] as? Bool,
                                                    notificationCategories: nil
                                                ),
                                            dispatcherHandle: nil,
                                            receiveBackgroundNotificationCallbackHandle: nil, tapActionBackgroundNotificattionCallbackHandle: nil
            )
            
            return .getAPNSToken(initializeArgs)
        default:
            return .unknown
        }
    }
}
