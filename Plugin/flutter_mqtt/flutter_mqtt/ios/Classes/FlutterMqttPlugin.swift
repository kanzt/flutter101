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
let keyTapActionBackgroundNotificattionCallbackHandle = "th.co.cdgs.flutter_mqtt/tapActionBackgroundNotificationCallbackHandle"
let keyGetTapActionBackgroundNotificationCallbackHandle = "th.co.cdgs.flutter_mqtt/getTapActionBackgroundNotificationCallbackHandle"


@available(iOS 13.0, *)
public class FlutterMqttPlugin: FlutterPluginAppLifeCycleDelegate, FlutterPlugin {
    
    private var onTokenUpdateEventSink: FlutterEventSink?
    private var token: String?
    private var notificationPresentationOptions: UNNotificationPresentationOptions = []
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: methodChannel, binaryMessenger: registrar.messenger())
        NotificationHandler.shared.setChannel(channel)
        
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
        case .getNotificationAppLaunchDetails :
            getNotificationAppLaunchDetails(result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    public override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [AnyHashable : Any] = [:]) -> Bool {
        UserDefaults.standard.set(false, forKey: keyIsAppInTerminatedState)
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    private func initialize(_ args: Initialize, _ result: @escaping FlutterResult){
        requestPushNotificationPermission(args, result)
        
        // Save callback for background isolated
        if args.dispatcherHandle != nil && args.receiveBackgroundNotificationCallbackHandle != nil {
            UserDefaults.standard.set(args.dispatcherHandle, forKey: keyDispatcherHandle)
            UserDefaults.standard.set(args.receiveBackgroundNotificationCallbackHandle, forKey: keyReceiveBackgroundNotificationCallbackHandle)
        }
        
        if args.dispatcherHandle != nil && args.tapActionBackgroundNotificattionCallbackHandle != nil {
            UserDefaults.standard.set(args.dispatcherHandle, forKey: keyDispatcherHandle)
            UserDefaults.standard.set(args.tapActionBackgroundNotificattionCallbackHandle, forKey: keyTapActionBackgroundNotificattionCallbackHandle)
        }
    }
    
    private func getNotificationAppLaunchDetails(_ result: @escaping FlutterResult){
        var notificationAppLaunchDetails: [String:Any] = [String:Any]()
        notificationAppLaunchDetails["notificationLaunchedApp"] = NotificationHandler.shared.isLaunchingAppFromNotification()
        notificationAppLaunchDetails["notificationResponse"] = NotificationHandler.shared.getRecentTapNotification()
        result(notificationAppLaunchDetails)
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
                NSLog("Push notification granted")
                /// Register delegate
                UNUserNotificationCenter.current().delegate = self
                self.getNotificationSettings(result)
            }
        )
    }
    
    private func getNotificationSettings(_ result: FlutterResult?) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            NSLog("Notification settings: \(settings)")
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
        NSLog("Device Token: \(String(describing: token))")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.onTokenUpdateEventSink?(self.token)
        }
        
    }
    
    
    public override func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        NSLog("Failed to register: \(error)")
    }
    
    public func applicationWillTerminate(_ application: UIApplication) {
        UserDefaults.standard.set(true, forKey: keyIsAppInTerminatedState)
    }
    
    public override func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(notificationPresentationOptions)
    }
    
    
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
            let payloadDict = ["payload": notificationPayload]
            
            NotificationHandler.shared.onTapNotification(payloadDict as [String : Any])
        }
        
        completionHandler()
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
    private static var registerPlugins: FlutterPluginRegistrantCallback?
    private var backgroundMethodChannel: FlutterMethodChannel?
    private var flutterEngine: FlutterEngine?
    private var channel: FlutterMethodChannel?
    private var pendingNotification:  [[String:Any]] = [[String: Any]]()
    private var launchingAppFromNotification: Bool = false
    private var recentTapNotification: [String:Any]?
    
    private init() {
    }
    
    public static func setPluginRegistrantCallback(_ callback: FlutterPluginRegistrantCallback) {
        registerPlugins = callback
    }
    
    public func setChannel(_ channel: FlutterMethodChannel){
        self.channel = channel
    }
    
    public func getRecentTapNotification() -> [String:Any]? {
        return recentTapNotification
    }
    
    public func isLaunchingAppFromNotification() -> Bool {
        return launchingAppFromNotification
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
                NSLog("Notification payload (Native) = \(notificationPayload!)")
                let payloadDict = ["payload": notificationPayload]
                
                if isApplicationRunInForeground() {
                    /// Foreground
                    channel?.invokeMethod("didReceiveNotificationResponse", arguments: payloadDict)
                }else{
                    /// Terminated
                    if UserDefaults.standard.bool(forKey: keyIsAppInTerminatedState) {
                        let isStartBackgroundIsolate = startBackgroundChannelIfNecessary(payloadDict as [String : Any], "didReceiveNotificationResponse")
                        if !isStartBackgroundIsolate {
                            backgroundMethodChannel?.invokeMethod("didReceiveNotificationResponse", arguments: payloadDict)
                        }
                    }else{
                        /// Background
                        channel?.invokeMethod("didReceiveNotificationResponse", arguments: payloadDict)
                    }
                }
            }
        }
        
        completionHandler(.newData)
    }
    
    public func onTapNotification(_ notificationPayload: [String:Any]){
        recentTapNotification = notificationPayload
        if isApplicationRunInForeground() {
            /// Foreground
            launchingAppFromNotification = false
            channel?.invokeMethod("onTapNotification", arguments: notificationPayload)
        }else{
            /// Terminated
            if UserDefaults.standard.bool(forKey: keyIsAppInTerminatedState) {
                launchingAppFromNotification = true
                let isStartBackgroundIsolate = startBackgroundChannelIfNecessary(notificationPayload as [String : Any], "onTapNotification")
                if !isStartBackgroundIsolate {
                    backgroundMethodChannel?.invokeMethod("onTapNotification", arguments: notificationPayload)
                }
            }else{
                /// Background
                launchingAppFromNotification = false
                channel?.invokeMethod("onTapNotification", arguments: notificationPayload)
            }
        }
    }
    
    private func isApplicationRunInForeground() -> Bool {
        /// Foreground state UIApplication.shared.applicationState.rawValue = 0
        /// Background & Terminated state UIApplication.shared.applicationState.rawValue = 2
        return UIApplication.shared.applicationState == .active
    }
    
    private func startBackgroundChannelIfNecessary(_ notificationPayload: [String:Any], _ methodName: String) -> Bool {
        if !isApplicationRunInForeground() && backgroundMethodChannel == nil  {
            pendingNotification.append(notificationPayload)
            
            
            if flutterEngine == nil {
                flutterEngine = FlutterEngine(name: "FlutterMqttPluginIsolate", project: nil, allowHeadlessExecution: true)
            }
            
            let dispatcherHandle = UserDefaults.standard.integer(forKey: keyDispatcherHandle)
            guard dispatcherHandle != 0 else {
                NSLog("Callback information could not be retrieved");
                return false
            }
            
            let callbackInfo = FlutterCallbackCache.lookupCallbackInformation(Int64(dispatcherHandle))
            guard dispatcherHandle != 0 else {
                NSLog("Callback information could not be retrieved");
                return false
            }
            
            DispatchQueue.main.async {
                self.backgroundMethodChannel = FlutterMethodChannel(name: "th.co.cdgs/flutter_mqtt/background", binaryMessenger: self.flutterEngine!.binaryMessenger)
                
                let flutterMqttBackgroundHandler = FlutterMqttBackgroundHandler(
                    onBackgroundInitialized: {
                        self.pendingNotification.forEach { notification in
                            self.backgroundMethodChannel?.invokeMethod(methodName, arguments: notification)
                        }
                        self.pendingNotification.removeAll()
                    }
                )
                self.flutterEngine?.run(withEntrypoint: callbackInfo!.callbackName, libraryURI: callbackInfo!.callbackLibraryPath)
                self.backgroundMethodChannel?.setMethodCallHandler(flutterMqttBackgroundHandler.handle)
                
                if NotificationHandler.registerPlugins != nil {
                    NotificationHandler.registerPlugins!(self.flutterEngine!)
                }
            }
            
            return true
        }else{
            return false
        }
    }
}
