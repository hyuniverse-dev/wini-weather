import UIKit
import Flutter
import workmanager

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    if #available(iOS 10.0, *){
    UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    }

    // In AppDelegate.application method
    WorkmanagerPlugin.registerTask(withIdentifier: "task-identifier")

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
