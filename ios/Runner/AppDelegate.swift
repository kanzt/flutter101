import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

  <!-- API KEY for Google map -->
    [GMSServices provideAPIKey:@"AIzaSyDReMqEF7x9TP1mwya__B6mVBqNH7x-yrU"];
    [GeneratedPluginRegistrant registerWithRegistry:self];

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
