import Foundation
import Flutter

enum FlutterMqttCall {
    case initialize(Initialize)
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
                                                ))
            return .initialize(initializeArgs)
        default:
            return .unknown
        }
    }
}
