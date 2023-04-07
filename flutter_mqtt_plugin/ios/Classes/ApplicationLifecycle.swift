//
//  ApplicationLifecycle.swift
//  MQTTswiftsample
//
//  Created by Kantaphat Tavelertsopon on 4/7/23.
//

import Foundation

public class ApplicationLifecycle {
    public class func WillEnterForeground() {
        UserDefaults.standard.set(false, forKey: keyIsAppInterminatedState)
    }
    
    public class func DidBecomeActive() {
        UserDefaults.standard.set(false, forKey: keyIsAppInterminatedState)
    }
    
    public class func WillResignActive() {
        UserDefaults.standard.set(true, forKey: keyIsAppInterminatedState)
    }
    public class func DidEnterBackground() {
        UserDefaults.standard.set(true, forKey: keyIsAppInterminatedState)
    }
    public class func WillTerminate() {
        /// Only for iOS 12 and below
        UserDefaults.standard.set(true, forKey: keyIsAppInterminatedState)
    }
}
