import Flutter
import UIKit

/// MethodChannel
let methodChannel  = "th.co.cdgs/flutter_mqtt";
/// EventChannel
let apnsTokenEventChannel  = "th.co.cdgs/flutter_mqtt/apnsToken";

/// PreferenceKeys
let keyIsAppInTerminatedState = "th.co.cdgs.flutter_mqtt/is_app_in_terminated_state"
let keyRecentNotification = "th.co.cdgs.flutter_mqtt/recent_notification"
let keyDispatcherHandle = "th.co.cdgs.flutter_mqtt/dispatcherHandle"
let keyReceiveBackgroundNotificationCallbackHandle = "th.co.cdgs.flutter_mqtt/receiveBackgroundNotificationCallbackHandle"


@available(iOS 13.0, *)
public class FlutterMqttPlugin: FlutterPluginAppLifeCycleDelegate, FlutterPlugin {
    
    private var onTokenUpdateEventSink: FlutterEventSink?
    private var token: String?
    private var notificationPresentationOptions: UNNotificationPresentationOptions = []
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: methodChannel, binaryMessenger: registrar.messenger())
        NotificationHandler.shared.channel = channel
        
        let instance = FlutterMqttPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
        registrar.addApplicationDelegate(instance)
        
        let tokenUpdateEventChannel = FlutterEventChannel(name: apnsTokenEventChannel, binaryMessenger: registrar.messenger())
        tokenUpdateEventChannel.setStreamHandler(instance)
        
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch Extractor.extractFlutterMqttCallFromRawMethodName(call) {
        case .initialize(let args) :
            initialize(args, result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    private func initialize(_ args: Initialize, _ result: @escaping FlutterResult){
        requestPushNotificationPermission(args, result)
        
        // Save callback for background isolated
        if args.dispatcherHandle != nil && args.receiveBackgroundNotificationCallbackHandle != nil {
            UserDefaults.standard.set(args.dispatcherHandle, forKey: keyDispatcherHandle)
            UserDefaults.standard.set(args.receiveBackgroundNotificationCallbackHandle, forKey: keyReceiveBackgroundNotificationCallbackHandle)
        }
    }
    
    private func requestPushNotificationPermission(_ args: Initialize?,_ result: FlutterResult?){
        var authOptions: UNAuthorizationOptions = []
        // Prompt for permission to send notifications
        if(args?.darwinInitializationSettings?.requestAlertPermission == true){
            notificationPresentationOptions.insert(.alert)
            authOptions.insert(.alert)
        }
        if(args?.darwinInitializationSettings?.requestBadgePermission == true){
            notificationPresentationOptions.insert(.badge)
            authOptions.insert(.badge)
        }
        if(args?.darwinInitializationSettings?.requestSoundPermission == true){
            notificationPresentationOptions.insert(.sound)
            authOptions.insert(.sound)
        }
        
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { success, _ in
                guard success else {
                    result?(false)
                    return
                }
                print("Push notification granted")
                /// Register delegate
                UNUserNotificationCenter.current().delegate = self
                self.getNotificationSettings(result)
            }
        )
    }
    
    private func getNotificationSettings(_ result: FlutterResult?) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            print("Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                /// Register remote notification
                UIApplication.shared.registerForRemoteNotifications()
                result?(true)
            }
        }
    }
    
    public override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        token = tokenParts.joined()
        print("Device Token: \(String(describing: token))")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.onTokenUpdateEventSink?(self.token)
        }
        
    }
    
    public override func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(notificationPresentationOptions)
    }
    
    public override func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
    
}


@available(iOS 13.0, *)
extension FlutterMqttPlugin : FlutterStreamHandler {
    
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        switch Extractor.extractFlutterMqttEventChannel(arguments as? [String : Any]) {
        case .getAPNSToken(let args) :
            onSubscribeToTokenUpdate(events, args)
        default:
            return nil
        }
        
        return nil
    }
    
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        switch Extractor.extractFlutterMqttEventChannel(arguments as? [String : Any]) {
        case .getAPNSToken(_) :
            onTokenUpdateEventSink = nil
        default:
            return nil
        }
        
        return nil
    }
    
    private func onSubscribeToTokenUpdate(_ event: @escaping FlutterEventSink, _ args: Initialize){
        onTokenUpdateEventSink = event
        requestPushNotificationPermission(args, nil)
    }
}


public class NotificationHandler {
    public static let shared = NotificationHandler()
    var channel: FlutterMethodChannel?
    
    private init() {
    }
    
    public func onReceivedMessage(userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler:@escaping (UIBackgroundFetchResult) -> Void){
        guard let aps = userInfo["aps"] as? [String: AnyObject] else {
            completionHandler(.failed)
            return
        }
        
        if aps["content-available"] as? Int == 1 {
            /// Convert dictionary to json and then save in UserDefaults
            if let theJSONData = try? JSONSerialization.data(
                withJSONObject: userInfo,
                options: []) {
                let notificationPayload = String(data: theJSONData,
                                                 encoding: .utf8)
                print("Notification payload (Native) = \(notificationPayload!)")
                
                if isApplicationRunInForeground() {
                    /// Foreground
                    channel?.invokeMethod("didReceiveNotificationResponse", arguments: ["payload": notificationPayload])
                } else{
                    /// Background & Terminated
                   
                }
            }
        }
        
        completionHandler(.newData)
    }
    
    private func isApplicationRunInForeground() -> Bool {
        /// Foreground state UIApplication.shared.applicationState.rawValue = 0
        /// Background & Terminated state UIApplication.shared.applicationState.rawValue = 2
        return UIApplication.shared.applicationState == .active
    }
}
