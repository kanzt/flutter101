import Flutter

class FlutterMqttBackgroundHandler {
    private var onBackgroundInitialized: (() -> Void)?
    
    init(onBackgroundInitialized: (() -> Void)?) {
        self.onBackgroundInitialized = onBackgroundInitialized
    }
    
    func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch (call.method){
        case "backgroundChannelInitialized" :
            self.onBackgroundInitialized?()
            break
        case "getReceiveBackgroundNotificationCallbackHandle":
            let callbackHandle = UserDefaults.standard.integer(forKey: keyReceiveBackgroundNotificationCallbackHandle)
            if callbackHandle != 0{
                result(callbackHandle)
            }else{
                result(nil)
                //                result(FlutterError(code: "receive_background_notification_callback_handle_not_found"
                //                                    , message: "The CallbackHandle could not be found. Please make sure it has been set when you initialize plugin", details: nil))
            }
            break
        case "getTapActionBackgroundNotificationCallbackHandle":
            let callbackHandle = UserDefaults.standard.integer(forKey: keyGetTapActionBackgroundNotificationCallbackHandle)
            if callbackHandle != 0{
                result(callbackHandle)
            }else{
                result(nil)
            }
            break
        default : result(FlutterMethodNotImplemented)
        }
    }
}
