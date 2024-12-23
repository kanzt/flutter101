import UIKit
import Flutter
import CoreLocation

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
    var timer : Timer?
    
    var eventSink: FlutterEventSink?
    
    var locationManager: CLLocationManager?
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // Register Method Handler
        registerMethodHandler()
        
        // Register Event Channel
        registerEventChannel()
        
        // Observe location change
        observeLocationChange()
        
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func observeLocationChange(){
        // Reference : https://www.advancedswift.com/user-location-in-swift
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.allowsBackgroundLocationUpdates = true
        // ระยะเกิน 50M จึงจะอัพเดท
        // locationManager?.distanceFilter = 50
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.requestAlwaysAuthorization()
    }
    
    func registerEventChannel(){
        let EVENTCHANNEL = "connect_status"
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        let eventChannel = FlutterEventChannel(name: EVENTCHANNEL, binaryMessenger: controller.binaryMessenger)
        let handler = ConnectStatusStreamHandler()
        eventChannel.setStreamHandler(handler)
        
        class ConnectStatusStreamHandler: NSObject, FlutterStreamHandler {
            
            func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
                events("Event channel is connected")
                return nil
            }
            
            func onCancel(withArguments arguments: Any?) -> FlutterError? {
                return nil
            }
        }
        
        
        let FOREGROUND_EVENTCHANNEL = "foreground_service_stream"
        let foregroundServiceEventChannel = FlutterEventChannel(name: FOREGROUND_EVENTCHANNEL, binaryMessenger: controller.binaryMessenger)
        foregroundServiceEventChannel.setStreamHandler(self)
        
    }
    
    func registerMethodHandler(){
        let METHODCHANNEL = "example_service"
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        let methodChannel = FlutterMethodChannel(name: METHODCHANNEL,
                                                 binaryMessenger: controller.binaryMessenger)
        
        methodChannel.setMethodCallHandler({
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            // Note: this method is invoked on the UI thread.
            switch call.method {
            case "startExampleService", "startExampleBackgroundService":
                if self.timer != nil {
                    self.timer?.invalidate()
                    self.timer = nil
                }
                DispatchQueue.global(qos: .background).async {
                    if #available(iOS 10.0, *) {
                        self.timer = Timer(timeInterval: 2, repeats: true) { _ in
                            print("Running from ID : \(self.currentQueueName()!)")
                            
                            if let events = self.eventSink {
                                events("Sink | Running from ID : \(self.currentQueueName()!)")
                            }
                        }
                    } else {
                        // Fallback on earlier versions
                    }
                    let runLoop = RunLoop.current
                    runLoop.add(self.timer!, forMode: .default)
                    runLoop.run()
                }
            case "stopExampleService", "stopExampleBackgroundService":
                self.timer?.invalidate()
                self.timer = nil
            default:
                result(FlutterMethodNotImplemented)
            }
        })
    }
    
    func currentQueueName() -> String? {
        let name = __dispatch_queue_get_label(nil)
        return String(cString: name, encoding: .utf8)
    }
    
    override func applicationDidEnterBackground(_ application: UIApplication) {
        var identifier: UIBackgroundTaskIdentifier? = nil
        identifier = UIApplication.shared.beginBackgroundTask {
            if self.timer != nil {
                self.timer?.invalidate()
                self.timer = nil
            }
            
            if #available(iOS 10.0, *) {
                self.timer = Timer(timeInterval: 2, repeats: true) { _ in
                    NSLog("Running from ID : \(self.currentQueueName()!)")
                }
            } else {
                // Fallback on earlier versions
            }
            let runLoop = RunLoop.current
            runLoop.add(self.timer!, forMode: .default)
            runLoop.run()
            UIApplication.shared.endBackgroundTask(identifier!)
        }
    }
    
}

extension AppDelegate : FlutterStreamHandler, CLLocationManagerDelegate {
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events
        return nil
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        return nil
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            print("Permission notDetermined")
        case .authorizedAlways, .authorizedWhenInUse:
            // self.locationManager?.startUpdatingLocation()
            self.locationManager?.startUpdatingLocation()
        default:
            break
        }
    }
    
    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        if let location = locations.last {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            if let event = eventSink {
                event("Latitude : \(latitude) | Longitude : \(longitude)")
            }
        }
    }
    
    func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: Error
    ) {
        // Handle failure to get a user’s location
        print("Failed to retrieve location")
    }
    
}
