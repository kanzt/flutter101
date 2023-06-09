import Foundation
import Flutter

enum FlutterMqttCall {
    case initialize(Initialize)
    case unknown
}

enum FlutterMqttEventChannel {
    case getAPNSToken(Initialize)
    case unknown
}

class Extractor {
    private enum PossibleFlutterMqttCall: String, CaseIterable {
        case initialize = "initialize"
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
                                                    requestBadgePermission: result["requestBadgePermission"] as? Bool
                                                ),
                                            dispatcherHandle: result["dispatcher_handle"] as? NSNumber,
                                            receiveBackgroundNotificationCallbackHandle: result["receive_background_notification_callback_handle"]as? NSNumber)
            return .initialize(initializeArgs)
        default:
            return .unknown
        }
    }
    
    
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
                                                    requestBadgePermission: args["requestBadgePermission"] as? Bool
                                                ),
                                            dispatcherHandle: nil,
                                            receiveBackgroundNotificationCallbackHandle: nil
            )
            
            return .getAPNSToken(initializeArgs)
        default:
            return .unknown
        }
    }
}
