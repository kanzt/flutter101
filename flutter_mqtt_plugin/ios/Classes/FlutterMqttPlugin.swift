import Flutter
import UIKit
import Combine


let tokenChannelName  = "th.co.cdgs.flutter_mqtt_plugin/token";
let messageChannelName = "th.co.cdgs.flutter_mqtt_plugin/onReceivedMessage";
let openNotificationChannelName = "th.co.cdgs.flutter_mqtt_plugin/onOpenedNotification";
let initialNotificationChannelName = "th.co.cdgs.flutter_mqtt_plugin/initialNotification";

// PreferenceKeys
let keyIsAppInTerminatedState = "th.co.cdgs.flutter_mqtt_plugin/is_app_in_terminated_state"
let keyRecentNotification = "th.co.cdgs.flutter_mqtt_plugin/recent_notification"

@available(iOS 13.0, *)
public class FlutterMqttPlugin: FlutterPluginAppLifeCycleDelegate, FlutterPlugin {
    
    private var onTokenUpdateEventSink: FlutterEventSink?
    private var onOpenedNotificationEventSink: FlutterEventSink?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "flutter_mqtt_plugin", binaryMessenger: registrar.messenger())
        let instance = FlutterMqttPlugin()
        
        let tokenUpdateEventChannel = FlutterEventChannel(name: tokenChannelName, binaryMessenger: registrar.messenger())
        let messageEventChannel = FlutterEventChannel(name: messageChannelName, binaryMessenger: registrar.messenger())
        let openNotificationEventChannel = FlutterEventChannel(name: openNotificationChannelName, binaryMessenger: registrar.messenger())
        
        tokenUpdateEventChannel.setStreamHandler(instance)
        messageEventChannel.setStreamHandler(instance)
        openNotificationEventChannel.setStreamHandler(instance)
        
        registrar.addMethodCallDelegate(instance, channel: channel)
        registrar.addApplicationDelegate(instance)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "initialNotification":
            pushLocalNotification(result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    public override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [AnyHashable : Any] = [:]) -> Bool {
        print("didFinishLaunchingWithOptions invoke()")
        NotificationCenter.default.addObserver(self, selector: #selector(appWillTerminate), name: UIApplication.willTerminateNotification, object: nil)
        
        /// Request push noification permission
        requestPushNotificationPermission(application)
        
        return true
    }
    
    @objc func appWillTerminate() {
        // ApplicationLifecycle.WillTerminate()
    }
    
    public override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        print("Device Token: \(token)")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.onTokenUpdateEventSink?(token)
        }
    }
    
    public override func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
    
    /// ปัญหา didReceiveRemoteNotification ของ Plugin ไม่ทำงาน เลยย้ายไปใช้ของ AppDelegate แทน
    /// https://stackoverflow.com/questions/60760123/flutter-didreceiveremotenotification-not-called
    /// https://github.com/flutter/flutter/issues/52895
    //    @nonobjc public override func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    //        guard let aps = userInfo["aps"] as? [String: AnyObject] else {
    //            completionHandler(.failed)
    //            return
    //        }
    //        /// Do stuff when user received  notification in Foreground / Background / Terminated
    //        /// e.g. Update UI
    //
    //        if aps["content-available"] as? Int == 1 {
    //            /// Convert dictionary to json and then save in UserDefaults
    //            if let theJSONData = try? JSONSerialization.data(
    //                withJSONObject: userInfo,
    //                options: []) {
    //                let notificationPayload = String(data: theJSONData,
    //                                                 encoding: .utf8)
    //                print("Notification payload = \(notificationPayload!)")
    //                self.onReceivedMessageEventSink?(notificationPayload)
    //            }
    //        }
    //
    //        return completionHandler(.newData)
    //    }
    
}

@available(iOS 13.0, *)
extension FlutterMqttPlugin {
    /// Handling notification action here (Foreground / Background / Terminated
    /// e.g. user click notification or action button
    public override func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("get message didReceive :  \(response)")
        
        let userInfo = response.notification.request.content.userInfo
        guard userInfo["aps"] is [String: AnyObject] else {
            completionHandler()
            return
        }
        
        if let theJSONData = try? JSONSerialization.data(
            withJSONObject: userInfo,
            options: []) {
            let notificationPayload = String(data: theJSONData, encoding: .utf8)
            
            self.onOpenedNotificationEventSink?(notificationPayload)
        }
        
        completionHandler()
    }
    
    public override func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        /// In iOS 14 .alert is deprecated
        /// Ref : https://stackoverflow.com/a/68813049
        if #available(iOS 14.0, *) {
            completionHandler([.banner, .list, .badge, .sound])
        }else{
            completionHandler([.alert, .badge, .sound])
        }
    }
    
    private func requestPushNotificationPermission(_ application: UIApplication){
        // Prompt for permission to send notifications
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { success, _ in
                guard success else {
                    return
                }
                print("Push notification granted")
                
                /// Register delegate
                UNUserNotificationCenter.current().delegate = self
                self.getNotificationSettings()
            }
        )
    }
    
    private func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            print("Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                /// Register remote notification
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    private func pushLocalNotification(_ result: @escaping FlutterResult){
        if let recentNotificationString = UserDefaults.standard.string(forKey: keyRecentNotification) {
            UserDefaults.standard.set(nil, forKey: keyRecentNotification)
            result(recentNotificationString)
        }
        
        result(nil)
    }
}

@available(iOS 13.0, *)
extension FlutterMqttPlugin : FlutterStreamHandler {
    /// 2 Eventsinks https://stackoverflow.com/questions/61138270/how-to-use-multiple-eventchannel-in-flutter-ios-native-code-swift
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        if arguments as? String == tokenChannelName {
            onTokenUpdateEventSink = events
        }else if arguments as? String == messageChannelName {
            NotificationHandler.shared.onReceivedNotificationEventSink = events
        }else if arguments as? String == openNotificationChannelName {
            onOpenedNotificationEventSink = events
        }
        return nil
    }
    
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        if arguments as? String == tokenChannelName {
            onTokenUpdateEventSink = nil
        }else if arguments as? String == messageChannelName {
            NotificationHandler.shared.onReceivedNotificationEventSink = nil
        }else if arguments as? String == openNotificationChannelName {
            onOpenedNotificationEventSink = nil
        }
        return nil
    }
}

public class NotificationHandler {
    var onReceivedNotificationEventSink: FlutterEventSink?
    public static let shared = NotificationHandler()
    
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
                    UIApplication.shared.applicationIconBadgeNumber += 2
                    self.onReceivedNotificationEventSink?(notificationPayload)
                
                } else{
                    /// Background & Terminated
                    UIApplication.shared.applicationIconBadgeNumber += 1
                    if let recentNotification = UserDefaults.standard.string(forKey: keyRecentNotification) {
                        UserDefaults.standard.set("\(recentNotification)|\(String(describing: notificationPayload!))", forKey: keyRecentNotification)
                    }else{
                        /// First time
                        UserDefaults.standard.set("\(notificationPayload!)", forKey: keyRecentNotification)
                    }
                }
            }
        }
        
        completionHandler(.newData)
    }
    
    private func isApplicationRunInForeground() -> Bool {
        // Check is app running in Foreground (Traditional way by Tanut)
        let isUserTerminatedApp = UserDefaults.standard.bool(forKey: keyIsAppInTerminatedState)
        var debug = UserDefaults.standard.string(forKey: "debug") ?? ""
        debug += "\n\(isUserTerminatedApp) : \(UIApplication.shared.applicationState.rawValue) at isUserTerminatedApp() \(Date())"
        
        UserDefaults.standard.set(debug, forKey: "debug")
        print(debug)
        
        /// Foreground state UIApplication.shared.applicationState.rawValue = 0
        /// Background & Terminated state UIApplication.shared.applicationState.rawValue = 2
        return UIApplication.shared.applicationState == .active
    }
}
